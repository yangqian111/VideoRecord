//
//  VDMKVideoViewController.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/19.
//  Copyright © 2016年 video. All rights reserved.
//

#import "VDMKVideoViewController.h"
#import "VDPostViewController.h"
#import <AVFoundation/AVFoundation.h>


#define kDuration 6.0
#define kTrans SCREEN_WIDTH/kDuration/60.0

typedef NS_ENUM (NSInteger,VideoStatus){
    VideoStatusEnded = 0,
    VideoStatusStarted
};

@interface VDMKVideoViewController ()

@end

@implementation VDMKVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
