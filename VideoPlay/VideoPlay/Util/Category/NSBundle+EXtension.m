//
//  NSBundle+EXtension.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "NSBundle+EXtension.h"

@implementation NSBundle (EXtension)

+ (NSString *)version
{
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)build
{
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)appName
{
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleIdentifier
{
    return [[self mainBundle] bundleIdentifier];
}

@end
