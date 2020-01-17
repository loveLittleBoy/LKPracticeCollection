//
//  LKCollectionCell.h
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/7.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LKEditBeginNotification @"editBegin"
#define LKEditEndNotification @"editEnd"
NS_ASSUME_NONNULL_BEGIN

@interface LKCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, copy) NSString *titleSSS;
@property (nonatomic, assign) BOOL isEdittttt;
@end

NS_ASSUME_NONNULL_END
