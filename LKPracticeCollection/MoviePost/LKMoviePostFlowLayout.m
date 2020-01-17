
//
//  LKMoviePostFlowLayout.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/17.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKMoviePostFlowLayout.h"

@implementation LKMoviePostFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //父类布局好样式
    //这样写是为了预防警告
    NSArray *arr = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    //计算出collectionView的中心位置   公式：cell中心点 - collectionView中心点  = offset偏移量； 由此可以推算出cell距离collectionView中心时的坐标，就可以算出来一个比例了。
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        //cell的中心距离collectionView中心的距离
        CGFloat delta = ABS(attribute.center.x - centerX);
        
        //设置缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
        scale = scale<0.8?0.8:scale;
        //设置cell滚动时候的缩放比例
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return arr;
    
}


//这个方法的返回值，决定了collectionView停止滚动的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    //获得super已经计算好的布局属性
    NSArray *arr = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    //计算collectionView最中心点x值，公式：cell中心点 - collectionView中心点  = offset偏移量； 由此可以推算出cell距离collectionView中心时的坐标。
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    //找到最小的偏移差(距离中心点最近的cell)
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in arr) {
        if (ABS(minDelta) > ABS(attr.center.x - centerX)) {
            minDelta = attr.center.x - centerX;
        }
    }
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end
