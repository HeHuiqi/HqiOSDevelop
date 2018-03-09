//
//  ViewController.m
//  HqScoket
//
//  Created by macpro on 16/7/26.
//  Copyright © 2016年 macpro. All rights reserved.


//#define HOST @"127.0.0.1"
//#define PORT 1234

#import "HqScoketVC.h"
#import "HqSocketManager.h"
@interface HqScoketVC ()


@end

@implementation HqScoketVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"断开" style:UIBarButtonItemStylePlain target:self action:@selector(disConnect)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送数据" style:UIBarButtonItemStylePlain target:self action:@selector(sendData)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"连接" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, 80, 100, 80);
    [self.view addSubview:btn];
    [[HqSocketManager shareInstance] connect];

}
- (void)connect{
    [[HqSocketManager shareInstance] connect];
}
- (void)sendData{
    NSString *requestStr = @"<cps><excecute_result>0000</excecute_result><version>01</version><svrcode>100002</svrcode><card_number>6259624430003105</card_number><atr>409078891981509901196104000300350003408261041293610400000000000000000000000000000000</atr><sessionid/></cps>\r\n";
    
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [[HqSocketManager shareInstance] sendData:requestData block:^(id response) {
        NSLog(@"response = %@",response);
    }];
}
- (void)disConnect{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
