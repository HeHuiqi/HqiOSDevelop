//
//  ServerSocket.m
//  SocketUse
//
//  Created by macpro on 16/5/9.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import "ServerSocket.h"
#import "GCDAsyncSocket.h"
#import "GNASocket.h"
@interface ServerSocket ()


@property (nonatomic, strong) GCDAsyncSocket *clientSocket;// 为客户端生成的socket

// 服务器socket
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;

@end

@implementation ServerSocket

- (void)viewDidLoad {
    [super viewDidLoad];
    [self listen:nil];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
    [btn setTitle:@"server:send" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(btn.frame)+20, 100, 40)];
    [btn1 setTitle:@"server:write" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 addTarget:self action:@selector(receiveMassage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}
// 服务端监听某个端口
- (IBAction)listen:(UIButton *)sender
{
    // 1. 创建服务器socket
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 开放哪些端口
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:10000 error:&error];
    
    // 3. 判断端口号是否开放成功
    if (result) {
        NSLog(@"端口开放成功");
    } else {
        NSLog(@"端口开放失败");
    }
}
// 发送
- (IBAction)sendMessage:(UIButton *)sender
{
    NSData *data = [@"父亲说：天不会下雨" dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];

    GNASocket *socket = [GNASocket defaultScocket];
    [socket.mySocket readDataWithTimeout:-1 tag:0];
}
// 接收消息
- (IBAction)receiveMassage:(UIButton *)sender
{
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate
// 当客户端链接服务器端的socket, 为客户端单生成一个socket
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"链接成功");

    //IP: newSocket.connectedHost
    //端口号: newSocket.connectedPort
  
    // short: %hd
    // unsigned short: %hu
    
    // 存储新的端口号
    self.clientSocket = newSocket;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务端读取到消息： %@",message);
}
@end
