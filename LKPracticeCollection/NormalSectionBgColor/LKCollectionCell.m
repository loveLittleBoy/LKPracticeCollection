//
//  LKCollectionCell.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/7.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKCollectionCell.h"

@implementation LKCollectionCell{
    UILabel *newView;
    NSDate *date;
    
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimationNoti) name:LKEditBeginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimationNoti) name:LKEditEndNotification object:nil];
    }
    return self;
}

- (void)initUI{
    newView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    newView.text = @"骚";
    newView.textAlignment = NSTextAlignmentCenter;
    newView.textColor = [UIColor whiteColor];
    newView.font = [UIFont systemFontOfSize:12];
    [self addSubview:newView];
    
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    newView.backgroundColor = bgColor;
    
}

- (void)setIsEdittttt:(BOOL)isEdittttt{
    if (isEdittttt) {
        [self startAnimationNoti];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    newView.frame = self.bounds;
}

- (void)setTitleSSS:(NSString *)titleSSS{
    _titleSSS = titleSSS;
    newView.text = titleSSS;
    
}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (self.highlighted) {
        newView.alpha = 0.5;
        date = [NSDate date];
    }else{
        if (fabs(date.timeIntervalSinceNow) < 0.3) {
            [UIView animateWithDuration:.3 animations:^{
                self->newView.alpha = 1;
            }];
        }else{
            newView.alpha = 1;
        }
        
    }
    
}

//删除
- (void)deleteAction:(id)sender{
    UICollectionView *collectionView = (UICollectionView *)self.superview;
    if ([collectionView isKindOfClass:[UICollectionView class]]) {
        id<UICollectionViewDelegate> collectionDele = collectionView.delegate;
        if ([collectionDele respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collectionDele collectionView:collectionView performAction:@selector(deleteAction:) forItemAtIndexPath:indexPath withSender:sender];
        }
    }
}

#pragma mark --------动画效果
- (void)startAnimationNoti{
    if ([self.titleSSS isEqualToString:@"添加"]) {
        return;
    }
    _isEdittttt = YES;
    [self.layer removeAnimationForKey:@"eidtA"];
    //创建动画
    CAKeyframeAnimation *keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-5 / 180.0 * M_PI),@(5 /180.0 * M_PI),@(-5/ 180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.2;
    keyAnimaion.repeatCount = MAXFLOAT;
    [self.layer addAnimation:keyAnimaion forKey:@"eidtA"];
}

- (void)stopAnimationNoti{
    _isEdittttt = NO;
    [self.layer removeAllAnimations];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
