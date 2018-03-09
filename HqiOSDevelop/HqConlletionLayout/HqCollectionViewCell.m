//
//  HqCollectionViewCell.m
//  HqCollectinoViewLayoutUse
//
//  Created by macpro on 2017/4/10.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqCollectionViewCell.h"

@implementation HqCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    
    CGFloat height = self.bounds.size.height;
    int h = arc4random()%(int)height;
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, height-h, self.bounds.size.width, h)];
    [self addSubview:_label];
    _label.backgroundColor = [UIColor whiteColor];
    
    
    _label.font = [UIFont systemFontOfSize:20];
    _label.textAlignment = NSTextAlignmentCenter;
}


@end
