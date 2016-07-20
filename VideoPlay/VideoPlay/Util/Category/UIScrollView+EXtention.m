//
//  UIScrollView+EXtention.m
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "UIScrollView+EXtention.h"

@implementation UIScrollView (EXtention)
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentInset.top) animated:animated];
}

- (void)scrollToEndAnimated:(BOOL)animated
{
    CGFloat contentHeight = self.contentSize.height;
    CGFloat tableHeight = self.bounds.size.height;
    UIEdgeInsets contentInsets = self.contentInset;
    
    CGFloat offsetToSet = contentHeight - tableHeight + contentInsets.bottom;
    if(offsetToSet > -[self contentInset].top)
    {
        CGPoint contentOffset = CGPointMake(0, offsetToSet);
        [self setContentOffset:contentOffset animated:animated];
    }
}

- (void)stopScrolling
{
    BOOL scrollEnabledBefore = self.scrollEnabled;
    self.scrollEnabled = NO;
    self.scrollEnabled = scrollEnabledBefore;
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x += 1;
    contentOffset.y += 1;
    [self setContentOffset:contentOffset animated:NO];
    contentOffset.x -= 1;
    contentOffset.y -= 1;
    [self setContentOffset:contentOffset animated:NO];
    
    [self.layer removeAllAnimations];
}

@end
