//
//  LxmShopCenterVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCenterVC.h"
#import "LxmShopCenterView.h"
#import "LxmGouJinGoodsVC.h"
#import "LxmMyDianPuVC.h"
#import "LxmOrderChaXunVC.h"
#import "LxmMyTeamVC.h"
#import "LxmYeJiVC.h"
#import "LxmShengJiVC.h"
#import "LxmNotifyMessageVC.h"
#import "LxmTabBarVC.h"
#import "LxmMyKefuAlertView.h"
#import "LxmShopVC.h"
#import "LxmShengjiGouWuVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmRenZhengProtocolVC.h"
#import "LxmNianDuKaoHeVC.h"


@interface LxmShopCenterVC ()

@property (nonatomic, strong) UIButton *rightButton;//导航栏右侧按钮

@property (nonatomic, strong) LxmShopCenterTopView *topView;

@property (nonatomic, strong) LxmShopCenterUserInfoModel *shopInfoModel;/* 商家个人中心 */

@property (nonatomic, strong) NSMutableArray <LxmShopCenterUserListModel *> *dataArr;//考核业绩

@end

@implementation LxmShopCenterVC

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40,40)];
        _rightButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 0);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"lianxikefu"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(lianxikefuClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self loadShopCenterData];
}

- (LxmShopCenterTopView *)topView {
    if (!_topView) {
        _topView = [[LxmShopCenterTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.hidden = YES;
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家中心";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.topView;
    self.dataArr = [NSMutableArray array];
    WeakObj(self);    
    [LxmEventBus registerEvent:@"yitongyi" block:^(id data) {
        LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:NO];
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmShopCenterTwoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmShopCenterKaoHeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmShopCenterKaoHeCell"];
        if (!cell) {
            cell = [[LxmShopCenterKaoHeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmShopCenterKaoHeCell"];
        }
        cell.shopInfoModel = self.shopInfoModel;
        cell.dataArr = self.dataArr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    LxmShopCenterItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmShopCenterItemCell"];
    if (!cell) {
        cell = [[LxmShopCenterItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmShopCenterItemCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopInfoModel = self.shopInfoModel;
    WeakObj(self);
    cell.selectItemBlock = ^(NSInteger index) {
        [selfWeak pageToItem:index];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
           if ([self.shopInfoModel.roleType isEqualToString:@"-1"] || [self.shopInfoModel.roleType isEqualToString:@"0"] || [self.shopInfoModel.roleType isEqualToString:@"1"] || [self.shopInfoModel.roleType isEqualToString:@"4"] || [self.shopInfoModel.roleType isEqualToString:@"-0.5"] || [self.shopInfoModel.roleType isEqualToString:@"-0.4"] || [self.shopInfoModel.roleType isEqualToString:@"-0.3"]) {
               return 0.01;
           }
           return 150;
       }
    if ([self.shopInfoModel.roleType isEqualToString:@"-1"] || [self.shopInfoModel.roleType isEqualToString:@"0"] || [self.shopInfoModel.roleType isEqualToString:@"1"] || [self.shopInfoModel.roleType isEqualToString:@"-0.5"] || [self.shopInfoModel.roleType isEqualToString:@"-0.4"] || [self.shopInfoModel.roleType isEqualToString:@"-0.3"]) {
        return 80*ceil(6/3.0) + 60;
    }
    return 80*ceil(7/3.0) + 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 0) {
//        LxmMineYeJiKaoTVC * vc =[[LxmMineYeJiKaoTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
//        vc.hidesBottomBarWhenPushed = YES;
//        if (self.shopInfoModel.roleType.intValue == 2) {
//            vc.isJingLi = YES;
//        }
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
}

/**
 跳转到相应模块儿
 */
- (void)pageToItem:(NSInteger)index {
    if ([self.shopInfoModel.roleType isEqualToString:@"-1"] || [self.shopInfoModel.roleType isEqualToString:@"0"] || [self.shopInfoModel.roleType isEqualToString:@"1"] || [self.shopInfoModel.roleType isEqualToString:@"-0.5"] || [self.shopInfoModel.roleType isEqualToString:@"-0.4"] || [self.shopInfoModel.roleType isEqualToString:@"-0.3"]) {
        switch (index) {
            case 0: {// 我的店铺
                LxmMyDianPuVC *vc = [[LxmMyDianPuVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: {//购进商品
                if ([LxmTool ShareTool].userModel.roleType.intValue < 2) {
                    LxmShopVC *vc = [[LxmShopVC alloc] init];
                    vc.isDeep = YES;
                    vc.isGotoGouwuChe = YES;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    LxmGouJinGoodsVC *vc = [[LxmGouJinGoodsVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 2: {//订单查询
                LxmOrderChaXunVC *vc = [[LxmOrderChaXunVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3: {//我要升级
                
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
            }
                break;
            case 4: {//年度考核
                
                LxmShopVC *vc = [[LxmShopVC alloc] init];
                vc.roleType = [NSString stringWithFormat:@"%@",self.shopInfoModel.roleType];
                vc.shengjiModel = nil;
                vc.isDeep = YES;
                vc.isHaoCai = YES;
                vc.isAddLocolGoods = NO;
                vc.isGotoGouwuChe = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                //                LxmNianDuKaoHeVC *vc = [[LxmNianDuKaoHeVC alloc] init];
                //                vc.shopInfoModel = self.shopInfoModel;
                //                vc.hidesBottomBarWhenPushed = YES;
                //                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5: {//消息通知
                LxmNotifyMessageVC *vc = [[LxmNotifyMessageVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    } else {
        switch (index) {
            case 0: {// 我的店铺
                LxmMyDianPuVC *vc = [[LxmMyDianPuVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: {//购进商品
                LxmGouJinGoodsVC *vc = [[LxmGouJinGoodsVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: {//订单查询
                LxmOrderChaXunVC *vc = [[LxmOrderChaXunVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3: {//我的团队
                LxmMyTeamVC *vc = [[LxmMyTeamVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4: {//我的业绩
                LxmYeJiVC *vc = [[LxmYeJiVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5: {//我要升级
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
            }
                break;
            case 6: {//年度考核
                
                LxmShopVC *vc = [[LxmShopVC alloc] init];
                vc.roleType = [NSString stringWithFormat:@"%@",self.shopInfoModel.roleType];
                vc.shengjiModel = nil;
                vc.isDeep = YES;
                vc.isHaoCai = YES;
                vc.isAddLocolGoods = NO;
                vc.isGotoGouwuChe = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                //                LxmNianDuKaoHeVC *vc = [[LxmNianDuKaoHeVC alloc] init];
                //                vc.shopInfoModel = self.shopInfoModel;
                //                vc.hidesBottomBarWhenPushed = YES;
                //                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7: {//消息通知
                LxmNotifyMessageVC *vc = [[LxmNotifyMessageVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

/**
 商铺个人中心信息
 */
- (void)loadShopCenterData {
    if (!self.shopInfoModel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:shop_center parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        _topView.hidden = NO;
        if ([responseObject[@"key"] integerValue] == 1000) {
            [selfWeak.dataArr removeAllObjects];
            
            selfWeak.shopInfoModel = [LxmShopCenterUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
            selfWeak.topView.shopInfoModel = selfWeak.shopInfoModel;
            NSArray *tempArr = responseObject[@"result"][@"list"];
            if ([tempArr isKindOfClass:NSArray.class]) {
                for (NSDictionary *dict in tempArr) {
                    LxmShopCenterUserListModel *model = [LxmShopCenterUserListModel mj_objectWithKeyValues:dict];
                    [selfWeak.dataArr addObject:model];
                }
            }
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        _topView.hidden = NO;
    }];
}

/**
 联系客服
 */
- (void)lianxikefuClick {
    LxmMyKefuAlertView *alertView = [[LxmMyKefuAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    alertView.code = LxmTool.ShareTool.userModel.serviceName;
    [alertView show];
}

@end
