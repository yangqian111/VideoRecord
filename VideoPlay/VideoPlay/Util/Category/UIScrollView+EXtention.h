//
//  UIScrollView+EXtention.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (EXtention)

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToEndAnimated:(BOOL)animated;
- (void)stopScrolling;

@end
