//
//  HqGetUserInfo.h
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/27.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqGetUserInfo : NSObject

@property (nonatomic,copy) NSString *userId;

- (void)addTarget:(id)target action:(SEL)action;
- (void)startGetInfo;

@end
