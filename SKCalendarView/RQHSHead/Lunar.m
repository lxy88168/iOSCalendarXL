//
//  Lunar.m
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "Lunar.h"

@implementation Lunar
//构造
- (instancetype)initWithYear:(int)year andMonth:(int)month andDay:(int)day{

    self = [super init];
    if (self) {
        
        self.lunarYear = year;
        self.lunarMonth = month;
        self.lunarDay = day;
    }
    return self;
}
@end
