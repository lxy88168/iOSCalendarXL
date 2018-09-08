//
//  ThemeCell.h
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/7.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelThemeName;
@property (weak, nonatomic) IBOutlet UIView *viewDot;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;

@end
