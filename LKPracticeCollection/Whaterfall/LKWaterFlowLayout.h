//
//  LKWaterFlowLayout.h
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/15.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LKWaterFlowLayout;
@protocol LKWaterFlowLayoutDelegate <NSObject>

//代理方法，获取每一个cell的高度，用于计算每一个cell的fram值
- (CGFloat)waterFlowLayout:(LKWaterFlowLayout *)layout heightForIndexPath:(NSIndexPath *)indexPath;

@end
@interface LKWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger colCount; //列数
@property (nonatomic, assign) CGFloat lineSpace; //行间距
@property (nonatomic, assign) CGFloat colSpace; //列间距

@property (nonatomic, weak) id<LKWaterFlowLayoutDelegate> waterDelegate;

@end


