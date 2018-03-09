//
//  GNASocket.m
//  SocketUse
//
//  Created by macpro on 16/5/9.
//  Copyright © 2016年 macpro. All rights reserved.
//

#import "GNASocket.h"

@implementation GNASocket

+ (GNASocket *)defaultScocket
{
    static GNASocket *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[GNASocket alloc] init];
    });
    return socket;
}

@end
