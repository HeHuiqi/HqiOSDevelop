//
//  LineLayout.m
//  自定义UICollectionView的布局
//
//  Created by Tengfei on 15/12/27.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "LineLayout.h"
#import "HqCollectionViewCell.h"
static const CGFloat ItemWidth = 100;
static const CGFloat ItemHeight = 300;
static const CGFloat ItemSpace = 1.0;

@implementation LineLayout

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

/**
 *  一些初始化工作，最好在这里实现
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化
    self.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ItemSpace;
    CGFloat inset = [UIScreen mainScreen].bounds.size.width/2-ItemWidth/2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

///**
// *  控制最后srollview的最后去哪里
// *  用来设置collectionView停止滚动那一刻的位置
// *
// *  @param proposedContentOffset 原本Scrollview停止滚动那一刻的位置
// *  @param velocity              滚动速度
// */
//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    //1.计算scrollview最后停留的范围
//    CGRect lastRect ;
//    lastRect.origin = proposedContentOffset;
//    lastRect.size = self.collectionView.frame.size;
//    
//    //2.取出这个范围内的所有属性
//    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
//    
//    //计算屏幕最中间的x
//    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2 ;
//    
//    //3.遍历所有的属性
//    CGFloat adjustOffsetX = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        if(ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)){//取出最小值
//            adjustOffsetX = attrs.center.x - centerX;
//        }
//    }
//    
//    NSLog(@"adjustOffsetX = =%f",adjustOffsetX);
//    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
//}
///**
// *  返回yes，只要显示的边界发生改变，就需要重新布局：(会自动调用layoutAttributesForElementsInRect方法，获得所有cell的布局属性)
// */
//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
//
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    //0:计算可见的矩形框
//    CGRect visiableRect;
//    visiableRect.size = self.collectionView.frame.size;
//    visiableRect.origin = self.collectionView.contentOffset;
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    //计算屏幕最中间的x
//    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2 ;
//    
//    //2.遍历所有的布局属性
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        //不是可见范围的 就返回，不再屏幕就直接跳过
//        if (CGRectIntersectsRect(visiableRect, attrs.frame)){
//            //每一个item的中心x值
//            CGFloat itemCenterx = attrs.center.x;
//            
//            CGFloat dis = itemCenterx - centerX;
//            dis = dis > 0  ? dis:-dis;
//            CGFloat alpha = 1 - (dis / self.collectionView.frame.size.width);            NSLog(@"alpha:%f",alpha);
//            NSLog(@"attrs.indexPath:%@",@(attrs.indexPath.row));
//            if (dis<=ItemWidth) {
//                attrs.alpha = alpha;
//
//            }else{
//                alpha = alpha<0.92 ? 0.5: 1.0;
//                attrs.alpha = alpha;
//            }
//        }
//    }
//    return array;
//}

@end
