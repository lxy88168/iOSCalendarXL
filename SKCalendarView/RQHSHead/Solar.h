//
//  Solar.h
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Solar : NSObject
/**
 *公历 日
 */
@property(assign) int solarDay;
/**
 *公历 月
 */
@property(assign) int solarMonth;
/**
 *公历 年
 */
@property(assign) int solarYear;
//构造
- (instancetype)initWithYear:(int)year andMonth:(int)month andDay:(int)day ;
//- (instancetype)init NS_UNAVAILABLE;
@end
