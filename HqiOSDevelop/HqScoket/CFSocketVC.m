//
//  ClientVC.m
//  HqScoket
//
//  Created by macpro on 16/7/26.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import "CFSocketVC.h"
#define HOST @"swdsem.xwf-id.com"
#define PORT 9988

@interface CFSocketVC ()<NSStreamDelegate>

{
    NSInputStream *_inputStream;//对应输入流
    NSOutputStream *_outputStream;//对应输出
}

@end

@implementation CFSocketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送数据" style:UIBarButtonItemStylePlain target:self action:@selector(sendData)];
    [self connect];
}
- (void)sendData{
    [self writeTestData];
}
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    
//      NSStreamEventOpenCompleted = 1UL << 0,//输入输出流打开完成
//      NSStreamEventHasBytesAvailable = 1UL << 1,//有字节可读
//      NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发放字节
//      NSStreamEventErrorOccurred = 1UL << 3,// 连接出现错误
//      NSStreamEventEndEncountered = 1UL << 4// 连接结束
        switch (eventCode) {
               case NSStreamEventOpenCompleted:
                     NSLog(@"输入输出流打开完成");
                   break;
                 case NSStreamEventHasBytesAvailable:
                     NSLog(@"有字节可读");
                    [self readData];
                     break;
               case NSStreamEventHasSpaceAvailable:
                    NSLog(@"可以发送字节");

                     break;
                 case NSStreamEventErrorOccurred:
                    NSLog(@" 连接出现错误");
                    break;
                 case NSStreamEventEndEncountered:
                     NSLog(@"连接结束");
        
                     // 关闭输入输出流
                    [_inputStream close];
                    [_outputStream close];
        
                     // 从主运行循环移除
                     [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                     [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                     break;
                 default:
                  break;
             }
}
- (void)connect{
// 1.建立连接
    NSString *host = HOST;
    int port = PORT;

     // 定义C语言输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
     // 把C语言的输入输出流转化成OC对象
    _inputStream = (__bridge NSInputStream *)(readStream);
    _outputStream = (__bridge NSOutputStream *)(writeStream);

     // 设置代理
    _inputStream.delegate = self;
    _outputStream.delegate = self;


    // 把输入输入流添加到主运行循环
     // 不添加主运行循环 代理有可能不工作
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

     // 打开输入输出流
    [_inputStream open];
    [_outputStream open];
}
- (void)writeTestData{
    
    NSString *requestStr = @"<cps><excecute_result>0000</excecute_result><version>01</version><svrcode>100002</svrcode><card_number>6259624430003105</card_number><atr>409078891981509901196104000300350003408261041293610400000000000000000000000000000000</atr><sessionid/></cps>";
    NSData *data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    data = [self dealData:data];
    
    [self writeData:data];
    
}
- (void)writeData:(NSData *)data{
    
    [_outputStream write:data.bytes maxLength:data.length];
}
- (NSMutableData *)dealData:(NSData *)data{
    //不足六位前面补0
    NSString *dataLengthStr = [NSString stringWithFormat:@"%06d",(int)data.length];
    
    NSData *preData = [dataLengthStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *commond = [NSMutableData dataWithData:preData];
    [commond appendData:data];
    
    return commond;
}
#pragma mark 读了服务器返回的数据
- (void)readData{
    
       //建立一个缓冲区 可以放1024个字节
        uint8_t buf[1024];
   
       // 返回实际装的字节数
         NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
   
         // 把字节数组转化成字符串
         NSData *data = [NSData dataWithBytes:buf length:len];
    
         // 从服务器接收到的数据
        NSString *recStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
        NSLog(@"读取的数据＝＝%@",recStr);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
