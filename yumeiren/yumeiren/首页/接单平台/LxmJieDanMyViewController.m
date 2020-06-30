//
//  LxmJieDanMyViewController.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanMyViewController.h"
#import <TYPagerController.h>
#import <TYTabPagerBar.h>
#import "LxmJiedanMyPublishVC.h"
#import "LxmJiedanMyAcceptVC.h"
@interface LxmJieDanMyViewController () <TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组
@end

@implementation LxmJieDanMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"我发布的", @"我接受的"];
    [self.view addSubview:self.tabBar];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.view addSubview:self.pagerController.view];
    [self addChildViewController:self.pagerController];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(0.5);
        make.height.equalTo(@50);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.top.equalTo(self.tabBar.mas_bottom);
    }];
    [self.tabBar reloadData];
    
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:17];
        layout.adjustContentCellsCenter = YES; // 居中
        layout.normalTextColor = CharacterDarkColor;
        layout.selectedTextColor = UIColor.blackColor;
        layout.progressHeight = 2;
        layout.progressRadius = 1;
        layout.progressWidth = 40;
        layout.progressColor = MainColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.cellWidth = ScreenW*0.5;
        layout.barStyle = TYPagerBarStyleProgressElasticView;
        layout.animateDuration = 0.25;
        layout.progressVerEdging = 8;
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.layout = layout;
//        _tabBar.autoScrollItemToCenter = YES;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    }
    return _tabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        TYPagerController *pagerController = [[TYPagerController alloc]init];
        pagerController.layout.prefetchItemCount = 1;
        //pagerController.layout.autoMemoryCache = NO;
        // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
        pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        pagerController.dataSource = self;
        pagerController.delegate = self;
        _pagerController = pagerController;
    }
    return _pagerController;
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        LxmJiedanMyPublishVC *vc = [[LxmJiedanMyPublishVC alloc]init];
        return vc;
    } else {
        LxmJiedanMyAcceptVC *vc = [[LxmJiedanMyAcceptVC alloc]init];
        return vc;
    }
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return 100;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArray[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

@end
