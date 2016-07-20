//
//  UIDevice+EXtension.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (EXtension)

+ (BOOL)systemVersionIsEqualTo:(NSString *)versionNo;
+ (BOOL)systemVersionIsGreaterThan:(NSString *)versionNo;
+ (BOOL)systemVersionIsGreaterThanOrEqualTo:(NSString *)versionNo;
+ (BOOL)systemVersionIsLessThan:(NSString *)versionNo;
+ (BOOL)systemVersionIsLessThanOrEqualTo:(NSString *)versionNo;

@end
