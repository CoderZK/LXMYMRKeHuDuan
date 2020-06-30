//
//  LxmInfoClassVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/2/21.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmInfoClassVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSearchView.h"
#import "LxmSubInfoClassVC.h"
#import "LxmSearchVC.h"

@interface LxmInfoClassVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIImageView *topBgView;//顶部分类视图

@property (nonatomic, strong) UIButton *leftButton;//左侧按钮

@property (nonatomic, strong) LxmTitleView *titleView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray <NSString *>*titleArr;

@property (nonatomic, assign) NSInteger type_info;

@end

@implementation LxmInfoClassVC
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"ico_fanhui"] forState:UIControlStateNormal];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)topBgView {
    if (!_topBgView) {
        _topBgView = [UIImageView new];
        _topBgView.backgroundColor = PinkColor;
//        _topBgView.image = [UIImage imageNamed:@"banner"];
        _topBgView.contentMode = UIViewContentModeScaleAspectFill;
        _topBgView.layer.masksToBounds = YES;
    }
    return _topBgView;
}

- (LxmTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[LxmTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 30)];
        _titleView.searchView.bgButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    }
    return _titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:17];
        layout.selectedTextFont = [UIFont boldSystemFontOfSize:20];
        layout.normalTextColor = CharacterGrayColor;
        layout.selectedTextColor = UIColor.blackColor;
        layout.progressHeight = 4;
        layout.progressRadius = 2;
        layout.progressColor = MainColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.adjustContentCellsCenter = YES;
        layout.barStyle = TYPagerBarStyleProgressView;
        layout.animateDuration = 0.25;
        layout.progressVerEdging = 8;
        layout.cellWidth = floor(ScreenW/4.0);
        layout.progressWidth = 35;
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.layout = layout;
        _tabBar.autoScrollItemToCenter = YES;
        _tabBar.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    [self.view addSubview:self.leftButton];
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView);
        make.leading.equalTo(self.view).offset(10);
        make.width.height.equalTo(@24);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBgView).offset(-10);
        make.leading.equalTo(self.view).offset(45);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@30);
    }];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.topBgView.mas_bottom);
           make.leading.trailing.equalTo(self.view);
           make.height.equalTo(@50);
       }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.tabBar.mas_bottom);
       make.leading.trailing.bottom.equalTo(self.view);
    }];
    self.titleArr = @[@"全部",@"视频教程",@"音频教程",@"图文教程"];
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    //导航栏搜索
    WeakObj(self);
    self.titleView.searchBlock = ^{
       [selfWeak pageToSearch];
    };
    
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArr.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArr.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubInfoClassVC *vc = [[LxmSubInfoClassVC alloc] init];
    if (index == 1) {
        vc.info_type = 3;
    } else if (index == 2) {
        vc.info_type = 2;
    } else if (index == 3) {
        vc.info_type = 1;
    } else {
        vc.info_type = 100;
        self.type_info = 100;
    }
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return [pagerTabBar cellWidthForTitle:self.titleArr[index]];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    if (index == 1) {
        self.type_info = 3;
    } else if (index == 2) {
        self.type_info = 2;
    } else if (index == 3) {
        self.type_info = 1;
    } else {
        self.type_info = 100;
    }
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArr[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    if (toIndex == 1) {
        self.type_info = 3;
    } else if (toIndex == 2) {
        self.type_info = 2;
    } else if (toIndex == 3) {
        self.type_info = 1;
    } else {
        self.type_info = 100;
    }
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if (toIndex == 1) {
        self.type_info = 3;
    } else if (toIndex == 2) {
        self.type_info = 2;
    } else if (toIndex == 3) {
        self.type_info = 1;
    } else {
        self.type_info = 100;
    }
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

/**
 跳转搜索
 */
- (void)pageToSearch {
    LxmSearchVC *vc = [[LxmSearchVC alloc] init];
    vc.isClass = YES;
    vc.info_type = self.type_info;
    [self.navigationController pushViewController:vc animated:NO];
}

@end
