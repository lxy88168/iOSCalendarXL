//
//  LocationNameCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/1.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class LocationNameCell: UITableViewCell {

    @IBOutlet weak var imageViewState: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            imageViewState.image = UIImage(named: "radio_checked")
        } else {
            imageViewState.image = UIImage(named: "radio_unchecked")
        }
    }
    
}
