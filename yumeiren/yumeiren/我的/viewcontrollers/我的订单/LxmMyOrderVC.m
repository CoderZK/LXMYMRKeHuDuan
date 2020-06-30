//
//  LxmMyOrderVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//
#import "LxmOrderChaXunVC.h"
#import "LxmMyOrderVC.h"
#import "LxmSubOrderChaXunVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"

@interface LxmMyOrderVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@end

@implementation LxmMyOrderVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        _tabBar.backgroundColor = UIColor.whiteColor;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
        _tabBar.layout.adjustContentCellsCenter = YES;
        _tabBar.layout.progressColor = MainColor;
        _tabBar.layout.textColorProgressEnable = NO;
        _tabBar.layout.selectedTextColor = UIColor.blackColor;
        _tabBar.layout.normalTextColor = CharacterGrayColor;
        _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.progressVerEdging = 10;
        _tabBar.layout.progressHeight = 3;
        _tabBar.layout.progressWidth = 35;
        _tabBar.layout.cellWidth = floor(ScreenW/5.0);
        _tabBar.layout.cellSpacing = 0;
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
    self.navigationItem.title = @"我的订单";
    self.titleArray = @[@"全部",@"待发货",@"待收货",@"待自提",@"已收货",@"已自提",@"已取消"];
    [self initSubviews];
    switch (self.selectIndex) {
        case 0: {
            [_pagerController scrollToControllerAtIndex:0 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:0 animate:YES];
        }
            break;
        case 100: {
            [_pagerController scrollToControllerAtIndex:1 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:1 animate:YES];
        }
            break;
        case 101: {
            [_pagerController scrollToControllerAtIndex:2 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:2 animate:YES];
        }
            break;
        case 102: {
            [_pagerController scrollToControllerAtIndex:3 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:3 animate:YES];
        }
            
            break;
        case 103: {
            [_pagerController scrollToControllerAtIndex:4 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:4 animate:YES];
        }
            
            break;
        case 105: {
            [_pagerController scrollToControllerAtIndex:5 animate:YES];
            [_tabBar scrollToItemFromIndex:0 toIndex:5 animate:YES];
        }
            
            break;
        default:
            break;
    }
    
}
/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    
    [self.view addSubview:self.lineView];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubOrderChaXunVC *vc = [[LxmSubOrderChaXunVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSubOrderChaXunVC_type_userCenter];
    if (index == 0) {
        vc.status = @0;
    } else if (index == 1){
        vc.status = @2;
    } else if (index == 2) {
        vc.status = @3;
    } else if (index == 3) {
        vc.status = @7;
    } else if (index == 4) {
        vc.status = @4;
    } else if (index == 5) {
        vc.status = @8;
    } else if (index == 6) {
        vc.status = @5;
    }
    
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.titleArray[index];
    return [pagerTabBar cellWidthForTitle:title];
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
