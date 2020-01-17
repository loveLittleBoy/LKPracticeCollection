//
//  LKEditController.m
//  LKPracticeCollection
//
//  Created by 小屁孩 on 2018/12/18.
//  Copyright © 2018年 小屁孩. All rights reserved.
//

#import "LKEditController.h"
#import "LKEditFlowLayout.h"
#import "LKCollectionCell.h"
#import "LKCollectionHeaderView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LKEditController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) BOOL isEdit; //编辑模式

@end

@implementation LKEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    
    self.data = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSNumber *number = [NSNumber numberWithInt:i];
        [self.data addObject:number];
    }
    [self.collectionView reloadData];
    
    //添加导航按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"开启编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editModeAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    NSString *string = @"hh";
    [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    
    
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKEditFlowLayout *flowLayout = [[LKEditFlowLayout alloc] init];
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
        
        //添加长按手势
        UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_collectionView addGestureRecognizer:longPress];
        
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
    
    return 1;
}

//每一组有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count+1;
}

//返回collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sss" forIndexPath:indexPath];
    cell.bgColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    if (indexPath.item >= self.data.count) {
        cell.titleSSS = @"添加";
    }else{
        NSNumber *number = self.data[indexPath.item];
        cell.titleSSS = number.stringValue;
        cell.isEdittttt = self.isEdit;
    }
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

#pragma mark ----------移动相关的dataSource方法,只有iOS9之后才存在的代理
//是否可以移动到该位置
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //最后一个添加不能移动，其他的都能移动
    return indexPath.item < self.data.count;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}

//将要从一个位置移动到另一个位置，这个代理方法做数据处理，(数组之间的交换)
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSNumber *originNumber = [self.data objectAtIndex:sourceIndexPath.item];
    [self.data removeObjectAtIndex:sourceIndexPath.item];
    [self.data insertObject:originNumber atIndex:destinationIndexPath.item];
    
}
#pragma mark --------长按手势
- (void)longPressAction:(UIPanGestureRecognizer *)sender{
    if (!self.isEdit) {
        return;
    }
    //获取点击的点，然后取得响应的indexPath
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //根据手势进行处理
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{//点击触碰
            if (!indexPath) {
                return;
            }
            //这个方法是让cell开始移动
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{ //移动过程中
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded:{ //移动结束，手指松开了
            //不能移到最后的那个添加上边，
            if (indexPath.item >= self.data.count) {
                [self.collectionView cancelInteractiveMovement];
            }else{
                [self.collectionView endInteractiveMovement];
            }
            break;
        }
        default:
            //取消移动
            [self.collectionView cancelInteractiveMovement];
            break;
    }
    
    
    
    
}


#pragma mark ---------UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item >= self.data.count && !self.isEdit) {
        NSIndexPath *insertIndex = [self addNumberTool];
        [collectionView insertItemsAtIndexPaths:@[insertIndex]];
    }
    
}
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
    if (self.isEdit) {
        return NO;
    }
    if (indexPath.row >= self.data.count) {
        return NO;
    }
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
        //删除操作
        [self.data removeObjectAtIndex:indexPath.item];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    }
    
}


#pragma mark ------tool
- (void)editModeAction:(UIBarButtonItem *)sender{
    self.isEdit = [sender.title isEqualToString:@"开启编辑"];
    NSString *title = [sender.title isEqualToString:@"开启编辑"]?@"结束编辑":@"开启编辑";
    sender.title = title;
    
}

- (NSIndexPath *)addNumberTool{
    for (int i = 0; i < self.data.count; i++) {
        if (i != [self.data[i] intValue]) {
            BOOL haveSameContent = NO;
            //判断有没有相同的数，如果有的话，就不去添加这个数跳过这个数
            for (NSNumber *number in self.data) {
                if (number.intValue == i) {
                    haveSameContent = YES;
                    break;
                }
            }
            if (haveSameContent) {
                continue;
            }
            
            NSNumber *number = [NSNumber numberWithInt:i];
            [self.data insertObject:number atIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            return indexPath;
        }
        
    }
    
    NSNumber *lastNum = self.data.lastObject;
    NSNumber *newNumber = [NSNumber numberWithInt:(lastNum.intValue + 1)];
    [self.data addObject:newNumber];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.data.count-1) inSection:0];
    return indexPath;
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    self.collectionView.scrollEnabled = !isEdit;
    if (isEdit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LKEditBeginNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:LKEditEndNotification object:nil];
    }
    
    
}
@end
