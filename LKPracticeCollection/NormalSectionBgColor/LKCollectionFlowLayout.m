//
//  LKCollectionFlowLayout.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/14.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKCollectionFlowLayout.h"
#import "LKReusableView.h"
@interface LKCollectionFlowLayout()

@property (nonatomic, strong) NSMutableArray *itemAttributes; //item的布局

@end
@implementation LKCollectionFlowLayout
/**
 * 当collectionView视图位置有新改变(发生移动)时调用，其若返回YES则重新布局
 * 一旦返回YES就会重新调用下面的两个方法
 * 1.prepareLayout
 * 2.layoutAttributesForElementsInRect:
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//准备好布局时调用，此时collectionView的所有属性都已经确定了
- (void)prepareLayout{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray array];
    [self registerClass:[LKReusableView class] forDecorationViewOfKind:@"LKReusableView"];
    id<UICollectionViewDelegateFlowLayout> delegate = (id)self.collectionView.delegate;
    //总共有多少个组
    NSInteger sectionCount = self.collectionView.numberOfSections;
    //遍历每一组
    for (int section = 0; section < sectionCount; section++) {
        //获取每一组最后一个item的索引
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        if (lastIndex < 0) {
            continue;
        }
        //取出每一组第一个和最后一个item的布局，来计算每一组的高度，
        UICollectionViewLayoutAttributes *firstItemAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItemAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:lastIndex inSection:section]];
        //计算高度需要把间距加上去
        UIEdgeInsets sectionInset = self.sectionInset;
        //判断是否有额外改变间距的代理，有的话就更新间距
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        //获取除了section间距外的矩形大小
        //CGRectUnion获取包含两个frame的最小的矩形frame
        CGRect frame = CGRectUnion(firstItemAttr.frame, lastItemAttr.frame);
        //x,y,初始坐标需要包含inset，所以要减间距，
        frame.origin.x -= sectionInset.top;
        frame.origin.y -= sectionInset.left;
        /*
         宽高不能这么写，因为item不可能正好铺满屏幕，如果最后一行(或者一列)只有一个，那么宽度就是这一个的宽高，得到的并不是collectionView的宽高
        frame.size.height += (sectionInset.top + sectionInset.bottom);
        frame.size.width += (sectionInset.left + sectionInset.right);
         */
        //判断滚动方向固定宽高
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) { //水平滚动，高度是固定的，宽度不固定
            frame.size.height = self.collectionView.frame.size.height;
            frame.size.width += (sectionInset.left + sectionInset.right);
        }else{//竖直滚动，宽度是固定的，高度不固定
            frame.size.height += (sectionInset.top + sectionInset.bottom);
            frame.size.width = self.collectionView.frame.size.width;
        }
        
        
        //装饰视图(类似于背景视图，如果做一个书架，该View可以做书架) 对于装饰视图的UI更新，需要覆写自定义的UICollectionReusableView的applyLayoutAttributes方法进行覆写
        //
        UICollectionViewLayoutAttributes *bgAttrbutes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"LKReusableView" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        //放在最底层
        bgAttrbutes.zIndex = -1;
        bgAttrbutes.frame = frame;
        [self.itemAttributes addObject:bgAttrbutes];
        
    }
}


/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attrs = [NSMutableArray arrayWithArray:arr];
    //判断当前显示的rect和bgView是否有重叠，有的话就将该布局加入现有布局之中
    for (UICollectionViewLayoutAttributes *attributes in self.itemAttributes) {
        if (!CGRectIntersectsRect(rect, attributes.frame)) {
            continue;
        }
        [attrs addObject:attributes];
    }
    return attrs;
    
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
}

//返回indexPath对应Item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];

    return attr;
    
}

//返回collectionView的可显示范围
- (CGSize)collectionViewContentSize{
    
    return [super collectionViewContentSize];
}

@end
