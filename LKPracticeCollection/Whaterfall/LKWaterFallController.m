//
//  LKWaterFallController.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/15.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKWaterFallController.h"
#import "LKCollectionCell.h"
#import "LKWaterFlowLayout.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LKWaterFallController ()<UICollectionViewDelegate,UICollectionViewDataSource,LKWaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *heights;
@end

@implementation LKWaterFallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    
    self.heights = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        int height = arc4random()%50+80;
        [self.heights addObject:[NSNumber numberWithInt:height]];
    }
    
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKWaterFlowLayout *flowLayout = [[LKWaterFlowLayout alloc] init];
        //最小行间距
        flowLayout.lineSpace = 10;
        //最小列间距
        flowLayout.colSpace = 10;
        flowLayout.waterDelegate = self;
        flowLayout.colCount = 3;
        //元素滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //每一个section的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //必须先注册cell
        [_collectionView registerClass:[LKCollectionCell class] forCellWithReuseIdentifier:@"sss"];
        
//        [_collectionView registerClass:[LKCollectionHeaderView class]
//            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//        [_collectionView registerClass:[LKCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        
        
    }
    return _collectionView;
}

#pragma mark ------UICollectionViewDataSource
//有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//每一组有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.heights.count;
}

//返回collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sss" forIndexPath:indexPath];
    cell.bgColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.titleSSS = [self.heights[indexPath.item] stringValue];
    return cell;
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",kind);
    if (kind == UICollectionElementKindSectionHeader) { //头
        LKCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }else if (kind == UICollectionElementKindSectionFooter){ //尾
        LKCollectionHeaderView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
        
    }
    
    return nil;
}
*/
/*
//每个section头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(kScreenWidth, 50);
}

//每个section尾巴的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 50);
    
}
 */
- (CGFloat)waterFlowLayout:(LKWaterFlowLayout *)layout heightForIndexPath:(NSIndexPath *)indexPath{
    
    return [self.heights[indexPath.item] floatValue];
}

@end
