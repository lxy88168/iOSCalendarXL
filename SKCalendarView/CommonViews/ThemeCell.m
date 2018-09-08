//
//  ThemeCell.m
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/7.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.viewDot.layer.cornerRadius = 3;
    self.imageSelected.hidden = true;
}

- (void)setSelected:(BOOL)selected {
    self.imageSelected.hidden = !selected;
}

@end
