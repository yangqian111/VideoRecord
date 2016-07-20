//
//  EXCallbackHandle.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "EXCallbackHandle.h"

@implementation EXCallbackHandle

+ (void)notify:(NSString *)notification object:(id)object userInfo:(NSDictionary *)userInfo
{
    if ([NSThread isMainThread])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
        });
    }
}

+ (void)notify:(NSString *)notification userInfo:(NSDictionary *)userInfo
{
    [self notify:notification object:nil userInfo:userInfo];
}

+ (void)notify:(NSString *)notification
{
    [self notify:notification object:nil userInfo:nil];
}

+ (void)callBackSuccess:(void (^)(BOOL))block success:(BOOL)success
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(success);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success);
        });
    }
}

+ (void)callBackSuccessAndArray:(void (^)(BOOL,NSArray *))block success:(BOOL)success array:(NSArray *)array
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(success,array);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success,array);
        });
    }
}

+ (void)callBackObject:(void (^)(id))block object:(id)object
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(object);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object);
        });
    }
}

+ (void)callBackObjectEnum:(void (^)(id,NSUInteger))block object:(id)object enumValue:(NSUInteger)enumValue
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(object,enumValue);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object,enumValue);
        });
    }
}

+ (void)callBackEnum:(void (^)(NSUInteger))block enumValue:(NSUInteger)enumValue
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(enumValue);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(enumValue);
        });
    }
}

+ (void)callBackArray:(void (^)(NSArray *))block array:(NSArray *)array
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(array);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(array);
        });
    }
}

+ (void)callBackSuccessAndObject:(void (^)(BOOL,id))block success:(BOOL)success object:(id)object
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(success,object);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success,object);
        });
    }
}

+ (void)callBackSuccessAndCount:(void (^)(BOOL,NSUInteger))block success:(BOOL)success count:(NSUInteger)count
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(success,count);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success,count);
        });
    }
}

+ (void)callBackSuccessAndTwoCounts:(void (^)(BOOL,NSUInteger,NSUInteger))block success:(BOOL)success count1:(NSUInteger)count1 count2:(NSUInteger)count2
{
    if (!block)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        block(success,count1,count2);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success,count1,count2);
        });
    }
}


@end
