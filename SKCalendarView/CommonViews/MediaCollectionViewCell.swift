//
//  MediaCellCollectionViewCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/25.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    var delegate: MediaCellDelegate?
    var row: Int = -1
    var owner: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCanDelete(canDelete: Bool) {
        
    }
}
