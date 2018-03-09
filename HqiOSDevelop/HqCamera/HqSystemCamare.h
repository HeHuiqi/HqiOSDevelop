//
//  HqSystemCamare.h
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/9.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol HqSystemCamareDelegate;
@interface HqSystemCamare : NSObject

@property (nonatomic,assign) id<HqSystemCamareDelegate> delegate;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,assign) BOOL isSavedPhotosAlbum;
@property (nonatomic,assign,readonly) BOOL sourceTypeIsCanUse;
@property (nonatomic,assign) UIImagePickerControllerSourceType sourceType;

- (void)hqPickerImageVC:(UIViewController *)viewController;

@end

@protocol HqSystemCamareDelegate

@optional
- (void)hqSystemCamare:(HqSystemCamare *)systemCamare image:(UIImage *)image;

@end
