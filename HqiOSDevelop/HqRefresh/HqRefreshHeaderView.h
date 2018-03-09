//
//  HqRefreshHeaderView.h
//  HqRefresh
//
//  Created by macpro on 2018/1/3.
//  Copyright © 2018年 macpro. All rights reserved.
//
/**
 usage:
 [_tableView addSubview:self.refreshHeaderView];
 [self.refreshHeaderView refreshComplete:^{
    NSLog(@"刷新完成");
 }];
 */
typedef void(^HqRefreshComplete)(void);
#import <UIKit/UIKit.h>
#define HqHeaderHeight 50.0
@interface HqRefreshHeaderView : UIView
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) UIScrollView *hqScrollView;
@property (nonatomic,copy) HqRefreshComplete refreshComplete;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)refreshComplete:(HqRefreshComplete)complete;

- (void)startAnimation;
- (void)stopAnimation;
@end
