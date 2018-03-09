//
//  ViewController.m
//  HqiOSWebServer
//
//  Created by macpro on 2017/12/7.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqWebServerVC.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebUploader.h"
@interface HqWebServerVC ()<GCDWebServerDelegate>


@property (nonatomic,strong) GCDWebServer *webServer;
@property (nonatomic,strong) GCDWebUploader *webUploader;
@property (nonatomic,strong) UILabel *labInfo;


@end

@implementation HqWebServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    


    _webServer = [[GCDWebServer alloc] init];
    _webServer.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [_webServer addDefaultHandlerForMethod:@"GET" requestClass:GCDWebServerRequest.class processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
        return [weakSelf createResponse];
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"开启服务器" forState:UIControlStateNormal];
    [btn setTitle:@"关闭服务器" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(openServer:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, 80, 100, 80);
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"开启上传文件服务器" forState:UIControlStateNormal];
    [btn1 setTitle:@"关闭上传文件服务器" forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(openUploadServer:)
   forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 2;
    btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame)+40, 80, 150, 80);
    [self.view addSubview:btn1];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn.frame)+20, 200, 20)];
    info.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:info];
    _labInfo = info;
    
}
- (void)openUploadServer:(UIButton *)btn{
    
    if (_webServer.isRunning) {
        NSString *url = _webServer.serverURL.absoluteString;
        _labInfo.text = [NSString stringWithFormat:@"服务正在运行：%@",url];
        return;
    }
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [_webUploader start];
    }else{
        [_webUploader stop];
    }
    NSString *url = _webUploader.serverURL.absoluteString;
    _labInfo.text = url;
}
- (void)openServer:(UIButton *)btn{
    
    if (_webUploader.isRunning) {
        NSString *url = _webUploader.serverURL.absoluteString;
        _labInfo.text = [NSString stringWithFormat:@"服务正在运行：%@",url];
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        [_webServer start];
    }else{
        [_webServer stop];
    }
    NSString *url = _webServer.serverURL.absoluteString;
    _labInfo.text = url;
}
- (GCDWebServerResponse *)createResponse{
    
    GCDWebServerResponse *response = [GCDWebServerDataResponse responseWithHTML:@"<h1>欢迎使用GCDWebServer<h1>"];
    return response;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
