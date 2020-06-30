//
//  LxmHomeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHomeVC.h"
#import "LxmHomeView.h"
#import "SDCycleScrollView.h"
#import "LxmAboutUSVC.h"
#import "LxmSuCaiTabBarVC.h"
#import "LxmJieDanPlatTabbarController.h"
#import "LxmTouSuCenterVC.h"
#import "LxmBaoZhengJinBuZuAlertView.h"
#import "LxmShengJiVC.h"
#import "LxmTabBarVC.h"
#import "LxmNotifyMessageVC.h"
#import "LxmWebViewController.h"
#import "LxmGoodsDetailVC.h"
#import "LxmKeTangNoAlertView.h"
#import "LxmRenZhengProtocolVC.h"
#import "LxmReadProtocolVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmInfoClassVC.h"

@interface LxmHomeVC ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *rightButton;//导航栏右侧按钮

@property (nonatomic, strong) SDCycleScrollView *headerView;

@property (nonatomic, strong) LxmHomeMapModel *homeModel;

@end

@implementation LxmHomeVC

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40,40)];
        _rightButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 0);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(xiaoxiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (SDCycleScrollView *)headerView {
    if (!_headerView) {
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW * 2/3) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        _headerView.localizationImageNamesGroup = @[@"banner",@"banner",@"banner"];
        _headerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _headerView.currentPageDotImage = [UIImage imageNamed:@"banner_1"];
        _headerView.pageDotImage = [UIImage imageNamed:@"banner_2"];
    }
    return _headerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:UIColor.whiteColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    WeakObj(self);
    [self loadMyUserInfoWithOkBlock:^{
        StrongObj(self);
        [self.tableView reloadData];
        if ([LxmTool ShareTool].userModel.depositMoney.integerValue > 0) {
            LxmBaoZhengJinBuZuAlertView *alertView = [[LxmBaoZhengJinBuZuAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            [alertView show];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = CharacterDarkColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:CharacterDarkColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = CharacterDarkColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self loadIndexData];
    [self.view addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StateBarH + 4);
        make.trailing.equalTo(self.view).offset(-15);
        make.width.height.equalTo(@40);
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        [self loadIndexData];
    }];
}

/**
 初始化table 头视图
 */
- (void)initTableView {
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeModel.goodTypes.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmHomeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeButtonCell"];
        if (!cell) {
            cell = [[LxmHomeButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeButtonCell"];
        }
        WeakObj(self);
        cell.didSelectItemBlock = ^(NSInteger index) {
            [selfWeak pageTo:index];
        };
        cell.currentRole = LxmTool.ShareTool.userModel.roleType.integerValue;
        return cell;
    } else {
        LxmHomeGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeGoodsCell"];
        if (!cell) {
            cell = [[LxmHomeGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeGoodsCell"];
        }
        cell.model = self.homeModel.goodTypes[indexPath.section - 1];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    LxmHomeSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LxmHomeSectionHeaderView"];
    if (!headerView) {
        headerView = [[LxmHomeSectionHeaderView alloc] initWithReuseIdentifier:@"LxmHomeSectionHeaderView"];
    }
    LxmHomeGoodsTypesModel *model = self.homeModel.goodTypes[section - 1];
    [headerView.imgView sd_setImageWithURL:[NSURL URLWithString:model.listPic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    LxmHomeGoodsTypesModel *model = self.homeModel.goodTypes[indexPath.section - 1];
    return ((ScreenW - 25)/2 + 50 + 5)*ceil(model.goodList.count/2.0) + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return ScreenW*0.5;
}

/**
 消息
 */
- (void)xiaoxiClick {
    LxmNotifyMessageVC *vc = [[LxmNotifyMessageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    LxmHomeBannerModel *model = self.homeModel.banners[index];
    if (model.info_type.intValue == 1) {//商品id
        LxmGoodsDetailVC *vc = [[LxmGoodsDetailVC alloc] init];
        vc.goodsID = model.info_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.info_type.intValue == 2) {//富文本
        LxmWebViewController *webVC = [[LxmWebViewController alloc] init];
        webVC.navigationItem.title = @"详情";
        [webVC loadHtmlStr:model.content withBaseUrl:nil];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 首页 按钮跳转界面
 */
- (void)pageTo:(NSInteger)index {
    switch (index) {
        case 0: {//关于我们
            LxmWebViewController *vc = [[LxmWebViewController alloc] init];
            vc.navigationItem.title = @"关于我们";
            vc.loadUrl = [NSURL URLWithString:@"https://app.hkymr.com/aboutMe.html"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
        case 1: {//素材中心
            LxmSuCaiTabBarVC *vc = [[LxmSuCaiTabBarVC alloc] init];
            vc.navigationItem.title = @"分类";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {//投诉中心
            if (LxmTool.ShareTool.userModel.roleType.integerValue == -1) {
                if ([LxmTool ShareTool].userModel.idCode.isValid) {//已实名认证
                    if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 1) {//已读
                        LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 2){
                        //未读 跳转协议界面
                        LxmRenZhengProtocolVC *vc = [[LxmRenZhengProtocolVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                } else {
                    LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.isnext = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                LxmTouSuCenterVC *vc = [[LxmTouSuCenterVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3: {//接单平台
            if ([LxmTool ShareTool].userModel.roleType.integerValue >= 2) {
                LxmJieDanPlatTabbarController *vc = [LxmJieDanPlatTabbarController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {//培训课堂
                
                LxmInfoClassVC *vc = [LxmInfoClassVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 4: {//培训课堂
            LxmInfoClassVC *vc = [LxmInfoClassVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/**
 获取首页数据
 */
- (void)loadIndexData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:get_index parameters:@{@"token" : SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak endRefrish];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.homeModel = [LxmHomeMapModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            NSMutableArray *temp = [NSMutableArray array];
            for (LxmHomeBannerModel *model in selfWeak.homeModel.banners) {
                [temp addObject:model.pic];
            }
            selfWeak.headerView.imageURLStringsGroup = temp;
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak endRefrish];
    }];
}

@end
