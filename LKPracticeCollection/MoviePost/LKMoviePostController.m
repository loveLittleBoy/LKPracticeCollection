//
//  LKMoviePostController.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/17.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKMoviePostController.h"
#import "LKMoviePostFlowLayout.h"
#import "LKCollectionCell.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LKMoviePostController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentItem;

@end

@implementation LKMoviePostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentItem = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKMoviePostFlowLayout *flowLayout = [[LKMoviePostFlowLayout alloc] init];
        //最小行间距
        flowLayout.minimumLineSpacing = 10;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 20;
        //全部元素的宽高
        flowLayout.itemSize = CGSizeMake(160, 160);
        //元素的大致高度，使用自动布局的话可以使用这个方法
//        flowLayout.estimatedItemSize = CGSizeMake(50, 50);
        //元素滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //每一个section的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 180) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //公式 left =  collectionView的中点 - cell的中点 - header的宽度 - sectionInset.left
        //公式 right = collectionView的中点 - cell的中点 - footer的宽度 - sectionInset.right
        CGFloat offset = kScreenWidth * 0.5 - 160 * 0.5 - 20 - 20;
        _collectionView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
        //必须先注册cell
        [_collectionView registerClass:[LKCollectionCell class] forCellWithReuseIdentifier:@"sss"];
        
        
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
    
    return 100;
}

//返回collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sss" forIndexPath:indexPath];
    cell.bgColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.titleSSS = [NSNumber numberWithInteger:indexPath.item].stringValue;
    return cell;
}


//每个section头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(20, 20);
}

//每个section尾巴的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(20, 50);
    
}


#pragma mark ---------UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.currentItem == indexPath.item) {
        return;
    }
    self.currentItem = indexPath.item;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    collectionView.userInteractionEnabled = NO;
    
}

//动画结束调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"结束动画");
    self.collectionView.userInteractionEnabled = YES;
}

//动画减速的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint center = CGPointMake(scrollView.contentOffset.x + scrollView.frame.size.width * 0.5, scrollView.frame.size
                                 .height * 0.5);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
    self.currentItem = indexPath.item;
    NSLog(@"结束减速-----%ld",(long)indexPath.item);
    self.collectionView.userInteractionEnabled = YES;
    
}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"是否要高亮");
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"已经展示高亮");
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"高亮结束");
//}



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
