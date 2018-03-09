//
//  HqRefreshVC.m
//  HqRefresh
//
//  Created by macpro on 2018/3/9.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "HqRefreshVC.h"
#import "HqRefreshHeaderView.h"

@interface HqRefreshVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HqRefreshHeaderView *headerView;
@end

@implementation HqRefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    view.backgroundColor = [UIColor blueColor];
    _tableView.tableHeaderView = view;
    [_tableView addSubview:self.headerView];
    
    //模拟请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        [self.headerView refreshComplete:^{
            NSLog(@"刷新完成");
        }];
        
    });
    
    
    
}
- (HqRefreshHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HqRefreshHeaderView alloc] initWithScrollView:_tableView];
    }
    return _headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentfier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
