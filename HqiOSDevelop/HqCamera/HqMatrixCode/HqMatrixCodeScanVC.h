//
//  HqMatrixCodeScanVC.h
//  CameraUse
//
//  Created by macpro on 2018/2/26.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface HqMatrixCodeScanVC : UIViewController

@property (nonatomic,strong) AVCaptureSession *captureSession;//捕捉会话

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;//输入流

@property (nonatomic,strong) AVCaptureMetadataOutput *metaDataOutput;//输出流

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//预览涂层


@end
