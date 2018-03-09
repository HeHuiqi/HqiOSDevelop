//
//  HqThread.m
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/9.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqThread.h"
#import "HqSynInvokeManager.h"

@interface HqThread ()

@property (nonatomic,strong) HqSynInvokeManager *synInvokeManger;

@end

@implementation HqThread

//根据屏幕刷新频率来不断调用方法，可用来做动画
- (void)HqDisplayLink{

    CADisplayLink *displayLink =  [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)refresh{
    NSLog(@"---");
}

//同步执行异步任务
- (void)invokeManager{
    _synInvokeManger = [HqSynInvokeManager sharedInstance];
    NSLog(@"---2%@",_synInvokeManger);
    
    [_synInvokeManger getSportBlock:^{
        NSLog(@"getSportBlock1");
    }];
    [_synInvokeManger getSportBlock:^{
        NSLog(@"getSportBlock2");
        
    }];
    [_synInvokeManger getSportBlock:^{
        NSLog(@"getSportBlock3");
        
    }];
    [_synInvokeManger getSportBlock:^{
        NSLog(@"getSportBlock4");
        
    }];
}

//信号量
-(void)dispatchSignal{
    //crate的value表示，最多几个资源可访问,即可以有几个线程同时执行
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}
-(void)task0{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 30; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(5);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)task1{
    NSLog(@"并行队列，异步执行....");
    dispatch_queue_t queue = dispatch_queue_create("hhq_queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"task1==");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"task2==");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"task3==");
    });
    
    NSLog(@"串行队列，异步执行....");
    dispatch_queue_t serialQueue = dispatch_queue_create("hhq_serial_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"task4==");
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"task5==");
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"task6==");
    });
    //同步任务
    dispatch_sync(serialQueue, ^{
        NSLog(@"task7==");
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"全局队列处理数据");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"住队列刷新界面");
        });
    });
    
}

@end
