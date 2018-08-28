//
//  Solar.m
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "Solar.h"

@implementation Solar
//构造
- (instancetype)initWithYear:(int)year andMonth:(int)month andDay:(int)day{

    self = [super init];
    if (self) {
        
        self.solarYear = year;
        self.solarMonth = month;
        self.solarDay = day;
    }
    return self;
}
@end
