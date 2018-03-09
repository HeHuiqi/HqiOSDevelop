//
//  ViewController.m
//  SocketUse
//
//  Created by macpro on 16/5/9.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import "ClientSocket.h"
#import "GCDAsyncSocket.h"
#import "GNASocket.h"

@interface ClientSocket ()


@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation ClientSocket


// 和服务器进行链接
- (IBAction)connect:(UIButton *)sender
{
    // 1. 创建socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 与服务器的socket链接起来
    NSError *error = nil;
    BOOL result = [self.socket connectToHost:@"172.168.16.165" onPort:10000 error:&error];
    
    // 3. 判断链接是否成功
    if (result) {
        NSLog(@"客户端链接服务器成功");
    } else {
        NSLog(@"客户端链接服务器失败");
    }
}
// 接收数据
- (IBAction)receiveMassage:(UIButton *)sender
{
    [self.socket readDataWithTimeout:-1 tag:0];
    
    GNASocket *socket = [GNASocket defaultScocket];
    [socket.mySocket readDataWithTimeout:-1 tag:0];
}

// 发送消息
- (IBAction)sendMassage:(UIButton *)sender
{
    [self.socket writeData:[@"孩子说：天要下雨" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

// 客户端链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    NSLog(@"链接服务器%@", host);

    GNASocket *socket = [GNASocket defaultScocket];
    socket.mySocket = self.socket;
    
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"客户端收到消息 :%@",content);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self connect:nil];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
    [btn setTitle:@"client:send" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(sendMassage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(btn.frame)+20, 100, 40)];
    [btn1 setTitle:@"client:write" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 addTarget:self action:@selector(receiveMassage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
