//
//  GNASocket.h
//  SocketUse
//
//  Created by macpro on 16/5/9.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@interface GNASocket : NSObject


@property (nonatomic, strong) GCDAsyncSocket *mySocket;

+ (GNASocket *)defaultScocket;

@end
