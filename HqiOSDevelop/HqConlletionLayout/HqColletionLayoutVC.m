//
//  ViewController.m
//  HqCollectinoViewLayoutUse
//
//  Created by macpro on 2017/4/10.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqColletionLayoutVC.h"
#import "LineLayout.h"
#import "HqLineLayout.h"
#import "HqCollectionViewCell.h"
#define CellIndentifer @"cell"
#import "HqCcustomLayout.h"


@interface HqColletionLayoutVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
//@property (nonatomic,strong) UIScrollView *sportAnalysisView;


@end

@implementation HqColletionLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self tongji];
    [self myCollectionView];
}

- (void)myCollectionView{
//    LineLayout *layout = [[LineLayout alloc]init];
    
//        HqCcustomLayout *layout = [[HqCcustomLayout alloc]init];
        HqLineLayout *layout = [[HqLineLayout alloc]init];

    
    _collectionView = [ [UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:25/255.0 green:155/255.0 blue:187/255.0 alpha:1.0];
    _collectionView.dataSource = self;
    self.collectionView.decelerationRate = 0.0;
    
    
    [_collectionView registerClass:[HqCollectionViewCell class] forCellWithReuseIdentifier:CellIndentifer];
    [self.view addSubview:_collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HqCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifer forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2 ;
//    NSLog(@"centerx = %@",@(centerX));
//    NSLog(@"self.collectionView.contentOffset.x = %@",@(self.collectionView.contentOffset.x));

    
    UICollectionViewLayoutAttributes *attrs = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat dis = attrs.center.x - centerX;
//    NSLog(@"indexPath = %@",@(indexPath.row));
//
//    NSLog(@"attrs.center.x = %@",@(attrs.center.x));
//
//    NSLog(@"dis = %@",@(dis));
    
    CGPoint point = CGPointMake(dis+collectionView.contentOffset.x, 0);

    [collectionView setContentOffset:point animated:YES];
}
//减少自动滚动的距离
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    
//    
//    [UIView animateWithDuration:1 animations:^{
//        targetContentOffset->x = (targetContentOffset->x - scrollView.contentOffset.x) / 2+ scrollView.contentOffset.x;
//        targetContentOffset->y = (targetContentOffset->y - scrollView.contentOffset.y) / 2 + scrollView.contentOffset.y;
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
