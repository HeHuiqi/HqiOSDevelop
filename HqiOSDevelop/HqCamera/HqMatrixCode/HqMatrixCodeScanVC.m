//
//  HqMatrixCodeScanVC.m
//  CameraUse
//
//  Created by macpro on 2018/2/26.
//  Copyright © 2018年 macpro. All rights reserved.
//扫描二维码

#import "HqMatrixCodeScanVC.h"

@interface HqMatrixCodeScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation HqMatrixCodeScanVC

- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}
- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _deviceInput;
}
- (AVCaptureMetadataOutput *)metaDataOutput{
    if (!_metaDataOutput) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metaDataOutput setMetadataObjectsDelegate:self queue:        dispatch_get_main_queue()];
 
    }
    return _metaDataOutput;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.frame = self.view.bounds;
    }
    return _videoPreviewLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //获取到扫描的数据
    AVMetadataMachineReadableCodeObject *dateObject = (AVMetadataMachineReadableCodeObject *) [metadataObjects lastObject];
    NSLog(@"metadataObjects[last]==%@",dateObject.stringValue);
}
#pragma makr - 请求权限
- (BOOL)requestDeviceAuthorization{
    
    AVAuthorizationStatus deviceStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted ||
        deviceStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

//开始扫描
- (void)startCapture{
    if (![self requestDeviceAuthorization]) {
        NSLog(@"没有访问相机权限！");
        return;
    }
    //这也可以判断相机权限
    /*
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
        if (granted) {

        }else{
           
        }
    }];
    */
    [self.captureSession beginConfiguration];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    // 设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    if ([self.captureSession canAddOutput:self.metaDataOutput]) {
        [self.captureSession addOutput:self.metaDataOutput];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSArray *types = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code];
        self.metaDataOutput.metadataObjectTypes =types;
//        NSArray *metadatTypes =  [_metaDataOutput availableMetadataObjectTypes];
//        NSLog(@"metadatTypes == %@",metadatTypes);
    }
    [self.captureSession commitConfiguration];
    
    [self.captureSession startRunning];
}
//停止扫描
- (void)stopCapture{
    [self.captureSession stopRunning];
}
- (void)dealloc{
    [self.captureSession stopRunning];
    self.deviceInput = nil;
    self.metaDataOutput = nil;
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer:self.videoPreviewLayer];
    [self startCapture];

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
