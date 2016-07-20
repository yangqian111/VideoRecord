//
//  UIColor+EXtension.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "UIColor+EXtension.h"

@interface NSString (EXtension)
- (NSUInteger)integerValueFromHex;
@end

@implementation NSString (EXtension)
- (NSUInteger)integerValueFromHex
{
    NSUInteger result = 0;
    sscanf([self UTF8String], "%tx", &result);
    return result;
}
@end

@implementation UIColor (EXtension)

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    if ([hex length] != 6 && [hex length] != 3)
    {
        return nil;
    }
    
    NSUInteger digits = [hex length] / 3;
    CGFloat maxValue = (digits==1) ? 15.0 : 255.0;
    
    CGFloat red = [[hex substringWithRange:NSMakeRange(0, digits)] integerValueFromHex] / maxValue;
    CGFloat green = [[hex substringWithRange:NSMakeRange(digits, digits)] integerValueFromHex] / maxValue;
    CGFloat blue = [[hex substringWithRange:NSMakeRange(2 * digits, digits)] integerValueFromHex] / maxValue;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha
{
    if ([hex length] != 6 && [hex length] != 3)
    {
        return nil;
    }
    
    NSUInteger digits = [hex length] / 3;
    CGFloat maxValue = (digits==1) ? 15.0 : 255.0;
    
    CGFloat red = [[hex substringWithRange:NSMakeRange(0, digits)] integerValueFromHex] / maxValue;
    CGFloat green = [[hex substringWithRange:NSMakeRange(digits, digits)] integerValueFromHex] / maxValue;
    CGFloat blue = [[hex substringWithRange:NSMakeRange(2 * digits, digits)] integerValueFromHex] / maxValue;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)hexStringIgnoreAlpha
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    if (!success)
    {
        return @"000000";
    }
    int redInt = (int)(red * 255.f);
    int greenInt = (int)(green * 255.f);
    int blueInt = (int)(blue * 255.f);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x", redInt, greenInt, blueInt];
    return result;
}

@end
