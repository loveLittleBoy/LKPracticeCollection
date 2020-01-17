//
//  LKCollectionHeaderView.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/13.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKCollectionHeaderView.h"

@implementation LKCollectionHeaderView

//准备重用的时候才会调用
- (void)prepareForReuse{
    [super prepareForReuse];

}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self initUI];
//    }
//    return self;
//}
//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        [self initUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    self.label = [[UILabel alloc] init];
    self.label.frame = self.bounds;
    self.label.backgroundColor = [UIColor yellowColor];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.label];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self.reuseIdentifier isEqualToString:@"header"]) {
        self.label.backgroundColor = [UIColor yellowColor];
        self.label.text = @"这是一个大头";
    }else{
        self.label.backgroundColor = [UIColor cyanColor];
        self.label.text = @"这是一个小尾巴";
    }
}

@end
