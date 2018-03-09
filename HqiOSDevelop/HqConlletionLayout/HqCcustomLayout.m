//
//  HqCcustomLayout.m
//  HqCollectinoViewLayoutUse
//
//  Created by macpro on 2017/4/13.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqCcustomLayout.h"
#import "HqCollectionViewCell.h"
#define HqScreenWidth [UIScreen mainScreen].bounds.size.width

#define CellSpace 0.5

#define CellY 10

#define CellWidth 40
#define CellHeight 170

@interface HqCcustomLayout ()
@property (nonatomic,strong) NSMutableArray *layoutInfo;

@property (nonatomic,assign)UIEdgeInsets sectionInset;

@end


@implementation HqCcustomLayout

- (instancetype)init{
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
    CGFloat inset = [UIScreen mainScreen].bounds.size.width/2-CellWidth/2;
    
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.layoutInfo = [[NSMutableArray alloc]init];
  
    @autoreleasepool {
        
        NSInteger section = [self.collectionView numberOfSections];
        for (int sec = 0; sec<section; sec++) {
            
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:sec];

            for (NSInteger index  = 0; index <itemCount; index++) {
                
                NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:index inSection:0];
                UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                itemAttributes.frame = CGRectMake(index*(CellSpace+CellWidth)+self.sectionInset.left, CellY,CellWidth,CellHeight);
                
                [self.layoutInfo addObject:itemAttributes];
                
            }
        }
       
    }
    
}

////返回所有的属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.layoutInfo;
}
-(CGSize)collectionViewContentSize{
    NSInteger itemCount = self.layoutInfo.count;

    CGSize size = CGSizeMake((CellSpace+CellWidth)*itemCount+self.sectionInset.left+self.sectionInset.right, CellWidth);
    
    return size;
}

/**
 *  控制最后srollview的最后去哪里
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本Scrollview停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSLog(@"targetContentOffsetForProposedContentOffset");
    [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    //1.计算scrollview最后停留的范围
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2 ;
    //3.遍历所有的属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)){//取出最小值
            adjustOffsetX = attrs.center.x - centerX;
        }
        
    }
    NSLog(@"proposedContentOffset = %@",@(proposedContentOffset.x));

       NSLog(@"adjustOffsetX = %@",@(adjustOffsetX));
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
/**
 *  返回yes，只要显示的边界发生改变，就需要重新布局：(会自动调用layoutAttributesForElementsInRect方法，获得所有cell的布局属性)
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.layoutInfo[indexPath.row];
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
