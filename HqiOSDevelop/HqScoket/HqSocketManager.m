//
//  HqSocketManager.m
//  HqScoket
//
//  Created by macpro on 16/7/26.
//  Copyright © 2016年 macpro. All rights reserved.
//
//#define HOST @"121.43.176.94"
//#define PORT 9988

#define HOST @"swdsem.xwf-id.com"
#define PORT 9988

#import "HqSocketManager.h"

@implementation HqSocketManager

+ (instancetype)shareInstance{
   static HqSocketManager *hq = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hq = [[HqSocketManager alloc]init];
    });
    return hq;
}
- (BOOL)connect{
    if (![self.asyncSocket isConnected]) {
        BOOL isConnect =[self connectServer];
        return isConnect;
    }
    return YES;
}
- (GCDAsyncSocket *)asyncSocket{
    if (!_asyncSocket) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    }
    return _asyncSocket;
}
- (BOOL)connectServer{
    NSError *error = nil;
    BOOL isConnect = [self.asyncSocket connectToHost:HOST onPort:PORT error:&error];
    if (!isConnect)
    {
        NSLog(@"Error connecting: %@", error);
    }
    return isConnect;
}
- (void)disConnect{
    [_asyncSocket disconnect];
}
- (void)sendData:(NSData *)data block:(HqScoketSendDataBlock)block{
    self.block = block;
   
    
    NSMutableData *commond = [self dealData:data];
    
    [self.asyncSocket writeData:commond withTimeout:-1 tag:0];
    
}
- (NSString *)xmlStrWithResult{
    NSString *str = [NSString stringWithFormat:@"<cps><excecute_result>0000</excecute_result><version>01</version><svrcode>100002</svrcode><card_number>6259624430003105</card_number><atr>409078891981509901196104000300350003408261041293610400000000000000000000000000000000</atr><sessionid/></cps>\r\n"];
    return str;
}
- (NSMutableData *)dealData:(NSData *)data{
    
    NSString *dataLengthStr = [NSString stringWithFormat:@"%d",(int)data.length];
    switch (dataLengthStr.length) {
        case 1:
        {
            dataLengthStr = [NSString stringWithFormat:@"00000%@",dataLengthStr];
        }
        break;
        case 2:
        {
            dataLengthStr = [NSString stringWithFormat:@"0000%@",dataLengthStr];
        }
        break;
        
        case 3:
        {
            dataLengthStr = [NSString stringWithFormat:@"000%@",dataLengthStr];
        }
        break;
        
        case 4:
        {
            dataLengthStr = [NSString stringWithFormat:@"00%@",dataLengthStr];
        }
        break;
        
        case 5:
        {
            dataLengthStr = [NSString stringWithFormat:@"0%@",dataLengthStr];
        }
        break;
        
        case 6:
        {
            dataLengthStr = [NSString stringWithFormat:@"%@",dataLengthStr];
        }
        break;
        
        
        default:
        break;
    }
    
    NSData *preData = [dataLengthStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *commond = [NSMutableData dataWithData:preData];
    [commond appendData:data];
    
    return commond;
}
#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"response:\n%@", response);
    
    if (response) {
        if (self.block) {
            self.block(response);
        }
    }
   
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

@end
