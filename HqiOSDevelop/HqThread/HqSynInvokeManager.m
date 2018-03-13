//
//  HqSynInvokeManager.m
//  GCDUse
//
//  Created by macpro on 2017/9/26.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqSynInvokeManager.h"
@interface HqSynInvokeManager ()

@property (nonatomic,assign) int flag;
@property (nonatomic,strong) NSMutableArray *methodCounter;

@end
static HqSynInvokeManager *_invokeManager = nil;
@implementation HqSynInvokeManager

+ (void)load{
    NSLog(@"load");

    [HqSynInvokeManager sharedInstance];

}
+ (void)initialize{
    NSLog(@"initialize");
}
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _invokeManager = [[HqSynInvokeManager alloc] init];
    });
    return _invokeManager;
}
+ (instancetype)alloc{
    if (_invokeManager) {
        /*
        NSException *exception = [[NSException alloc] initWithName:@"HqSynInvokeManager" reason:@"HqSynInvokeManager only one Instance" userInfo:nil];
        [exception raise];
        */
        //兼容如果有一个实例了，就不要在重新创建了，直接返回
        return _invokeManager;
    }
    return [super alloc];
}
- (instancetype)init{
    if (self = [super init]) {
        _flag = 0;
        _methodCounter = [NSMutableArray arrayWithCapacity:0];
         [self addObserver:self forKeyPath:@"flag" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)getSportBlock:(ResultBlock)block{
    [self invokeMethod:@selector(asynTask1Block:) params:@[block]];
}
#pragma mark - HqSynInvoke
- (void)resetCounter{
    if (self.methodCounter.count>0) {
        [self.methodCounter removeAllObjects];
    }
    self.flag = 0;
}

- (void)invokeMethod:(SEL)selector params:(NSArray *)params{

    if (_flag==0) {
        
        self.flag=_flag+1;
        NSString *methodName = nil;
        if (_methodCounter.count!=0) {
            NSDictionary *methodDic = _methodCounter[0];
            methodName = methodDic[@"methodName"];
            params = methodDic[@"params"];
            [_methodCounter removeObjectAtIndex:0];
            selector = NSSelectorFromString(methodName);
        }
        [self dealInvokeMethod:selector param:params];
    }else{
        NSString *methodName = NSStringFromSelector(selector);
        NSDictionary *methodDic = @{@"methodName":methodName,
                                    @"params":params
                                    };
        [_methodCounter addObject:methodDic];
    }
}
#pragma mark - 有block回调参数
- (void)dealInvokeMethod:(SEL)selector param:(NSArray *)params{
    /*
     NSMethodSignature签名：再创建NSMethodSignature的时候，必须传递一个签名对象。
     签名对象的作用：用于获取参数的个数和方法的返回值。
     NSInvocation用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数。
     invocation中的selector必须和签名中的selector一致。
     */
    //创建签名对象的时候不是使用NSMethodSignature这个类创建，而是方法属于谁就用谁来创建
    NSMethodSignature*signature = [HqSynInvokeManager instanceMethodSignatureForSelector:selector];
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    
    invocation.selector = selector;
    /*
     设置参数，第一个表示参数地址，第二个表示参数索引
     注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
     */
    NSUInteger args = signature.numberOfArguments;
    if (params.count>0) {
        for (int i = 0; i<args-2; i++) {
            const char *dataType = [signature getArgumentTypeAtIndex:i+2];
            NSLog(@"char===%s",dataType);
            switch (dataType[0]) {
                case 'i':
                {
                    int arg = [params[i] intValue];
                    [invocation setArgument:&arg atIndex:i+2];
                }
                    
                    break;
                    
                default:
                    
                {
                    //默认都是@?类型
                    id obj = params[i];
                    [invocation setArgument:&obj atIndex:i+2];
                }
                    
                    break;
            }
        }
    }
    
    //只要调用invocation的invoke方法，就代表需要执行NSInvocation对象中制定对象的指定方法，并且传递指定的参数
    [invocation invoke];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"flag"]) {
        if (_flag==0&&_methodCounter.count>0) {
            
            id method = _methodCounter[0];
            if ([method isKindOfClass:[NSDictionary class]]) {
                NSDictionary *methodDic = method;
                NSString  *methodName = methodDic[@"methodName"];
                NSArray *params = methodDic[@"params"];
                SEL selector = NSSelectorFromString(methodName);
                [self invokeMethod:selector params:params];
            }
        }
    }
}

#pragma mark - 模拟异步调用
- (void)asynTask1Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask1---start");
        sleep(1);
        block();
        self.flag = _flag-1;


    });
}
- (void)asynTask2Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask2---start");
         sleep(1);
        block();
        self.flag = _flag-1;

    });
}
- (void)asynTask3Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask3---start");
         sleep(1);
        block();
        self.flag = _flag-1;

    });
}
- (void)asynTask4Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask4---start");
         sleep(1);
        block();
        self.flag = _flag-1;

    });
}

- (void)asynTask5Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask5---start");
         sleep(1);
        block();
        self.flag = _flag-1;

    });
}
- (void)asynTask6Block:(ResultBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"asynTask6---start");
         sleep(1);
        block();
        self.flag = _flag-1;
    });
}

@end
