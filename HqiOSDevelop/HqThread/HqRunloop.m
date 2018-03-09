//
//  HqRunloop.m
//  GCDUse
//
//  Created by macpro on 2017/11/30.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqRunloop.h"

@implementation HqRunloop

- (void)hqObeserver{
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });
    
    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // 释放observer，最后添加完需要释放掉
    CFRelease(observer);
}
- (void)hqTimerRunloop{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(count) userInfo:nil repeats:YES];    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}
- (void)count{
    static int i = 0;
    i+= 2;
    NSLog(@"i==%d",i);
}
@end

