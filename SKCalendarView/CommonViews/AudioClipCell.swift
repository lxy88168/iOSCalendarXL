//
//  AudioClipCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/23.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@IBDesignable
class AudioClipCell: MediaCollectionViewCell, AVAudioPlayerDelegate {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    var player: AVAudioPlayer?
    var playImage: UIImage?
    let stopImage = UIImage(named: "stop")
    var timeStr = "00:00"
    var timer: Timer?
    var totalTimeInSecond = 0
    var timeElapsedInSecond = 0
    
    var media: Media? {
        didSet {
            if media != nil && media!.type == .Audio {
                do {
                    let data =  try NSData(contentsOfFile: (media?.filePath)!, options: NSData.ReadingOptions.mappedIfSafe)
                    let player = try AVAudioPlayer(data: data as Data)
                    totalTimeInSecond = Int(player.duration)
                    let date = Date(timeIntervalSince1970: player.duration)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "mm:ss"
                    timeStr = dateFormatter.string(from: date)
                    labelTime.text = timeStr
                } catch let error as NSError {
                    print("error: \(error)")
                }
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        if player == nil {
            do {
                let data =  try NSData(contentsOfFile: (media?.filePath)!, options: NSData.ReadingOptions.mappedIfSafe)
                player = try AVAudioPlayer(data: data as Data)
                player?.delegate = self
                player?.prepareToPlay()
            } catch let error as NSError {
                print("error: \(error)")
            }
        }
        if player == nil {
            return
        }
        let tempPlayer = player!
        
        if tempPlayer.isPlaying {
            tempPlayer.stop()
            btnPlay.setImage(playImage, for: .normal)
            timeElapsedInSecond = 0
            labelTime.text = timeStr
            timer?.invalidate()
        } else {
            tempPlayer.play()
            btnPlay.setImage(stopImage, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimeLabel(_ timer: Timer) {
        timeElapsedInSecond += 1
        let remainnTime = totalTimeInSecond - timeElapsedInSecond
        let sec = remainnTime % 60
        let min = remainnTime / 60
        labelTime.text = NSString(format: "%02d:%02d", min, sec) as String
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnPlay.setImage(playImage, for: .normal)
        labelTime.text = timeStr
        timeElapsedInSecond = 0
        timer?.invalidate()
        timer = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        viewBg.layer.cornerRadius = 8
        viewBg.layer.borderWidth = 1
        viewBg.layer.borderColor = UIColor.gray.cgColor
        
        playImage = btnPlay.imageView?.image
    }
    
    @IBAction func onDelete(_ sender: Any) {
        delegate?.onDelete(sender: self)
    }
    
    override func setCanDelete(canDelete: Bool) {
        btnDelete.isHidden = !canDelete
    }
}
