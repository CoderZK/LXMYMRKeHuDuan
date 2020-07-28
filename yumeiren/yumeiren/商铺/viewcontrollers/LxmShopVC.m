//
//  LxmShopVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubShopVC.h"
#import "LxmSearchView.h"
#import "LxmSearchVC.h"

#import "LxmTabBarVC.h"
#import "LxmPanButton.h"
#import "LxmShopCarVC.h"

#import "LxmShengjiGouWuVC.h"
#import "LxmMyOrderVC.h"
#import "LxmSubCaiGouAndXiaoShouVC.h"
#import "LxmOrderChaXunVC.h"

@interface LxmShopVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIImageView *topBgView;//顶部分类视图

@property (nonatomic, strong) UIButton *leftButton;//左侧按钮

@property (nonatomic, strong) LxmTitleView *titleView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) LxmSuCaiContentTypeRootModel *model;


@end

@implementation LxmShopVC

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
        _topBgView.image = [UIImage imageNamed:@"banner"];
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:17];
        layout.selectedTextFont = [UIFont boldSystemFontOfSize:20];
        layout.normalTextColor = CharacterLightGrayColor;
        layout.selectedTextColor = UIColor.blackColor;
        layout.progressHeight = 4;
        layout.progressRadius = 2;
        layout.progressColor = MainColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.barStyle = TYPagerBarStyleProgressView;
        layout.animateDuration = 0.25;
        layout.progressVerEdging = 8;
        layout.cellWidth = floor(ScreenW/5.0);
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
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    if (self.isDeep) {
        [self.view addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.leading.equalTo(self.view).offset(10);
            make.width.height.equalTo(@24);
        }];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44);
            make.leading.equalTo(self.view).offset(45);
            make.width.equalTo(@(ScreenW - 60));
            make.height.equalTo(@30);
        }];
        [self addPublishBtn];
    } else {
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(ScreenW - 30));
            make.height.equalTo(@30);
        }];
    }
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    //导航栏搜索
    WeakObj(self);
    self.titleView.searchBlock = ^{
        [selfWeak pageToSearch];
    };
    
    [self loadListData];
}


- (void)addPublishBtn {
    LxmPanButton *addBtn = [LxmPanButton new];
    addBtn.iconImgView.image = [UIImage imageNamed:@"goujinshangp"];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-130);
        make.width.height.equalTo(@50);
    }];
    
    if (self.isHaoCai) {
        WeakObj(self);
        LxmPanButton *orderBtn = [LxmPanButton new];
           orderBtn.iconImgView.image = [UIImage imageNamed:@"kk167"];
        [selfWeak.view addSubview:orderBtn];
           [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               make.trailing.equalTo(self.view).offset(-20);
               make.bottom.equalTo(self.view).offset(-64);
               make.width.height.equalTo(@50);
           }];
        
        orderBtn.panBlock = ^{
            
//            LxmSubCaiGouAndXiaoShouVC *vc = [[LxmSubCaiGouAndXiaoShouVC alloc] init];
//            vc.type = @(3);
//            vc.status = @(0);
//            [selfWeak.navigationController pushViewController:vc animated:YES];
            
         
            LxmOrderChaXunVC *vc = [[LxmOrderChaXunVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isHaoCai = self.isHaoCai;
            [selfWeak.navigationController pushViewController:vc animated:YES];
            
//            LxmMyOrderVC *vc = [[LxmMyOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
//            vc.selectIndex = 0;
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.isHaoCai = self.isHaoCai;
//            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
        
    }
    
    
    WeakObj(self);
    addBtn.panBlock = ^{
        
        if (selfWeak.isHaoCai) {
                LxmShopCarVC *vc = [[LxmShopCarVC alloc] init];
                vc.isDeep = self.isDeep;
                vc.isHaoCai = self.isHaoCai;
                [selfWeak.navigationController pushViewController:vc animated:YES];
        }else {
            if (selfWeak.isGotoGouwuChe) {
                if (self.roleType.isValid) {
                    LxmShengjiGouWuVC *vc = [[LxmShengjiGouWuVC alloc] init];
                    vc.shengjiModel = self.shengjiModel;
                    vc.roleType = self.roleType;
                    vc.isDeep = YES;
                    [selfWeak.navigationController pushViewController:vc animated:YES];
                } else {
                    LxmShopCarVC *vc = [[LxmShopCarVC alloc] init];
                    vc.isDeep = self.isDeep;
                    [selfWeak.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
        }
        
        
    };
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.model.result.list.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.model.result.list.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubShopVC *vc = [[LxmSubShopVC alloc] init];
    vc.shengjiModel = self.shengjiModel;
    vc.roleType = self.roleType;
    vc.type_id = self.model.result.list[index].id;
    vc.isAddLocolGoods = self.isAddLocolGoods;
    vc.isHaoCai = self.isHaoCai;
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return [pagerTabBar cellWidthForTitle:self.model.result.list[index].title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
    [self.topBgView sd_setImageWithURL:[NSURL URLWithString:self.model.result.list[index].mainPic] placeholderImage:[UIImage imageNamed:@"tupian"]];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.model.result.list[index].title;
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    [self.topBgView sd_setImageWithURL:[NSURL URLWithString:self.model.result.list[toIndex].mainPic] placeholderImage:[UIImage imageNamed:@"tupian"]];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    [self.topBgView sd_setImageWithURL:[NSURL URLWithString:self.model.result.list[toIndex].mainPic] placeholderImage:[UIImage imageNamed:@"tupian"]];
}

/**
 获取数据
 */
- (void)loadListData {
    [SVProgressHUD show];
    WeakObj(self);
    NSMutableDictionary * dict = @{}.mutableCopy;
    if (self.isHaoCai) {
        dict[@"noVip"] = @"2";
    }else {
        dict[@"noVip"] = @"1";
    }
    [LxmNetworking networkingPOST:good_first_type_list parameters:dict returnClass:LxmSuCaiContentTypeRootModel.class success:^(NSURLSessionDataTask *task, LxmSuCaiContentTypeRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.model = responseObject;
            if (selfWeak.model.result.list.count > 0) {
                [selfWeak.topBgView sd_setImageWithURL:[NSURL URLWithString:selfWeak.model.result.list.firstObject.mainPic] placeholderImage:[UIImage imageNamed:@"tupian"]];
            }
            [selfWeak.tabBar reloadData];
            [selfWeak.pagerController reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 跳转搜索
 */
- (void)pageToSearch {
    LxmSearchVC *vc = [[LxmSearchVC alloc] init];
    vc.shengjiModel = self.shengjiModel;
    vc.roleType = self.roleType;
    vc.isDeep = self.isDeep;
    vc.isAddLocolGoods = self.isAddLocolGoods;
    vc.isHaoCai = self.isHaoCai;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

@end
