//
//  NSString+EXtension.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (EXtension)

- (NSString *)urlEncode;
- (NSString *)urlDecode;


+ (NSString *)stringWithMD5OfFile:(NSString *)path;
- (NSString *)MD5Hash;

- (id)jsonValue;

//利用系统方法计算的拼音，无法分割中文字后面的字符
- (NSString *)pinyin;

- (CGSize)ex_sizeWithFont:(UIFont *)font;
- (CGSize)ex_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color;
- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

- (NSString *)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

@end
