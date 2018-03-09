//
//  HqCamarePreView.h
//  IRaidCreditIos
//
//  Created by macpro on 2018/1/4.
//  Copyright © 2018年 macpro. All rights reserved.
//自动相机拍照后的预览试图

#import <UIKit/UIKit.h>
@protocol HqCamarePreViewDelegate;

@interface HqCamarePreView : UIView
@property (nonatomic,strong) UIImage *preImage;
@property (nonatomic,assign) id<HqCamarePreViewDelegate> delegate;

@end


@protocol HqCamarePreViewDelegate

@optional
- (void)hqCamarePreView:(HqCamarePreView *)view image:(UIImage *)image;
- (void)resetHqCamarePreView:(HqCamarePreView *)view;

@end


