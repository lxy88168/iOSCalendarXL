//
//  RemindDetailViewControllerTableViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/30.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit
import AssetsLibrary

class RemindDetailViewControllerTableViewController: UITableViewController, UICollectionViewDataSource, CreateRemindDelegate {

    @IBOutlet weak var labelRemindContent: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRepeatAction: UILabel!
    @IBOutlet weak var labelDelayAction: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelRemarks: UILabel!
    @IBOutlet weak var collectionViewAudios: UICollectionView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var labelCalendar: UILabel!
    
    var audioCollectionViewHeightConstraint: NSLayoutConstraint?
    var imageCollectionViewHeightConstraint: NSLayoutConstraint?
    var audioClips = [Media]()
    var images = [Media]()
    
    var remind: Remind? {
        didSet {
            audioClips.removeAll()
            images.removeAll()
            if let tempRemind = remind {
                tempRemind.medias.forEach({(media) in
                    if media.type == Media.MediaType.Audio {
                        audioClips.append(media)
                    } else if media.type == Media.MediaType.Image {
                        images.append(media)
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        labelCalendar.layer.borderColor = UIColor(red: 1, green: 0.5, blue: 0.2, alpha: 1).cgColor
        labelCalendar.layer.borderWidth = 1
        labelCalendar.layer.cornerRadius = 3
        
        var cellNib = UINib(nibName: "AudioClipCell", bundle: nil)
        collectionViewAudios.register(cellNib, forCellWithReuseIdentifier: "audioClipCell")
        cellNib = UINib(nibName: "ImageCell", bundle: nil)
        collectionViewImages.register(cellNib, forCellWithReuseIdentifier: "imageCell")
        
        var layout =  collectionViewAudios.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: 70, height: 70)
        
        layout =  collectionViewImages.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: 70, height: 70)
        
        updateView()
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "系统提示", message: "您确定要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "点错了", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            if let notifications = UIApplication.shared.scheduledLocalNotifications {
                notifications.forEach({(notification) in
                    if let userInfo = notification.userInfo {
                        if let remindFilePath = userInfo["remindFilePath"] as? String {
                            if remindFilePath == self.remind?.filePath {
                                UIApplication.shared.cancelLocalNotification(notification)
                            }
                        }
                    }
                })
            }
            do {
                try FileManager.default.removeItem(atPath: (self.remind?.filePath)!)
            } catch let error as NSError {
                print("delete remind occurred error: \(error)")
            }
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        performSegue(withIdentifier: "showEditController", sender: remind)
    }
    
    func updateView() {
        labelRemindContent.text = remind?.content
        let formater = DateFormatter()
        formater.dateFormat = "yyyy年MM月dd日 hh:mm"
        labelDate.text = formater.string(from: (remind?.date)!)
        labelRemarks.text = remind?.remarks
        labelLocation.text = remind?.location
        labelRepeatAction.text = "不重复"
        if remind?.repeatType == RemindRepeatType.RepeatPerDay {
            labelRepeatAction.text = "每日"
        } else if remind?.repeatType == RemindRepeatType.RepeatPerMonth {
            labelRepeatAction.text = "每月"
        } else if remind?.repeatType == RemindRepeatType.RepeatPerWeek {
            labelRepeatAction.text = "每周"
        } else if remind?.repeatType == RemindRepeatType.RepeatPerYear {
            labelRepeatAction.text = "每年"
        }
        labelDelayAction.text = CreateRemindViewController.delayActions[(remind?.delayType.rawValue)!]
        if audioClips.count > 0 {
            updateAudioCollectionViewHeight()
            collectionViewAudios.reloadData()
        }
        
        if images.count > 0 {
            updateImageCollectionViewHeight()
            collectionViewImages.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewAudios {
            return audioClips.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewAudios {
            let media = audioClips[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audioClipCell", for: indexPath) as! AudioClipCell
            cell.setCanDelete(canDelete: false)
            cell.row = indexPath.row
            cell.owner = collectionView
            cell.media = media
            return cell
        } else {
            let media = images[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            cell.row = indexPath.row
            cell.owner = collectionView
            cell.setCanDelete(canDelete: false)
            let url = NSURL(string: media.filePath)!
            
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.asset(for: url as URL!, resultBlock: { (asset:ALAsset?) -> Void in
                if let imageRef = asset?.defaultRepresentation().fullScreenImage() {
                    cell.image.image = UIImage(cgImage: imageRef.takeUnretainedValue())
                }
            }, failureBlock: {(error) in
                print("get file path error: \(error)")
                let alert = UIAlertController(title: "系统提示", message: "遇到错误：\(error)", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            })
            return cell
        }
    }
    
    func onRemindSaved(newRemind: Remind) {
        self.remind = newRemind
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let controller = (segue.destination as! UINavigationController).topViewController as! CreateRemindViewController
        controller.delegate = self
        controller.remind = sender as? Remind
    }

    func updateAudioCollectionViewHeight() {
        let hCount = Int(collectionViewAudios.frame.width) / 70
        var row = audioClips.count / hCount
        row = audioClips.count % hCount == 0 ? row : row + 1
        if audioCollectionViewHeightConstraint == nil {
            audioCollectionViewHeightConstraint = NSLayoutConstraint(item: collectionViewAudios, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * 70))
            
            collectionViewAudios.addConstraint(audioCollectionViewHeightConstraint!)
        } else {
            audioCollectionViewHeightConstraint?.constant = CGFloat(row * 70)
        }
        let height = 12 + Double(row * 70)
        
//        audioTableCell.frame = CGRect(x: audioTableCell.frame.origin.x, y: audioTableCell.frame.origin.y, width: audioTableCell.frame.width, height: CGFloat(height))
        
        tableView.reloadData()
    }
    
    func updateImageCollectionViewHeight() {
        let hCount = Int(collectionViewImages.frame.width) / 70
        var row = images.count / hCount
        row = images.count % hCount == 0 ? row : row + 1
        if imageCollectionViewHeightConstraint == nil {
            imageCollectionViewHeightConstraint = NSLayoutConstraint(item: collectionViewImages, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * 70))
            
            collectionViewImages.addConstraint(imageCollectionViewHeightConstraint!)
        } else {
            imageCollectionViewHeightConstraint?.constant = CGFloat(row * 70)
        }
        let height = 12 + Double(row * 70)
        
//        imageTableCell.frame = CGRect(x: imageTableCell.frame.origin.x, y: imageTableCell.frame.origin.y, width: imageTableCell.frame.width, height: CGFloat(height))
        
        tableView.reloadData()
    }
}
