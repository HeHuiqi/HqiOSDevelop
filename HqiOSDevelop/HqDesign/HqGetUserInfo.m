//
//  HqGetUserInfo.m
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/27.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqGetUserInfo.h"
#import <objc/message.h>
@interface HqGetUserInfo()

@property (nonatomic,weak) id target;
@property (nonatomic,assign) SEL action;

@end


@implementation HqGetUserInfo

- (NSString *)userId{
    return @"9875660";
}
- (void)addTarget:(id)target action:(SEL)action{
    if ([target respondsToSelector:action]) {
        self.target = target;
        self.action = action;
        
    }
}
- (void)startGetInfo{
    
    NSMethodSignature *msign = [self.target methodSignatureForSelector:self.action];
    NSInteger args = [msign numberOfArguments];

    //第一种调用方式,这种方式会有警告
    /*
     if (args>=3) {
     [self.target performSelector:self.action withObject:self];
     }else{
     [self.target performSelector:self.action];
     }
     */
    //第二种调用方式
    /*
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:msign];
    invocation.target = self.target;
    invocation.selector = self.action;
    if (args>=3) {
        id userInfo = self;
        //可指定某个位置的参数，参数从下标2开始，前两个分别是self.target,self.action
        [invocation setArgument:&userInfo atIndex:2];
    }
    [invocation invoke];
    */
    
    //第三种调用方式,IMP 函数指针调用方式，类似于C函数的调用方式
    /*
    Method method = class_getInstanceMethod([self.target class], self.action);
    int arguments = method_getNumberOfArguments(method);
    IMP IMP_method = method_getImplementation(method);
    if (arguments>=3) {
        IMP_method(self.target,self.action,self);
    }else{
        IMP_method(self.target,self.action);
    }
    */
   
    //第四种调用方式，objc_msgSend(id _Nullable self, SEL _Nonnull op, ...),多参数输入
    //最终都会变成这种形式的：消息发送
    if (args>=3) {
        objc_msgSend(self.target, self.action,self);
    }else{
        objc_msgSend(self.target, self.action);
    }
    
}

@end
