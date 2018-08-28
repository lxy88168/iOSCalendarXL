//
//  LunarSolarConverter.h
//  阳历转阴历
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lunar.h"
#import "Solar.h"
@interface LunarSolarTransform : NSObject
/**
 *农历转公历
 */
+ (Solar *)lunarToSolar:(Lunar *)lunar;

/**
 *公历转农历
 */
+ (Lunar *)solarToLunar:(Solar *)solar;
//对应的星座计算
+ (NSString *)constellationFromSolar:(Solar *)solar;

//转换为农历显示形式
+ (NSString *)formatWithLunar:(Lunar *)lunar;
@end
