//
//  CalendarDisplyManager.h
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Solar;
@class Lunar;
@interface CalendarDisplyManager : NSObject
//公历转农历
+ (Lunar *)obtainLunarFromSolar:(Solar *)solar;
//农历转公历
+ (Solar *)obtainSolarFromLunar:(Lunar *)solar;
//转换为农历显示形式
+ (void)resultWithLunar:(Lunar *)lunar resultFormat:(void(^)(NSString *year,NSString *month,NSString *day))lunarFormatBlock;
//星座
+ (NSString *)obtainConstellationFromSolar:(Solar *)solar;
@end
