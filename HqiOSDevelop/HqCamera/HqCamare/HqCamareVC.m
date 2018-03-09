//
//  HqCamareVC.m
//  IRaidCreditIos
//
//  Created by macpro on 2018/1/4.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqCamareVC.h"
#import "HqCamarePreView.h"
#import "UIImage+HqInfo.h"
#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
@interface HqCamareVC ()<HqCamarePreViewDelegate>

@property (nonatomic,strong)  UIView *overView;
@property (nonatomic,strong) HqCamarePreView *preView;
@property (nonatomic,strong) CALayer *borderLayer;

@end

@implementation HqCamareVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (![HqCamareVC requestDeviceAuthorization]){
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.session) {
        
        [self.session startRunning];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}
- (HqCamarePreView *)preView{
    if (!_preView) {
        _preView = [[HqCamarePreView alloc] initWithFrame:self.view.frame];
        _preView.delegate = self;
    }
    return _preView;
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SelfWidth, SelfHeight - 120)];
    [self.view addSubview:self.backView];
    
    //自己定义一个和原生的相机一样的按钮
    [self.view addSubview:[self photoBtn]];
   
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(20, SelfHeight - 80 , 40, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont  systemFontOfSize:15];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    [self initAVCaptureSession]; //设置相机属性
    self.effectiveScale = 1.0f;

    [self addMaskOver];
}
- (UIView *)photoBtn{
    CGFloat photoWidth = 60;
    UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(SelfWidth/2 - 30, SelfHeight - 120 + 30, photoWidth, photoWidth)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.layer.cornerRadius = 30;
    [photoView.layer masksToBounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat btnX = (photoWidth -50)/2.0;
    button.frame = CGRectMake(btnX, btnX, 50, 50);
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 25;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button.layer masksToBounds];
    [button addTarget:self action:@selector(buttondown) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:button];
    
    return photoView;
}
#pragma mark - 添加层罩
- (void)addMaskOver{
    CGFloat width = SelfWidth - 20;
    CGFloat height = width/1.6;
    CGFloat centerY = ((SelfHeight - 120)-height)/2.0;
    //    height = height*2;
     CGRect centerRect = CGRectMake(10, centerY, width, height);
    
    CAShapeLayer *markLayer =  [CAShapeLayer layer];
    markLayer.frame = CGRectMake(0, 0,SelfWidth, SelfHeight - 120);// layer的位置
    markLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;// layer的填充颜色，这里设置了透明度
    markLayer.fillRule = kCAFillRuleEvenOdd;
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathAddRect(maskPath, nil, markLayer.bounds);
    //中间区域
    CGRect maskRect = centerRect;
    CGPathAddRect(maskPath, nil,maskRect);
    markLayer.path = maskPath; //设置要渲染的Path
    [self.view.layer addSublayer:markLayer];
    CGPathRelease(maskPath);
    
    //在相机中加个框
    CALayer *borderlayer=[CALayer layer];
    borderlayer.frame = centerRect;
    borderlayer.borderWidth=1;
    borderlayer.borderColor=[UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:borderlayer];
    self.borderLayer = borderlayer;
    
    
}
#pragma makr - 请求权限
+ (BOOL)requestDeviceAuthorization{

      AVAuthorizationStatus deviceStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted ||
        deviceStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}
//设置相机属性
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = self.backView.bounds;
    [self.backView.layer addSublayer:self.previewLayer];
}
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    return AVCaptureVideoOrientationPortrait;
}

//照相按钮点击事件
-(void)buttondown{

    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image =[UIImage imageWithData:jpegData];

//        UIImage *image = [UIImage imageFromSampleBuffer:imageDataSampleBuffer];

        [self dealImage:image];
       
        
    }];
}


//拍照之后进入相片预览
-(void)dealImage:(UIImage*)image{
    
    NSLog(@"image==%@",@(image.size));
    NSLog(@"image==%@",@(image.imageOrientation));
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    //截取照片，截取到自定义框内的照片
//    image = [self image:image scaleToSize:CGSizeMake(SelfWidth, SelfHeight-120)];
    //应为在展开相片时放大的两倍，截取时也要放大两倍
    
    CGFloat width = SelfWidth - 20;
    CGFloat height = width/1.6;
    CGFloat scale = [UIScreen mainScreen].scale;
//    scale = 2.0;
    CGFloat maskY = ((SelfHeight - 120)-height)/2.0;
    CGRect clipRect = CGRectMake(10*scale, maskY*scale, width*scale, height*scale);

    image = [image fixOrientation];
    image = [self imageFromImage:image inRect:clipRect];


    if (self.delegate) {
        [self.delegate hqCamareVC:self image:image];
    }
    [self.view addSubview:self.preView];
    self.preView.preImage = image;
    //将图片存储到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}
-(UIImage*)image:(UIImage *)imageI scaleToSize:(CGSize)size{
    /*
     UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
     CGSize size：指定将来创建出来的bitmap的大小
     BOOL opaque：设置透明YES代表透明，NO代表不透明
     CGFloat scale：代表缩放,0代表不缩放
     创建出来的bitmap就对应一个UIImage对象
     */
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
    [imageI drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(UIImage *)imageFromImage:(UIImage *)imageI inRect:(CGRect)rect{
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageI.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - HqCamarePreViewDelegate
- (void)hqCamarePreView:(HqCamarePreView *)view image:(UIImage *)image{
    if (self.delegate) {
        [self.delegate hqCamareVC:self image:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
