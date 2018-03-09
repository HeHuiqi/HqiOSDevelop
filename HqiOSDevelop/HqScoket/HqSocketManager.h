//
//  HqSocketManager.h
//  HqScoket
//
//  Created by macpro on 16/7/26.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
typedef void (^HqScoketSendDataBlock)(id response);

@interface HqSocketManager : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic,copy) HqScoketSendDataBlock block;

+ (instancetype)shareInstance;

- (BOOL)connect;
- (void)disConnect;
- (void)sendData:(NSData *)data block:(HqScoketSendDataBlock)block;

@end
