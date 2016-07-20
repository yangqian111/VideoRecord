//
//  NSString+EXtension.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "NSString+EXtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EXtension)

- (NSString *)urlEncode
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)urlDecode
{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (__bridge CFStringRef)self,
                                                                                                  (CFStringRef)@"",
                                                                                                  kCFStringEncodingUTF8);
}

+ (NSString *) stringWithMD5OfFile: (NSString *) path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
    if (handle == nil)
    {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    
    BOOL done = NO;
    
    while (!done)
    {
        @autoreleasepool
        {
            NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
            CC_MD5_Update (&md5, [fileData bytes], (CC_LONG) [fileData length]);
            if ([fileData length] == 0)
            {
                done = YES;
            }
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

- (NSString *) MD5Hash
{
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

- (id)jsonValue
{
    NSError *error;
    id ret;
    @try
    {
        ret = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exception)
    {
        ret = nil;
        return ret;
    }
    
    if (error)
    {
        ret = nil;
    }
    return ret;
}

- (NSString *)pinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return pinyinString;
}

- (NSString *)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font
{
    if ([self ex_sizeWithFont:font].width <= width)
    {
        return [NSString stringWithString:self];
    }
    
    
    width -= [@"..." ex_sizeWithFont:font].width;
    if (width <= 0)
    {
        return @"...";
    }
    
    NSMutableString *retString = [NSMutableString string];
    for (NSInteger i = 0; i < self.length && [retString ex_sizeWithFont:font].width <= width; i++)
    {
        [retString appendString:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    
    if ([self isEqualToString:retString])
    {
        return retString;
    }
    
    if (retString.length >= 1)
    {
        [retString deleteCharactersInRange:NSMakeRange([retString length] - 1, 1)];
    }
    [retString appendString:@"..."];
    
    return retString;
}

#pragma mark - size
- (UILabel *)labelForCalculateSize
{
    static dispatch_once_t pred;
    static UILabel *__labelForCalculateSize = nil;
    dispatch_once(&pred, ^{
        __labelForCalculateSize = [[UILabel alloc] init];
        __labelForCalculateSize.numberOfLines = 0;
    });
    return __labelForCalculateSize;
}

- (CGSize)ex_sizeWithFont:(UIFont *)font
{
    return [self ex_sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self ex_sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self ex_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self ex_sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    [self labelForCalculateSize].text = self;
    [self labelForCalculateSize].font = font;
    [self labelForCalculateSize].lineBreakMode = lineBreakMode;
    [self labelForCalculateSize].textAlignment = alignment;
    CGSize returnSize = [[self labelForCalculateSize] sizeThatFits:size];
    returnSize.height = MIN(size.height, returnSize.height);
    return CGSizeMake(ceilf(returnSize.width), ceilf(returnSize.height));
}

#pragma mark - draw
- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color
{
    return [self ex_drawInRect:rect withFont:font color:color lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self ex_drawInRect:rect withFont:font color:color lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (CGSize)ex_drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    if (font)
    {
        attrs[NSFontAttributeName] = font;
    }
    if (color)
    {
        attrs[NSForegroundColorAttributeName] = color;
    }
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
    [self drawInRect:rect withAttributes:attrs];
    return [self ex_sizeWithFont:font constrainedToSize:rect.size lineBreakMode:lineBreakMode alignment:alignment];
}


@end
