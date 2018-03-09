//
//  HqCamarePreView.m
//  IRaidCreditIos
//
//  Created by macpro on 2018/1/4.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqCamarePreView.h"

@interface HqCamarePreView()

@property (nonatomic,strong)  UIImageView *imageView;

@end

@implementation HqCamarePreView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor blackColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.image = self.preImage;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"重拍" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(operate:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.tag = 1;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *btnLeft = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
    NSLayoutConstraint *btnBottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30];
    NSLayoutConstraint *btnW = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:40];
    NSLayoutConstraint *btnH = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
    [button addConstraints:@[btnW,btnH]];
    
    [self addConstraint:btnLeft];
    [self addConstraint:btnBottom];
    
    /*
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    */
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
 
    [rightButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [rightButton setTintColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(operate:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    rightButton.tag = 2;
    rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rbtnRight = [NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-30];
    
    NSLayoutConstraint *rbtnBottom = [NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30];
    
    NSLayoutConstraint *rbtnW = [NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:80];
    NSLayoutConstraint *rbtnH = [NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
    [rightButton addConstraints:@[rbtnW,rbtnH]];
    [self addConstraint:rbtnRight];
    [self addConstraint:rbtnBottom];
    
    /*
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    */
}
- (void)setPreImage:(UIImage *)preImage{
    _preImage = preImage;
    if (_preImage) {
        self.imageView.image = _preImage;
    }
}
- (void)operate:(UIButton *)btn{
    
    if (btn.tag==1) {
        [self removeFromSuperview];
    }else{
        if (self.delegate) {
            [self.delegate hqCamarePreView:self image:self.preImage];
        }
    }
}

@end
