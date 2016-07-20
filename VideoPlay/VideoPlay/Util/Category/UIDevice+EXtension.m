//
//  UIDevice+EXtension.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "UIDevice+EXtension.h"

@implementation UIDevice (EXtension)


+ (BOOL)systemVersionIsEqualTo:(NSString *)versionNo
{
    return ([[[self currentDevice] systemVersion] compare:versionNo options:NSNumericSearch] == NSOrderedSame);
}

+ (BOOL)systemVersionIsGreaterThan:(NSString *)versionNo
{
    return ([[[self currentDevice] systemVersion] compare:versionNo options:NSNumericSearch] == NSOrderedDescending);
}

+ (BOOL)systemVersionIsGreaterThanOrEqualTo:(NSString *)versionNo
{
    return ([[[self currentDevice] systemVersion] compare:versionNo options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)systemVersionIsLessThan:(NSString *)versionNo
{
    return ([[[self currentDevice] systemVersion] compare:versionNo options:NSNumericSearch] == NSOrderedAscending);
}

+ (BOOL) systemVersionIsLessThanOrEqualTo:(NSString *)versionNo
{
    return ([[[self currentDevice] systemVersion] compare:versionNo options:NSNumericSearch] != NSOrderedDescending);
}

@end
