//
//  NSBundle+EXtension.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (EXtension)

+ (NSString *)version;
+ (NSString *)build;
+ (NSString *)appName;
+ (NSString *)bundleIdentifier;

@end
