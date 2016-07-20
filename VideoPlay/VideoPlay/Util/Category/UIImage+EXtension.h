//
//  UIImage+EXtension.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EXtension)


- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByCornerRadius:(CGFloat)radius;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (UIImage *)redrawImageInContext:(UIImage *)sourceImage inRect:(CGRect)rect;
+ (UIImage *)imageFromView:(UIView *)aView;
+ (UIImage *)imageWithColor:(UIColor *)color;

//根据文字生成文字图片
+ (UIImage *)avatarImageWithText:(NSString *)text backgroundColor:(UIColor *)color size:(CGSize)size;
//可算文字大小
+ (UIImage *)avatarImageWithText:(NSString *)text fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)color size:(CGSize)size;


@end
