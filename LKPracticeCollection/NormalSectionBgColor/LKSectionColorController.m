//
//  LKSectionColorController.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/15.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKSectionColorController.h"
#import "LKCollectionCell.h"
#import "LKCollectionHeaderView.h"
#import "LKCollectionFlowLayout.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LKSectionColorController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LKSectionColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    

}

- (void)refreshAction:(UIRefreshControl *)sender{
    NSLog(@"刷新");
    [sender endRefreshing];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKCollectionFlowLayout *flowLayout = [[LKCollectionFlowLayout alloc] init];
        //最小行间距
        flowLayout.minimumLineSpacing = 10;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 20;
        //全部元素的宽高
        flowLayout.itemSize = CGSizeMake(50, 50);
        //元素的大致高度，使用自动布局的话可以使用这个方法
        flowLayout.estimatedItemSize = CGSizeMake(50, 50);
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
        
        [_collectionView registerClass:[LKCollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[LKCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        
        
    }
    return _collectionView;
}

#pragma mark ------UICollectionViewDataSource
//有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 4;
}

//每一组有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}

//返回collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sss" forIndexPath:indexPath];
    cell.bgColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    return cell;
}

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

//每个section头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(kScreenWidth, 50);
}

//每个section尾巴的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 50);
    
}


#pragma mark ---------UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"是否要高亮");
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"已经展示高亮");
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"高亮结束");
}



//是否要展示长按之后的菜单选项(长按显示copy/cut之类的可以自定义)
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[menuItem]];
    return YES;
}

//是否响应菜单操作,在这里可以筛选出来你想要的操作，不需要的操作可以不显示
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    NSString *operateName = NSStringFromSelector(action);
    NSLog(@"%@",operateName);
    //确定是菜单，不影响其他事件
    if ([sender isKindOfClass:[UIMenuController class]]) {
        
        if ([operateName isEqualToString:@"deleteAction:"]) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}
//执行点击之后的操作
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    
    if ([NSStringFromSelector(action) isEqualToString:@"deleteAction:"]) {
        
        //        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    }
    
}


@end
