//
//  TestVC.m
//  HqScoket
//
//  Created by macpro on 16/7/26.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import "BSDSocketVC.h"
#define HOST @"swdsem.xwf-id.com"
#define PORT 9988

#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>
#import<netdb.h>

@interface BSDSocketVC ()

@end

@implementation BSDSocketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self test];
    [self scoket];
}
- (void)scoket{
    @autoreleasepool {
        int mySocket =socket(AF_INET, SOCK_STREAM, 0);
        BOOL socketCreatsuccess = (mySocket!=-1);
        if (socketCreatsuccess) {
            NSLog(@"socketCreatsuccess");
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len=sizeof(peeraddr);
            peeraddr.sin_family=AF_INET;
            peeraddr.sin_port=htons(PORT);
            peeraddr.sin_addr.s_addr=inet_addr([HOST UTF8String]);
            
            socklen_t addrLen =sizeof(peeraddr);;
            NSLog(@"connecting");
            int connectErr = connect(mySocket, (struct sockaddr *)&peeraddr, addrLen);
            BOOL connectSuccess = (connectErr==0);
            if (connectSuccess) {
               int getHosstErr = getsockname(mySocket, (struct sockaddr *)&peeraddr, &addrLen);
                BOOL getHostSuccess = (getHosstErr==0);
                if (getHostSuccess) {
                    NSLog(@"connectSuccess,address:%s,port:%d",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
                    [self sendDataWithIn:mySocket];
                }
            }
            else{
                NSLog(@"connect failed");
            }
        }else{
            NSLog(@"socketCreatFail");
        }
    }
//    char buf[1024];
//    send(mySocket, buf, 1024, 0);//发送数据
//    recv(mySocket, buf, 1024, 0);//接收数据
//    close(mySocket);//断开连接

}
- (NSMutableData *)dealData:(NSData *)data{
    //不足六位前面补0
    NSString *dataLengthStr = [NSString stringWithFormat:@"%06d",(int)data.length];
    
    NSData *preData = [dataLengthStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *commond = [NSMutableData dataWithData:preData];
    [commond appendData:data];
    
    return commond;
}
- (void)sendDataWithIn:(int)socket{
    NSLog(@"socket = %d",socket);
    NSString *requestStr = @"000246<cps><excecute_result>0000</excecute_result><version>01</version><svrcode>100002</svrcode><card_number>6259624430003105</card_number><atr>409078891981509901196104000300350003408261041293610400000000000000000000000000000000</atr><sessionid/></cps>";
  
    NSData *data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    data = [self dealData:data];
    ssize_t sendSuccess = send(socket, [data bytes], data.length, 0);
    
    NSLog(@"sendSuccess == %ld",sendSuccess);

    if(sendSuccess == [data length])
    {
        NSLog(@"Datas have been sended over!");
    }
    const char *buffer[1024];
    int length = sizeof(buffer);
    memset(buffer,0x00,1024);

    if (sendSuccess != 0) {
        
        ssize_t reciveSuccess = recv(socket, buffer, length, 0);
        NSLog(@"reciveSuccess == %ld",reciveSuccess);
        if (reciveSuccess != 0) {

            NSString *message = [NSString stringWithCString:(char *)buffer encoding:NSUTF8StringEncoding];
            
            NSLog(@"message====%@",message);

        }

    }
}
- (void)test
{
    
    // 创建 socket
    int socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == socketFileDescriptor) {
        NSLog(@"创建失败");
        return;
    }
    
    // 获取 IP 地址
    struct hostent * remoteHostEnt = gethostbyname([HOST UTF8String]);
    if (NULL == remoteHostEnt) {
        close(socketFileDescriptor);
        NSLog(@"%@",@"无法解析服务器的主机名");
        return;
    }
    
    struct in_addr * remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    
    // 设置 socket 参数
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr = *remoteInAddr;
    socketParameters.sin_port = htons(PORT);
    
    // 连接 socket
    int ret = connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    if (-1 == ret) {
        close(socketFileDescriptor);
        NSLog(@"连接失败");
        return;
    }
    
    NSLog(@"连接成功");
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
