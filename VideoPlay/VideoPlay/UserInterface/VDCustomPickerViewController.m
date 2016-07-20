//
//  VDCustomPickerViewController.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/19.
//  Copyright © 2016年 video. All rights reserved.
//

#import "VDCustomPickerViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kDuration 30.0 //最长录制视频时间 秒
//#define kTrans kApplicationWidth/kDuration/60.0

@interface VDCustomPickerViewController ()<AVCaptureFileOutputRecordingDelegate>{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDevice *_audioDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureMovieFileOutput *_movieOutput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}

@property (nonatomic,weak) UIView *videoView;//视频显示层
@property (nonatomic,weak) UIView *progressView;//录制时间
@property (nonatomic,weak) UIButton *flashModelBtn;//闪光灯开关
@property (nonatomic,weak) UIButton *changeBtn;//转换摄像头
@property (nonatomic,weak) UIButton *videoRecordBtn;//开始停止录影
@property (nonatomic,weak) UIButton *reRecordBtn;//重新录制
@property (nonatomic,weak) UIView *focusCircle;//点击聚焦时的光圈动画
@property (nonatomic,strong) CADisplayLink *link;

@end

@implementation VDCustomPickerViewController
{
@private
    NSURL *_videoURL;//视频地址
    BOOL _isRecording;//是否正在录制
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getAuthorization];
    [self addGenstureRecognizer];//添加聚焦手势
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    UIView *videoView = [UIView new];
    videoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:videoView];
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(300);
    }];
    self.videoView = videoView;
    
    UIView *progressView = [UIView new];
    progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(videoView);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(0);
    }];
    self.progressView = progressView;
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tipLabel.text = @"单击视频以对焦\n双击以切换焦距";
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(videoView.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
    }];
    
    UIButton *flashModelBtn = [UIButton new];
    [flashModelBtn addTarget:self action:@selector(switchFashModel) forControlEvents:UIControlEventTouchUpInside];
    flashModelBtn.layer.cornerRadius = 8;
    flashModelBtn.layer.masksToBounds = YES;
    flashModelBtn.backgroundColor = [UIColor lightGrayColor];
    [flashModelBtn setTitle: @"闪光灯切换：Off" forState: UIControlStateNormal];
    [self.view addSubview: flashModelBtn];
    [flashModelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    self.flashModelBtn = flashModelBtn;
    
    UIButton *changeBtn = [UIButton new];
    [changeBtn addTarget:self action:@selector(changeShot) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.layer.cornerRadius = 8;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.backgroundColor = [UIColor lightGrayColor];
    [changeBtn setTitle: @"切换镜头" forState: UIControlStateNormal];
    [self.view addSubview: changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    self.changeBtn = changeBtn;
    
    UIButton *videoRecordBtn = [UIButton new];
    [videoRecordBtn addTarget:self action:@selector(startOrStopRecord) forControlEvents:UIControlEventTouchUpInside];
    videoRecordBtn.layer.cornerRadius = 50;
    videoRecordBtn.layer.masksToBounds = YES;
    videoRecordBtn.backgroundColor = [UIColor lightGrayColor];
    [videoRecordBtn setTitle: @"开始" forState: UIControlStateNormal];
    [self.view addSubview: videoRecordBtn];
    [videoRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(changeBtn.mas_bottom).mas_offset(50);
        make.width.height.mas_equalTo(100);
    }];
    self.videoRecordBtn = videoRecordBtn;
}

//获取授权
- (void)getAuthorization
{
    /*
     AVAuthorizationStatusNotDetermined = 0,// 未进行授权选择
     
     AVAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
     
     AVAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
     
     AVAuthorizationStatusAuthorized,　　　　// 已授权，可使用
     */
    //此处获取摄像头授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            NSLog(@"授权摄像头使用成功");
            [self setupAVCaptureInfo];
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted) { //用户授权成功
                    [self setupAVCaptureInfo];
                    return;
                } else { //用户拒绝授权
                    [self pop];
                    [self showMsgWithTitle:@"出错了" andContent:@"用户拒绝授权摄像头的使用权,返回上一页.请打开\n设置-->隐私/通用等权限设置"];
                    return;
                }
            }];
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            [self pop];
            [self showMsgWithTitle:@"出错了" andContent:@"拒绝授权,返回上一页.请检查下\n设置-->隐私/通用等权限设置"];
            break;
        }
    }
}

- (void)setupAVCaptureInfo
{
    [self addSession];
    
    [_captureSession beginConfiguration];
    
    [self addVideo];
    [self addAudio];
    [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    
    //开启会话-->注意,不等于开始录制
    [_captureSession startRunning];
}

- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    //设置视频分辨率
    /*  通常支持如下格式
     (
     AVAssetExportPresetLowQuality,
     AVAssetExportPreset960x540,
     AVAssetExportPreset640x480,
     AVAssetExportPresetMediumQuality,
     AVAssetExportPreset1920x1080,
     AVAssetExportPreset1280x720,
     AVAssetExportPresetHighestQuality,
     AVAssetExportPresetAppleM4A
     )
     */
    //注意,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小,
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

- (void)addVideo
{
    // 获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    /* MediaType
     AVF_EXPORT NSString *const AVMediaTypeVideo                 NS_AVAILABLE(10_7, 4_0);       //视频
     AVF_EXPORT NSString *const AVMediaTypeAudio                 NS_AVAILABLE(10_7, 4_0);       //音频
     AVF_EXPORT NSString *const AVMediaTypeText                  NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeClosedCaption         NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeSubtitle              NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeTimecode              NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeMetadata              NS_AVAILABLE(10_8, 6_0);
     AVF_EXPORT NSString *const AVMediaTypeMuxed                 NS_AVAILABLE(10_7, 4_0);
     */
    
    /* AVCaptureDevicePosition
     typedef NS_ENUM(NSInteger, AVCaptureDevicePosition) {
     AVCaptureDevicePositionUnspecified         = 0,
     AVCaptureDevicePositionBack                = 1,            //后置摄像头
     AVCaptureDevicePositionFront               = 2             //前置摄像头
     } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addMovieOutput];
}

- (void)addVideoInput
{
    NSError *videoError;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&videoError];
    if (videoError) {
        NSLog(@"---- 取得摄像头设备时出错 ------ %@",videoError);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    
}

- (void)addMovieOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        //设置视频旋转方向
        /*
         typedef NS_ENUM(NSInteger, AVCaptureVideoOrientation) {
         AVCaptureVideoOrientationPortrait           = 1,
         AVCaptureVideoOrientationPortraitUpsideDown = 2,
         AVCaptureVideoOrientationLandscapeRight     = 3,
         AVCaptureVideoOrientationLandscapeLeft      = 4,
         } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
         */
        //        if ([captureConnection isVideoOrientationSupported]) {
        //            [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        //        }
        
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
    
}

- (void)addAudio
{
    NSError *audioError;
    // 添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //  音频输入对象
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_audioDevice error:&audioError];
    if (audioError) {
        NSLog(@"取得录音设备时出错 ------ %@",audioError);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioInput]) {
        [_captureSession addInput:_audioInput];
    }
}

- (void)addPreviewLayer
{
    
    [self.view layoutIfNeeded];
    
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = self.view.layer.bounds;
    /* 填充模式
     Options are AVLayerVideoGravityResize, AVLayerVideoGravityResizeAspect and AVLayerVideoGravityResizeAspectFill. AVLayerVideoGravityResizeAspect is default.
     */
    //有时候需要拍摄完整屏幕大小的时候可以修改这个
    //    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 如果预览图层和视频方向不一致,可以修改这个
    _captureVideoPreviewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    _captureVideoPreviewLayer.position = CGPointMake(self.view.width*0.5,self.videoView.height*0.5);
    
    // 显示在视图表面的图层
    CALayer *layer = self.videoView.layer;
    layer.masksToBounds = true;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
}

-(void)pop
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content
{
    [[[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


#pragma mark 录制相关

- (NSURL *)outPutFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
}

- (void)startRecord
{
    
    //    [self stopLink];
    //    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.videoRecordBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [_movieOutput startRecordingToOutputFileURL:[self outPutFileURL] recordingDelegate:self];
    _isRecording = YES;
}

- (void)updateProgress {
    
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    }
    return _link;
}

- (void)stopLink
{
    _link.paused = YES;
    [_link invalidate];
    _link = nil;
}

- (void)stopRecord
{
    // 取消视频拍摄
    //    [self stopLink];
    [self.videoRecordBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_movieOutput stopRecording];
    _isRecording = NO;
}

//这个在完全退出小视频时调用
- (void)quit
{
    [_captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 ---%@-%@ ",outputFileURL,captureOutput.outputFileURL);
    
    if (outputFileURL.absoluteString.length == 0 && captureOutput.outputFileURL.absoluteString.length == 0 ) {
        [self showMsgWithTitle:@"出错了" andContent:@"录制视频保存地址出错"];
        return;
    }
    if (!_isRecording) {
        _videoURL = [outputFileURL copy];
    }
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer {
    
    UITapGestureRecognizer *singleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.delaysTouchesBegan = YES;
    
    UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.delaysTouchesBegan = YES;
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.videoView addGestureRecognizer:singleTapGesture];
    [self.videoView addGestureRecognizer:doubleTapGesture];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGesture {
    
    NSLog(@"单击");
    
    CGPoint point= [tapGesture locationInView:self.videoView];
    //将UI坐标转化为摄像头坐标,摄像头聚焦点范围0~1
    CGPoint cameraPoint= [_captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorAnimationWithPoint:point];//点击时加上光圈动画
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦模式修改为%zd",AVCaptureFocusModeContinuousAutoFocus);
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        
        //曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }else{
            NSLog(@"曝光模式修改失败");
        }
        
        //曝光点的位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:cameraPoint];
        }
    }];
}


//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange {
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_captureSession beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
    }
}


//设置焦距
-(void)doubleTap:(UITapGestureRecognizer *)tapGesture {
    
    NSLog(@"双击");
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        if (captureDevice.videoZoomFactor == 1.0) {
            CGFloat current = 1.5;
            if (current < captureDevice.activeFormat.videoMaxZoomFactor) {
                [captureDevice rampToVideoZoomFactor:current withRate:10];
            }
        }else{
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }
    }];
}

//光圈动画
-(void)setFocusCursorAnimationWithPoint:(CGPoint)point {
    self.focusCircle.center = point;
    self.focusCircle.transform = CGAffineTransformIdentity;
    self.focusCircle.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCircle.transform=CGAffineTransformMakeScale(0.5, 0.5);
        self.focusCircle.alpha = 0.0;
    }];
}

//光圈
- (UIView *)focusCircle {
    if (!_focusCircle) {
        UIView *focusCircle = [[UIView alloc] init];
        focusCircle.frame = CGRectMake(0, 0, 100, 100);
        focusCircle.layer.borderColor = [UIColor orangeColor].CGColor;
        focusCircle.layer.borderWidth = 2;
        focusCircle.layer.cornerRadius = 50;
        focusCircle.layer.masksToBounds =YES;
        _focusCircle = focusCircle;
        [self.videoView addSubview:focusCircle];
    }
    return _focusCircle;
}

#pragma mark - 切换闪光灯
- (void)switchFashModel {
    BOOL con1 = [_videoDevice hasTorch]; //支持手电筒模式
    BOOL con2 = [_videoDevice hasFlash]; //支持闪光模式
    
    if (con1 && con2)
    {
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            if (_videoDevice.flashMode == AVCaptureFlashModeOn) //闪光灯开
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOff];
                [_videoDevice setTorchMode:AVCaptureTorchModeOff];
            }else if (_videoDevice.flashMode == AVCaptureFlashModeOff) //闪光灯关
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOn];
                [_videoDevice setTorchMode:AVCaptureTorchModeOn];
            }
            NSLog(@"现在的闪光模式是AVCaptureFlashModeOn么?是你就扣1, %zd",_videoDevice.flashMode == AVCaptureFlashModeOn);
        }];
    }else{
        NSLog(@"不能切换闪光模式");
    }
    
}

#pragma mark - 切换前后摄像头
- (void)changeShot {
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
            break;
        default:
            return;
            break;
    }
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
        
        if (newVideoInput != nil) {
            //必选先 remove 才能询问 canAdd
            [_captureSession removeInput:_videoInput];
            if ([_captureSession canAddInput:newVideoInput]) {
                [_captureSession addInput:newVideoInput];
                _videoInput = newVideoInput;
            }else{
                [_captureSession addInput:_videoInput];
            }
            
        } else if (error) {
            NSLog(@"切换前/后摄像头失败, error = %@", error);
        }
    }];
}

#pragma mark - 开始拍摄 停止拍摄
- (void)startOrStopRecord {
    if (_isRecording) {
        [self stopRecord];
    }else{
        [self startRecord];
    }
}

#pragma mark 获取摄像头-->前/后
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

@end
