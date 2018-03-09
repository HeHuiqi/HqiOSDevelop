//
//  HqSynInvokeManager.h
//  GCDUse
//
//  Created by macpro on 2017/9/26.
//  Copyright © 2017年 macpro. All rights reserved.
//

/*
 HqSynInvokeManager类实现的是异步任务的同步调用，相当于一个同步队列
 它会按照调用异步任务的顺序依次执行
 */
#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(void);

@interface HqSynInvokeManager : NSObject

+ (instancetype)sharedInstance;
- (void)getSportBlock:(ResultBlock)block;

@end
