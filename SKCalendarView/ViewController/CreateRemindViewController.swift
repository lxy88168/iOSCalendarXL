//
//  RemindViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/23.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import Photos
//import CoreActionSheetPicker

protocol CreateRemindDelegate {
    func onRemindSaved(newRemind: Remind)
}

@IBDesignable
class CreateRemindViewController: UITableViewController, UICollectionViewDataSource, MediaCellDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AudioRecorderViewControllerDelegate, SelectLocationDelegate {
    
    @IBOutlet weak var fieldRemindText: UITextView!
    @IBOutlet weak var labelRepeat: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var fieldComment: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    
    static let repeatActions = ["不重复", "每年", "每月", "每周", "每日"]
    var currentRepeatActionIndex = 0
    var currentDate = Date()
    
    var audioRecordController: AudioRecorderViewController?
    var remind: Remind? {
        didSet {
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
    
    var delegate: CreateRemindDelegate?
    
    @IBAction func cancel(_ sender: Any) {
        let alertController = UIAlertController(title: "系统提示", message: "您确定要取消吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "点错了", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var tempRemind = remind
        if tempRemind == nil {
            tempRemind = Remind()
            tempRemind!.filePath = dataFilePath()
        } else {
            if let notifications = UIApplication.shared.scheduledLocalNotifications {
                notifications.forEach({(notification) in
                    if let userInfo = notification.userInfo {
                        if let remindFilePath = userInfo["remindFilePath"] as? String {
                            if remindFilePath == tempRemind?.filePath {
                                UIApplication.shared.cancelLocalNotification(notification)
                            }
                        }
                    }
                })
            }
        }
        tempRemind!.content = fieldRemindText.text
        tempRemind!.date = currentDate
        let repeatTextIndex = CreateRemindViewController.repeatActions.index(of: labelRepeat.text!)!
        switch repeatTextIndex {
        case 0:
            tempRemind!.repeatType = .Norepeat
            break
        case 1:
            tempRemind!.repeatType = .RepeatPerYear
            break
        case 2:
            tempRemind!.repeatType = .RepeatPerMonth
            break
        case 3:
            tempRemind!.repeatType = .RepeatPerWeek
            break
        case 4:
            tempRemind!.repeatType = .RepeatPerDay
            break
        default:
            break
        }
        tempRemind!.location = btnLocation.currentTitle
        tempRemind!.remarks = fieldComment.text
        tempRemind!.medias = []
        audioClips.forEach({(media) in
            tempRemind!.medias.append(media)
        })
        images.forEach({(media) in
            tempRemind!.medias.append(media)
        })
        
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        
        archiver.encode(tempRemind, forKey: "remind")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.write(toFile: tempRemind!.filePath!, atomically: false)
        
        let notification = UILocalNotification()
        notification.alertBody = tempRemind!.content
        notification.fireDate = tempRemind!.date
        notification.alertAction = tempRemind!.content
        notification.userInfo = ["remindFilePath": tempRemind?.filePath as Any]
        switch tempRemind!.repeatType {
        case .RepeatPerDay:
            notification.repeatInterval = .day
            break
        case .RepeatPerWeek:
            notification.repeatInterval = .weekOfMonth
            break
        case .RepeatPerYear:
            notification.repeatInterval = .year
            break
        case .RepeatPerMonth:
            notification.repeatInterval = .month
            break
        default:
            break;
        }
        
        let settings = UIUserNotificationSettings(types: .sound, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.scheduleLocalNotification(notification)
        
        delegate?.onRemindSaved(newRemind: tempRemind!)
        
        dismiss(animated: true, completion: nil)
    }
    
    //获取数据文件地址
    func dataFilePath ()->String{
        return RemindViewController.documentsDirectory().appendingFormat("/remind\(Date().timeIntervalSince1970).plist")
    }
    
    func onDelete(sender: MediaCollectionViewCell) {
        let alertController = UIAlertController(title: "系统提示", message: "您确定要删除提醒吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "点错了", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            if sender.owner == self.audioCollectionView {
                let audio = self.audioClips[sender.row]
                do {
                    try FileManager.default.removeItem(atPath: audio.filePath)
                } catch let error as NSError {
                    print("delete audio file occurred error: \(error)")
                }
                self.audioClips.remove(at: sender.row)
                self.audioCollectionView.reloadData()
                self.updateAudioCollectionViewHeight()
            } else {
                self.images.remove(at: sender.row)
                self.imageCollectionView.reloadData()
                self.updateImageCollectionViewHeight()
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var audioClips: [Media] = []
    var images: [Media] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == audioCollectionView {
            return audioClips.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == audioCollectionView {
            let media = audioClips[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audioClipCell", for: indexPath) as! AudioClipCell
            cell.row = indexPath.row
            cell.delegate = self
            cell.owner = collectionView
            cell.media = media
            return cell
        } else {
            let media = images[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            cell.row = indexPath.row
            cell.delegate = self
            cell.owner = collectionView
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
    
    @IBAction func addAudioTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "选择音频", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let pickAction = UIAlertAction(title: "从媒体库选择", style: .default, handler: {(action) in
            let picker = UIDocumentPickerViewController(documentTypes: ["public.mp3"], in: UIDocumentPickerMode.open)
            picker.delegate = self
            if #available(iOS 11.0, *) {
                picker.allowsMultipleSelection = true
            } else {
                // Fallback on earlier versions
            }
            self.present(picker, animated: true, completion: nil)
        })
        let recordAction = UIAlertAction(title: "录制", style: .default, handler: {(action) in
            self.audioRecordController = AudioRecorderViewController()
            self.audioRecordController?.audioRecorderDelegate = self
            self.present(self.audioRecordController!, animated: true, completion: nil)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(pickAction)
        sheet.addAction(recordAction)
        present(sheet, animated: true, completion: nil)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        if fileURL != nil {
            let filePath = RemindViewController.documentsDirectory().appendingFormat("/audio\(Date().timeIntervalSince1970).m4a")
            do {
                let data = try NSData(contentsOf: fileURL! as URL, options: NSData.ReadingOptions.mappedIfSafe)
                FileManager.default.createFile(atPath: filePath, contents: data as Data, attributes: nil)
                print(filePath)
                self.addMedia(type: .Audio, filePath: filePath)
            } catch let error as NSError {
                print("save audio occurred error. \(error)")
            }
        }
        audioRecordController?.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach({(url) in
            print(url)
        })
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
        addMedia(type: .Audio, filePath: url.absoluteString)
    }
    
    func addMedia(type: Media.MediaType, filePath: String) -> Void {
        if type == .Audio {
            let audio = Media(mediaType: .Audio, filePath: filePath)
            audioClips.append(audio)
            audioCollectionView.reloadData()
            updateAudioCollectionViewHeight()
        } else if type == .Image {
            let audio = Media(mediaType: .Image, filePath: filePath)
            images.append(audio)
            imageCollectionView.reloadData()
            updateImageCollectionViewHeight()
        }
    }
    
    var imagePickerController: UIImagePickerController?
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "选择图片", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let pickAction = UIAlertAction(title: "从媒体库选择", style: .default, handler: {(action) in
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController!.sourceType = .photoLibrary
            self.imagePickerController!.delegate = self
            self.present(self.imagePickerController!, animated: true, completion: nil)
        })
        let recordAction = UIAlertAction(title: "拍照", style: .default, handler: {(action) in
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController!.sourceType = .camera
            self.imagePickerController!.delegate = self
            self.present(self.imagePickerController!, animated: true, completion: nil)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(pickAction)
        sheet.addAction(recordAction)
        present(sheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if imagePickerController?.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            let url = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            let filePath = String(describing: url)
            print(filePath)
            addMedia(type: .Image, filePath: filePath)
        }
        else if imagePickerController?.sourceType == UIImagePickerControllerSourceType.camera {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            ALAssetsLibrary().writeImage(toSavedPhotosAlbum: image.cgImage, orientation: .right, completionBlock: {(url, error) in
                if error == nil {
                    let filePath = String(describing: url!)
                    print(filePath)
                    self.addMedia(type: .Image, filePath: filePath)
                } else {
                    print("error: \(error)")
                }
            })
        }
        
        imagePickerController?.dismiss(animated: true, completion: nil)
        imagePickerController = nil
    }
    
    @IBOutlet weak var audioCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        var cellNib = UINib(nibName: "AudioClipCell", bundle: nil)
        audioCollectionView.register(cellNib, forCellWithReuseIdentifier: "audioClipCell")
        cellNib = UINib(nibName: "ImageCell", bundle: nil)
        imageCollectionView.register(cellNib, forCellWithReuseIdentifier: "imageCell")
        
        var layout =  audioCollectionView.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        layout =  imageCollectionView.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        if let tempRemind = remind {
            fieldRemindText.text = tempRemind.content
            fieldComment.text = tempRemind.remarks
            let formater = DateFormatter()
            formater.dateFormat = "yyyy年MM月dd日 hh:mm"
            labelTime.text = formater.string(from: tempRemind.date)
            currentDate = tempRemind.date
            labelRepeat.text = "不重复"
            if tempRemind.repeatType == RemindRepeatType.RepeatPerDay {
                labelRepeat.text = "每日"
            } else if tempRemind.repeatType == RemindRepeatType.RepeatPerMonth {
                labelRepeat.text = "每月"
            } else if tempRemind.repeatType == RemindRepeatType.RepeatPerWeek {
                labelRepeat.text = "每周"
            } else if tempRemind.repeatType == RemindRepeatType.RepeatPerYear {
                labelRepeat.text = "每年"
            }
            currentRepeatActionIndex = CreateRemindViewController.repeatActions.index(of: labelRepeat.text!)!
            if audioClips.count > 0 {
                updateAudioCollectionViewHeight()
                audioCollectionView.reloadData()
            }
            
            if images.count > 0 {
                updateImageCollectionViewHeight()
                imageCollectionView.reloadData()
            }
        }
        labelRepeat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
    
        currentDate = Date(timeInterval: 60 * 60, since: Date())
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy年MM月dd日 hh:mm"
        labelTime.text = dateFormater.string(from: currentDate)
        labelTime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
    }
    
    @objc func labelTapped(_ tapGes : UITapGestureRecognizer) {
        if tapGes.view == labelTime {
            let datePicker = ActionSheetDatePicker(title: "选择日期和时间", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: currentDate, doneBlock: {
                picker, value, index in
                
                print("value = \(String(describing: value))")
                print("index = \(String(describing: index))")
                print("picker = \(String(describing: picker))")
                
                self.currentDate = value as! Date
                
                //date -> string
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "yyyy年MM月dd日 hh:mm"
                self.labelTime.text = myFormatter.string(from: self.currentDate)
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: labelTime)
//            let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
//            datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
//            datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
            datePicker?.locale = Locale.current
            datePicker?.timeZone = TimeZone.current
            print("time zone: \(TimeZone.current)")
            datePicker?.show()
        } else if tapGes.view == labelRepeat {
            let sheet = ActionSheetStringPicker(title: "", rows: CreateRemindViewController.repeatActions, initialSelection: currentRepeatActionIndex, doneBlock: { picker, index, value in
                self.labelRepeat.text = value as? String
                self.currentRepeatActionIndex = index
            }, cancel: {ActionSheetStringCancelBlock in return}, origin: labelRepeat)
            sheet?.show()
        }
    }
    
    var audioCollectionViewHeightConstraint: NSLayoutConstraint?
    var imageCollectionViewHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var audioTableCell: UITableViewCell!
    @IBOutlet weak var imageTableCell: UITableViewCell!
    
    func updateAudioCollectionViewHeight() {
        let hCount = Int(audioCollectionView.frame.width) / 100
        var row = audioClips.count / hCount
        row = audioClips.count % hCount == 0 ? row : row + 1
        if audioCollectionViewHeightConstraint == nil {
            audioCollectionViewHeightConstraint = NSLayoutConstraint(item: audioCollectionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * 100))
            
            audioCollectionView.addConstraint(audioCollectionViewHeightConstraint!)
        } else {
            audioCollectionViewHeightConstraint?.constant = CGFloat(row * 100)
        }
        let height = 43.5 + Double(row * 100)
        
        audioTableCell.frame = CGRect(x: audioTableCell.frame.origin.x, y: audioTableCell.frame.origin.y, width: audioTableCell.frame.width, height: CGFloat(height))
        
        tableView.reloadData()
    }
    
    func updateImageCollectionViewHeight() {
        let hCount = Int(imageCollectionView.frame.width) / 100
        var row = images.count / hCount
        row = images.count % hCount == 0 ? row : row + 1
        if imageCollectionViewHeightConstraint == nil {
            imageCollectionViewHeightConstraint = NSLayoutConstraint(item: imageCollectionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * 100))
            
            imageCollectionView.addConstraint(imageCollectionViewHeightConstraint!)
        } else {
            imageCollectionViewHeightConstraint?.constant = CGFloat(row * 100)
        }
        let height = 43.5 + Double(row * 100)
        
        imageTableCell.frame = CGRect(x: imageTableCell.frame.origin.x, y: imageTableCell.frame.origin.y, width: imageTableCell.frame.width, height: CGFloat(height))
        
        tableView.reloadData()
    }
    
    func selecteLocation(location: String) {
        btnLocation.setTitle(location, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectLocationViewController {
            controller.delegate = self
        }
    }
}
