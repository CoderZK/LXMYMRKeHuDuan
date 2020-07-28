//
//  LxmJiFenShopFatherVC.m
//  yumeiren
//
//  Created by zk on 2020/7/27.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenShopFatherVC.h"
#import "LxmJiFenShopSubVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
@interface LxmJiFenShopFatherVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;
@property(nonatomic,strong)NSArray *titelArr;

@end

@implementation LxmJiFenShopFatherVC


- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:16];
        layout.selectedTextFont = [UIFont boldSystemFontOfSize:18];
        layout.normalTextColor = CharacterDarkColor;
        layout.selectedTextColor = UIColor.blackColor;
        layout.progressHeight = 4;
        layout.progressRadius = 2;
        layout.progressColor = MainColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.barStyle = TYPagerBarStyleProgressView;
//        layout.animateDuration = 0.25;
//        layout.progressVerEdging = 8;
        
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.layout = layout;
        _tabBar.autoScrollItemToCenter = YES;
        _tabBar.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tabBar.layout.cellWidth = (ScreenW - 45)/2;
        _tabBar.layout.progressWidth = 40;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titelArr = @[@"积分商品",@"购物车"];
    self.navigationItem.title = @"积分兑换";
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    
    
    
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    
    
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titelArr.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titelArr.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmJiFenShopSubVC *vc = [[LxmJiFenShopSubVC alloc] init];
    vc.type = index;
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    
    return (ScreenW - 45) / 2;
    
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
   
    cell.titleLabel.text = self.titelArr[index];
    
    
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}


@end
