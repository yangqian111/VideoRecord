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

@interface VDMKVideoViewController ()<AVCaptureFileOutputRecordingDelegate>{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDevice *_audioDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureMovieFileOutput *_movieOutput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}



@end

@implementation VDMKVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
