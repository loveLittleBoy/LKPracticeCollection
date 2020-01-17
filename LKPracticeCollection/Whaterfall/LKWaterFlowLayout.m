//
//  LKWaterFlowLayout.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/15.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKWaterFlowLayout.h"
@interface LKWaterFlowLayout()
//item的宽度
@property (nonatomic, assign) CGFloat itemWidth;
//每列的总高度
@property (nonatomic, strong) NSMutableArray<NSNumber *> *colsHeight;

@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation LKWaterFlowLayout

//准备布局
- (void)prepareLayout{
    [super prepareLayout];
    NSLog(@"准备布局");
    self.itemWidth = (self.collectionView.frame.size.width - self.colSpace * (self.colCount - 1) - self.sectionInset.left - self.sectionInset.right)/self.colCount;
    /*
    //每次布局都要重新清空高度，不然高度会按照之前的一直累计
    [self.colsHeight removeAllObjects];
    self.arr = [NSMutableArray array];
    */
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.arr addObject:attr];
    }
    
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *itemLayoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //默认最小的是第一列,（0）
    NSNumber *shortest = self.colsHeight[0];
    NSInteger shortLine = 0;
    //获取最小的一列
    for (int i = 0; i < self.colsHeight.count; i++) {
        if (shortest.floatValue > self.colsHeight[i].floatValue) {
            shortLine = i;
            shortest = self.colsHeight[i];
        }
    }
    //计算下一个item的坐标
    CGFloat x = self.sectionInset.left + self.colSpace * shortLine + self.itemWidth * shortLine;
    CGFloat y = shortest.floatValue + self.lineSpace;
    
    NSAssert(self.waterDelegate && [self.waterDelegate respondsToSelector:@selector(waterFlowLayout:heightForIndexPath:)], @"必须实现waterFlowlayout的代理方法");
    CGFloat itemHeight = [self.waterDelegate waterFlowLayout:self heightForIndexPath:indexPath];
    //定位这个item
    itemLayoutAttr.frame = CGRectMake(x, y, self.itemWidth, itemHeight);
    //更新列的高度
    shortest = [NSNumber numberWithFloat:(y + itemHeight)];
    [self.colsHeight replaceObjectAtIndex:shortLine withObject:shortest];
    
    return itemLayoutAttr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.arr;

}


- (CGSize)collectionViewContentSize{
    //下面的方法是找出高度最长的那一列，然后collectionView的contentsize的高度就是最长的那一列的高度
    NSNumber *height = self.colsHeight[0];
    for (int i = 0; i < self.colsHeight.count; i++) {
        height = [self.colsHeight[i] floatValue] > height.floatValue?self.colsHeight[i]:height;
    }
    return CGSizeMake(self.collectionView.frame.size.width, height.floatValue + self.sectionInset.bottom);
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//
//    return YES;
//}

#pragma mark -----懒加载
- (NSMutableArray<NSNumber *> *)colsHeight{
    if (!_colsHeight) {
        _colsHeight = [NSMutableArray arrayWithCapacity:self.colCount];
    }
    if (_colsHeight.count == 0) {
        for (int i = 0; i < self.colCount; i++) {
            [_colsHeight addObject:@(0)];
        }
    }
    return _colsHeight;
}
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}






/*
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self.waterDelegate waterFlowLayout:self heightForIndexPath:indexPath];
    
    return [super layoutAttributesForItemAtIndexPath:indexPath];
    
}
 */


@end
