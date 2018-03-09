//
//  GestureLockView.h
//  GestureLock
//
//  Created by macpro on 15/6/30.
//  Copyright (c) 2015年 macpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GestureLockView;

@protocol GestureLockDelegate <NSObject>

@optional

- (void)GestureLockSetResult:(NSString *)result gestureView:(GestureLockView *)gestureView;
- (void)GestureLockPasswordRight:(GestureLockView *)gestureView;
- (void)GestureLockPasswordWrong:(GestureLockView *)gestureView;

@end

@interface GestureLockView : UIView

@property (assign, nonatomic) id<GestureLockDelegate> delegate;

- (void)setRigthResult:(NSString *)rightResult;

@end
