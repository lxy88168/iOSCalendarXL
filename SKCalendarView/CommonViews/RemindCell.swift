//
//  RemindCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit
import AssetsLibrary

class RemindCell: UITableViewCell, UICollectionViewDataSource {
    
    var medias: [Media] = []{
        didSet {
            updateCollectionViewHeight()
            collectionViewMedia.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let media = medias[indexPath.row]
        let cell: MediaCollectionViewCell?
        
        if media.type == Media.MediaType.Audio {
            let audioCell = collectionViewMedia.dequeueReusableCell(withReuseIdentifier: "audioClipCell", for: indexPath) as! AudioClipCell
            audioCell.media = media
            cell = audioCell
        } else {
            let imageCell = collectionViewMedia.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            imageCell.setCanDelete(canDelete: false)
            let url = NSURL(string: media.filePath)!
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.asset(for: url as URL!, resultBlock: { (asset:ALAsset?) -> Void in
                if let imageRef = asset?.defaultRepresentation().fullScreenImage() {
                    imageCell.image.image = UIImage(cgImage: imageRef.takeUnretainedValue())
                }
            }, failureBlock: {(error) in
                print("get file path error: \(error)")
            })
            
            cell = imageCell
        }
        cell!.setCanDelete(canDelete: false)
        return cell!
    }
    
    var heightConstraint: NSLayoutConstraint?
    
    func updateCollectionViewHeight() {
        let hCount = Int(collectionViewMedia.frame.width) / 100
        var row = medias.count / hCount
        row = medias.count % hCount == 0 ? row : row + 1
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: collectionViewMedia, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * 100))
            
            collectionViewMedia.addConstraint(heightConstraint!)
        } else {
            heightConstraint?.constant = CGFloat(row * 100)
        }
    }
    
    @IBOutlet weak var labelRemindContent: UILabel!
    @IBOutlet weak var labelFriendlyTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collectionViewMedia: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackground.layer.cornerRadius = 8
        var cellNib = UINib(nibName: "AudioClipCell", bundle: nil)
        collectionViewMedia.register(cellNib, forCellWithReuseIdentifier: "audioClipCell")
        cellNib = UINib(nibName: "ImageCell", bundle: nil)
        collectionViewMedia.register(cellNib, forCellWithReuseIdentifier: "imageCell")
        
        let layout =  collectionViewMedia.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        updateCollectionViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
