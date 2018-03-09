//
//  HqGestureLockVC.m
//  HqiOSDevelop
//
//  Created by macpro on 2018/3/9.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqGestureLockVC.h"
#import "GestureLockView.h"
@interface HqGestureLockVC ()<GestureLockDelegate>
@property (strong, nonatomic) UILabel *label;

@end

@implementation HqGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 80, 100, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"请设置密码";
    _label.textColor = [UIColor greenColor];
    [self.view addSubview:_label];
    
    GestureLockView *gesView = [[GestureLockView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-self.view.frame.size.width-100, self.view.frame.size.width, self.view.frame.size.width)];
    gesView.delegate = self;
    //    [gesView setRigthResult:@"12589"];
    [self.view addSubview:gesView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetLabel
{
    _label.text = @"请输入密码";
}

#pragma mark - GestureLockViewDelegate

//原密码为nil调用
- (void)GestureLockSetResult:(NSString *)result gestureView:(GestureLockView *)gestureView
{
    NSLog(@"输入密码：%@",result);
    [gestureView setRigthResult:result];
    _label.text = @"请输入密码";
}

//密码核对成功调用
- (void)GestureLockPasswordRight:(GestureLockView *)gestureView
{
    NSLog(@"密码正确");
    _label.text = @"密码正确";
}

//密码核对失败调用
- (void)GestureLockPasswordWrong:(GestureLockView *)gestureView
{
    NSLog(@"密码错误");
    _label.text = @"密码错误";
    [self performSelector:@selector(resetLabel) withObject:nil afterDelay:1];
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
