//
//  ThemeCollectionViewCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/11.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelThemeName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewDot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5;
        self.viewDot.layer.cornerRadius = 5;
        self.imageView.isHidden = true;
    }

    override var isSelected: Bool {
        didSet {
            self.imageView.isHidden = !isSelected
        }
    }
}
