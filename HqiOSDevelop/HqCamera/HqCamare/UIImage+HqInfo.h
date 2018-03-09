//
//  UIImage+HqInfo.h
//  CameraUse
//
//  Created by macpro on 2018/1/30.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (HqInfo)

- (UIImage *)fixOrientation;
+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end
