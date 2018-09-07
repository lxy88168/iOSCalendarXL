//
//  RemindCell2TableViewCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/31.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class RemindCell2TableViewCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelRemindContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
