//
//  Lunar.h
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lunar : NSObject
/**
 *是否闰月
 */
@property(assign) BOOL isleap;
/**
 *农历 日
 */
@property(assign) int lunarDay;
/**
 *农历 月
 */
@property(assign) int lunarMonth;
/**
 *农历 年
 */
@property(assign) int lunarYear;
//构造
- (instancetype)initWithYear:(int)year andMonth:(int)month andDay:(int)day;
//- (instancetype)init NS_UNAVAILABLE;
@end
