//
//  HqCamareVC.h
//  IRaidCreditIos
//
//  Created by macpro on 2018/1/4.
//  Copyright © 2018年 macpro. All rights reserved.
//自定义相机
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol HqCamareVCDelegate;
@interface HqCamareVC : UIViewController

@property (nonatomic,strong) id<HqCamareVCDelegate> delegate;
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

/**
 *  最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;
@property (nonatomic, strong) UIView *backView;

+ (BOOL)requestDeviceAuthorization;

@end

@protocol HqCamareVCDelegate

@optional
- (void)hqCamareVC:(HqCamareVC *)vc image:(UIImage *)image;

@end

