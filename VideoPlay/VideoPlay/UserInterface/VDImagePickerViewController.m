//
//  ViewController.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/18.
//  Copyright © 2016年 video. All rights reserved.
//

#import "VDImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VDImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak) UISlider *slider; //压缩尺度 默认50%
@property (nonatomic,weak) UILabel *sliderLabel; //压缩尺度显示
@property (nonatomic,weak) UIButton *recordVideo;//录制视频
@property (nonatomic,weak) UIButton *chooseVideo;//从本地选择视频
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器


@end

@implementation VDImagePickerViewController
{
@private
    NSURL *_videoURL;
    NSString *_fileName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadVideo)];
    self.navigationItem.title = @"视频录制";
}

- (void)initUI {
    UISlider *slider = [UISlider new];
    [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    slider.value = 0.5;
    [self.view addSubview:slider];
    self.slider = slider;
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    UILabel *sliderLabel = [UILabel new];
    sliderLabel.text = @"压缩比例：50%";
    [self.view addSubview:sliderLabel];
    self.sliderLabel = sliderLabel;
    [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.slider.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.slider);
    }];
    
    UIButton *recordVideo = [UIButton new];
    [recordVideo addTarget:self action:@selector(recordVideoWithCamera) forControlEvents:UIControlEventTouchUpInside];
    recordVideo.backgroundColor = [UIColor lightGrayColor];
    recordVideo.layer.masksToBounds = YES;
    recordVideo.layer.cornerRadius = 5;
    [recordVideo setTitle: @"录制视频" forState: UIControlStateNormal];
    [self.view addSubview: recordVideo];
    self.recordVideo = recordVideo;
    [self.recordVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderLabel);
        make.top.mas_equalTo(self.sliderLabel.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *chooseVideo = [UIButton new];
    [chooseVideo addTarget:self action:@selector(chooseVideoFromLibrary) forControlEvents:UIControlEventTouchUpInside];
    chooseVideo.backgroundColor = [UIColor lightGrayColor];
    chooseVideo.layer.masksToBounds = YES;
    chooseVideo.layer.cornerRadius = 5;
    [chooseVideo setTitle: @"选择视频" forState: UIControlStateNormal];
    [self.view addSubview: chooseVideo];
    self.chooseVideo = chooseVideo;
    [self.chooseVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderLabel);
        make.top.mas_equalTo(self.recordVideo.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
}

//创建视屏播放器
- (void)initMoviePlayer {
    NSURL *url = _videoURL;
    _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    _moviePlayer.shouldAutoplay = NO;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    _moviePlayer.view.frame = CGRectMake(10, 400, width-20, 200);
    [self.view addSubview:_moviePlayer.view];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification {
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//压缩比例改变
- (void)sliderValueChanged {
    self.sliderLabel.text = [NSString stringWithFormat:@"压缩比例：%.0f%@",self.slider.value*100,@"%"];
}

//从相册选择视频
- (void)chooseVideoFromLibrary {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.delegate = self;//设置委托
}

//用相机拍摄视频
- (void)recordVideoWithCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.videoMaximumDuration = 30.0f;//30秒
    imagePicker.delegate = self;//设置委托
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    //    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    //    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    NSURL *newVideoUrl; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    _fileName = [formater stringFromDate:[NSDate date]];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp4", _fileName]];//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 //                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 //                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 //                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 [self alertUploadVideo:outputURL];
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}

-(void)alertUploadVideo:(NSURL*)URL {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _videoURL = [URL copy];
            [self initMoviePlayer];
            [self addNotification];
            [self thumbnailImageRequest];
        });
    }
    
    //        CGFloat size = [self getFileSize:[URL path]];
    //        NSString *message;
    //        NSString *sizeString;
    //        CGFloat sizemb= size/1024;
    //        if(size<=1024) {
    //            sizeString = [NSString stringWithFormat:@"%.2fKB",size];
    //        }else{
    //            sizeString = [NSString stringWithFormat:@"%.2fMB",sizemb];
    //        }
    //
    //        if(sizemb<2) {
    //            [self uploadVideo:URL];
    //        }
    //
    //        else if(sizemb<=5) {
    //            message = [NSString stringWithFormat:@"视频%@，大于2MB会有点慢，确定上传吗？", sizeString];
    //            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
    //                                                                                      message: message
    //                                                                               preferredStyle:UIAlertControllerStyleAlert];
    //
    //            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
    //                [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
    //
    //            }]];
    //            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //
    //
    //                [self uploadVideo:URL];
    //
    //            }]];
    //            [self presentViewController:alertController animated:YES completion:nil];
    //
    //        }else if(sizemb>5) {
    //            message = [NSString stringWithFormat:@"视频%@，超过5MB，不能上传，抱歉。", sizeString];
    //            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
    //                                                                                      message: message
    //                                                                               preferredStyle:UIAlertControllerStyleAlert];
    //
    //            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
    //                [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间
    //
    //            }]];
    //            [self presentViewController:alertController animated:YES completion:nil];
    //        }
    
}

-(void)uploadVideo:(NSURL*)URL {
    
    
    //[MyTools showTipsWithNoDisappear:nil message:@"正在上传..."];
    //    NSData *data = [NSData dataWithContentsOfURL:URL];
    //    //    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.ylhuakai.com" customHeaderFields:nil];
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //    NSString *updateURL;
    //    updateURL = @"/alflower/Data/sendupdate";
    //
    //
    //    //    [dic setValue:[NSString stringWithFormat:@"%@",User_id] forKey:@"openid"];
    //    //    [dic setValue:[NSString stringWithFormat:@"%@",[self.web objectForKey:@"web_id"]] forKey:@"web_id"];
    //    //    [dic setValue:[NSString stringWithFormat:@"%i",insertnumber] forKey:@"number"];
    //    //    [dic setValue:[NSString stringWithFormat:@"%i",insertType] forKey:@"type"];
    //
    //    //    MKNetworkOperation *op = [engine operationWithPath:updateURL params:dic httpMethod:@"POST"];
    //    [op addData:data forKey:@"video" mimeType:@"video/mpeg" fileName:@"aa.mp4"];
    //    [op addCompletionHandler:^(MKNetworkOperation *operation) {
    //        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
    //        NSData *data = [operation responseData];
    //        NSDictionary *resweiboDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //        NSString *status = [[resweiboDict objectForKey:@"status"]stringValue];
    //        NSLog(@"addfriendlist status is %@", status);
    //        NSString *info = [resweiboDict objectForKey:@"info"];
    //        NSLog(@"addfriendlist info is %@", info);
    //        // [MyTools showTipsWithView:nil message:info];
    //        // [SVProgressHUD showErrorWithStatus:info];
    //        if ([status isEqualToString:@"1"])
    //        {
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
    //            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//上传之后就删除，以免占用手机硬盘空间;
    //
    //        }else
    //        {
    //            //[SVProgressHUD showErrorWithStatus:dic[@"info"]];
    //        }
    //        // [[NSNotificationCenter defaultCenter] postNotificationName:@"StoryData" object:nil userInfo:nil];
    //
    //
    //    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    //        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    //    }];
    //    [engine enqueueOperation:op];
}


//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

//此方法可以获取视频文件的时长。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}


/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification {
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}

/**
 *  获取视频缩略图
 */
-(void)thumbnailImageRequest {
    //获取视频开始的缩略图
    [self.moviePlayer requestThumbnailImagesAtTimes:@[@0.0,@0.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
}


/**
 *  缩略图请求完成,此方法每次截图成功都会调用一次
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification {
    NSLog(@"视频截图完成.");
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];
    //保存图片到相册(首次调用会请求用户获得访问相册权限)
    UIImageView *videoImage = [[UIImageView alloc] initWithFrame:self.moviePlayer.view.frame];
    videoImage.image = image;
    [self.moviePlayer.view addSubview:videoImage];
}

- (void)uploadVideo {
    //    NSString *path = _videoURL.absoluteString;
    NSData *data = [NSData dataWithContentsOfURL:_videoURL];
    BmobFile *file = [[BmobFile alloc] initWithFileName:_fileName withFileData:data];
    
    //    BmobFile *file = [[BmobFile alloc] initWithFilePath:path];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"上传成功");
        }
    } withProgressBlock:^(CGFloat progress) {
        NSString *progressStr = [NSString stringWithFormat:@"%.2f",progress];
        
    }];
}

@end
