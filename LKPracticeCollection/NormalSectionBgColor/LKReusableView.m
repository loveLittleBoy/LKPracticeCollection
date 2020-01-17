//
//  LKReusableView.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/14.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKReusableView.h"

@implementation LKReusableView

//当有布局更新的时候会调用该方法，所以一些UI的更新可以在这里面去更新
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    [super applyLayoutAttributes:layoutAttributes];
    if (layoutAttributes.indexPath.section == 0) {
        self.backgroundColor = [UIColor redColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
}

@end
