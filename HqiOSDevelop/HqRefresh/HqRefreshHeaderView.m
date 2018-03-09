//
//  HqRefreshHeaderView.m
//  HqRefresh
//
//  Created by macpro on 2018/1/3.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqRefreshHeaderView.h"

@implementation HqRefreshHeaderView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        self.hqScrollView = scrollView;
        self.frame = CGRectMake(0, -HqHeaderHeight, scrollView.bounds.size.width, HqHeaderHeight);
        [self setup];
    }
    return self;
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"_hqScrollView.contentOffset"];
}
- (void)setHqScrollView:(UIScrollView *)hqScrollView{
    _hqScrollView = hqScrollView;
    if (_hqScrollView) {
         [self addObserver:self forKeyPath:@"_hqScrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void)setup{
    
    
    CAShapeLayer *bgCircle = [CAShapeLayer layer];
    bgCircle.lineWidth = 2.0;
    CGFloat width = 20;
    CGFloat height = 20;
    CGFloat x = (self.bounds.size.width - width)/2.0;
    CGFloat y = (self.bounds.size.height-height)/2.0;
    bgCircle.frame = CGRectMake(x, y, width, height);
    
    UIBezierPath *bgCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    UIColor *bgColor = [[UIColor redColor] colorWithAlphaComponent:0.3];

    bgCircle.strokeColor = bgColor.CGColor;
    bgCircle.fillColor = [UIColor clearColor].CGColor;
    bgCircle.path = bgCirclePath.CGPath;
 
    bgCircle.strokeStart = 0.0;
    bgCircle.strokeEnd = 1.0;
    [self.layer addSublayer:bgCircle];
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 2.0;
    circleLayer.frame = CGRectMake(x, y, width, height);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.path = circlePath.CGPath;
    self.circleLayer = circleLayer;
    circleLayer.strokeStart = 0.0;
    circleLayer.strokeEnd = .0;
    [self.layer addSublayer:self.circleLayer];
}
- (void)startAnimation{
    
    [self.circleLayer removeAllAnimations];
    self.circleLayer.strokeStart = 0.0;
    self.circleLayer.strokeEnd = 0.2;
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.fromValue = @(0);
    baseAnimation.toValue = @(M_PI*2);
    baseAnimation.duration = 1.0;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    baseAnimation.repeatCount = HUGE;
    baseAnimation.removedOnCompletion = NO;
   
    [self.circleLayer addAnimation:baseAnimation forKey:@"rotation"];
    
}
- (void)stopAnimation{
    self.circleLayer.strokeEnd = 0.0;
    [self.circleLayer removeAllAnimations];
}
- (void)endRefresh{
    [UIView animateWithDuration:0.5 animations:^{
        self.hqScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        if (self.refreshComplete) {
            self.refreshComplete();
        }
    }];
    [self stopAnimation];
}
- (void)refreshComplete:(HqRefreshComplete)complete{
    self.refreshComplete = complete;
    [self endRefresh];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSValue *value = [change objectForKey:@"new"];
    
    CGFloat yOffset = value.CGPointValue.y;
    NSLog(@"yOffset==%f",yOffset);
    if (yOffset == 0) {
        [self stopAnimation];
    }
    CGFloat pullHeight = 1.5*HqHeaderHeight;
    
    if (!self.hqScrollView.isDragging&&-yOffset>=pullHeight) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"startAnimation");
            
            [UIView animateWithDuration:0.3 animations:^{
                self.hqScrollView.contentInset = UIEdgeInsetsMake(pullHeight, 0, 0, 0);
                
            } completion:^(BOOL finished) {
                [self startAnimation];
            }];
        });
        return;
    }
    
    if (-yOffset>HqHeaderHeight) {
        self.circleLayer.strokeEnd = -yOffset/HqHeaderHeight;
        //        self.alpha = -yOffset/HqHeaderHeight;
        
    }
    if (-yOffset>=HqHeaderHeight) {
        self.circleLayer.strokeEnd = 1.0;
        //        self.alpha = 1.0;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
