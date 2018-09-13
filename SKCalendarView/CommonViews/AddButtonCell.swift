//
//  AddButtonCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/12.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class AddButtonCell: MediaCollectionViewCell {
    @IBOutlet weak var btnAdd: UIButton!
    var mediaType: Media.MediaType = .Audio
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAdd.layer.cornerRadius = 5
        btnAdd.layer.borderColor = UIColor.gray.cgColor
        btnAdd.layer.borderWidth = 1
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.onAdd(sender: self)
    }
}
