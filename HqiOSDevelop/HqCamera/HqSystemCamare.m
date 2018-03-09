//
//  HqSystemCamare.m
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/9.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqSystemCamare.h"
@interface HqSystemCamare ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)  UIImagePickerController *pickerImageVC;

@end

@implementation HqSystemCamare
- (instancetype)init{
    if (self = [super init]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return self;
}
- (void)setSourceType:(UIImagePickerControllerSourceType)sourceType{
    _sourceType = sourceType;
}
- (BOOL)sourceTypeIsCanUse{
    
    return [UIImagePickerController isSourceTypeAvailable:self.sourceTypeIsCanUse];
}
- (UIImagePickerController *)pickerImageVC{
    if (!_pickerImageVC) {
        _pickerImageVC = [[UIImagePickerController alloc] init];
        _pickerImageVC.sourceType = self.sourceType;
        _pickerImageVC.delegate = self;
        _pickerImageVC.editing = self.isEdit;
    }
    return _pickerImageVC;
}
- (void)hqPickerImageVC:(UIViewController *)viewController{
    
    [viewController presentViewController:self.pickerImageVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.isSavedPhotosAlbum) {
        UIImageWriteToSavedPhotosAlbum(image, nil, NULL, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
