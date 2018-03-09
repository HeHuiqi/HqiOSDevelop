//
//  HqPathDraw.m
//  DrawUse
//
//  Created by macpro on 2018/1/4.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqDrawVC.h"
@interface HqDrawVC ()

@end

@implementation HqDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self overDraw1];
  
}
- (void)overDraw0{
    CAShapeLayer *markLayer =  [CAShapeLayer layer];
    markLayer.frame = CGRectMake(10, 100, 150, 150);// layer的位置
    markLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;// layer的填充颜色，这里设置了透明度
    markLayer.fillRule = kCAFillRuleEvenOdd;
  
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, markLayer.bounds);
    //中间区域
    CGPathAddRect(path, nil, CGRectMake(20, 10, 50, 50));
    
    markLayer.path = path; //设置要渲染的Path
    [self.view.layer addSublayer:markLayer];
    CGPathRelease(path);

    
}
- (void)overDraw{
    CAShapeLayer *markLayer =  [CAShapeLayer layer];
    markLayer.frame = self.view.bounds;// layer的位置
    markLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;// layer的填充颜色，这里设置了透明度
    markLayer.fillRule = kCAFillRuleEvenOdd; //填充规则
    CAShapeLayer *subLayer =[CAShapeLayer layer];
    subLayer.frame = CGRectMake(0, 0, 100, 100);
    subLayer.position = CGPointMake(50+10, 200);
    [self.view.layer addSublayer:subLayer];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, markLayer.bounds);
    CGPathAddRect(path, nil, subLayer.frame);
    
    markLayer.path = path; //设置要渲染的Path
    [self.view.layer addSublayer:markLayer];
    CGPathRelease(path);

    
}
- (void)overDraw1{

    /*
    UIView *over = [[UIView alloc] initWithFrame:self.view.frame];
    over.backgroundColor =    [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:over];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:over.frame];
    UIBezierPath *subPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
    [path appendPath:subPath.bezierPathByReversingPath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    
    over.layer.mask = shapeLayer;
    */
    
    UIView *over = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
    over.backgroundColor =    [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:over];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:over.frame];
    UIBezierPath *subPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 110, 50, 50)];
    [path appendPath:subPath.bezierPathByReversingPath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    
    over.layer.mask = shapeLayer;

}
- (void)overDraw2{
    // 中间空心洞的区域
    CGRect cutRect = CGRectMake(CGRectGetMidX(self.view.frame) - 115,
                                CGRectGetMidY(self.view.frame) - 115 - 30,
                                230,
                                230);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    // 挖空心洞 显示区域
    UIBezierPath *cutRectPath = [UIBezierPath bezierPathWithRect:cutRect];
    //        将circlePath添加到path上
    [path appendPath:cutRectPath];
    path.usesEvenOddFillRule = YES;
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    //https://www.cnblogs.com/Code-life/p/6108008.html
    //通过设置填充规则为kCAFillRuleEvenOdd，绘制两个Rect的非交集
    /*
        射线与Path的交点数目为奇数时为Path内部，否则为外部。
        中间区域内的点到Path边界外的射线与Path的交点有两个(椭圆和矩形的边)，因此中间区域为外部非填充区域。而矩形与中间区域之间区域则为内部填充区域。
     */
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.opacity = 0.5;//透明度
    fillLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:fillLayer];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
