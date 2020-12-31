//
//  LxmMineVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMineVC.h"
#import "LxmShopCenterView.h"
#import "LxmMineView.h"
#import "LxmMyKefuAlertView.h"
#import "LxmSettingVC.h"
#import "LxmUserInfoVC.h"
#import "LxmQianBaoVC.h"
#import "LxmMyHongBaoVC.h"
#import "LxmMyOrderVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmYiRenZhengVC.h"
#import "LxmMyBaoZhengJinVC.h"
#import "LxmShengJiVC.h"
#import "LxmTabBarVC.h"
#import "LxmShopVC.h"
#import "LxmNotifyMessageVC.h"
#import "LxmMenDianChaXunVC.h"

#import "LxmShengjiGouWuVC.h"

#import "LxmRenZhengProtocolVC.h"
#import "LxmJiFenShopFatherVC.h"
#import "LxmMineJiFenTVC.h"
#import "LxmMineJiFenXiaJiTVC.h"

@interface LxmMineVC ()

@property (nonatomic, strong) LxmShopCenterTopView *topView;

@property (nonatomic, strong) UIButton *rightButton;//导航栏右侧按钮

@property(nonatomic,strong)LxmUserInfoModel *jiFenModel;

@end

@implementation LxmMineVC

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40,40)];
        _rightButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 0);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"xiaoxi_black"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(xiaoxiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (LxmShopCenterTopView *)topView {
    if (!_topView) {
        _topView = [[LxmShopCenterTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
        _topView.infoModel = [LxmTool ShareTool].userModel;
    }
    return _topView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSString *preRoleType = LxmTool.ShareTool.userModel.roleType;
    NSString *status = LxmTool.ShareTool.userModel.shopStatus;
    if (preRoleType.integerValue == -1 && (status.integerValue == 2 || status.integerValue == 6)) {
        [self loadMyUserInfoWithOkBlock:^{
            if (LxmTool.ShareTool.userModel.roleType.intValue > -1) {
                UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
            }
        }];
    }
    WeakObj(self);
    [self loadMyUserInfoWithOkBlock:^{
        selfWeak.topView.infoModel = [LxmTool ShareTool].userModel;
        
        if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"3"] || [[LxmTool ShareTool].userModel.roleType isEqualToString:@"4"]) {
            [self getScoreData];
        }else {
            [selfWeak.tableView reloadData];
        }
        
        
    }];
}

//获取小煜
- (void)getScoreData {
    
    //获取个人信息
    [LxmNetworking networkingPOST:my_inner_score parameters:@{@"token":TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            
            if (responseObject[@"result"] != nil && [[responseObject[@"result"] allKeys] containsObject:@"map"]) {
                self.jiFenModel  = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.topView;
    WeakObj(self);
    self.topView.likeshengjiBlock = ^{
        if ([LxmTool ShareTool].userModel.roleType.integerValue == -1) {
            if ([LxmTool ShareTool].userModel.idCode.isValid) {//已实名认证
                if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 1) {//已读
                    LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [selfWeak.navigationController pushViewController:vc animated:YES];
                } else if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 2){
                    //未读 跳转协议界面
                    LxmRenZhengProtocolVC *vc = [[LxmRenZhengProtocolVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [selfWeak.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isnext = YES;
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [selfWeak userInfoClick];
        }
    };
    
    [LxmEventBus registerEvent:@"yitongyi" block:^(id data) {
        LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:NO];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmMineOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineOrderCell"];
        if (!cell) {
            cell = [[LxmMineOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMineOrderCell"];
        }
        WeakObj(self);
        cell.myOrderBlock = ^{
            [selfWeak gotoMyOrder];
        };
        cell.itemDidSeletAtIndex = ^(NSInteger index) {
            [selfWeak pageToList:index];
        };
        return cell;
    }
    LxmMineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineCell"];
    if (!cell) {
        cell = [[LxmMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMineCell"];
    }
    cell.index = indexPath.row;
    cell.infoModel = [LxmTool ShareTool].userModel;
    //    cell.clipsToBounds = YES;
    
    if (indexPath.row == 1) {
        cell.detaillabel.text = [[NSString stringWithFormat:@"%0.2f",self.jiFenModel.direct_score.doubleValue] getPriceStr];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {//我的钱包
            LxmQianBaoVC *vc = [[LxmQianBaoVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {//我的红包
            LxmMyHongBaoVC *vc = [[LxmMyHongBaoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {//保证金
            LxmMyBaoZhengJinVC *vc = [[LxmMyBaoZhengJinVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        
            case 1: {//小煜
                
                //                LxmMineJifenMingXiTVC * vc =[[LxmMineJifenMingXiTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
                //                vc.hidesBottomBarWhenPushed = YES;
                //                [self.navigationController pushViewController:vc animated:YES];
                
                LxmMineJiFenXiaJiTVC * vc =[[LxmMineJiFenXiaJiTVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.jifenModel = self.jiFenModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            
        case 2: {//积分
            
            LxmMineJiFenTVC * vc =[[LxmMineJiFenTVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            vc.jifenStr = [LxmTool ShareTool].userModel.sendScore;
            [self.navigationController pushViewController:vc animated:YES];  
            
            //                LxmMineJifenMingXiTVC * vc =[[LxmMineJifenMingXiTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
            //                vc.hidesBottomBarWhenPushed = YES;
            //                [self.navigationController pushViewController:vc animated:YES];
            
            //                LxmMineJiFenXiaJiTVC * vc =[[LxmMineJiFenXiaJiTVC alloc] init];
            //                vc.hidesBottomBarWhenPushed = YES;
            //                vc.jifenModel = self.jiFenModel;
            //                [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5: {//实名认证
            if ([LxmTool ShareTool].userModel.idCode.isValid) {//已实名认证
                if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 1) {//已读
                    //已认证
                    LxmYiRenZhengVC *vc = [[LxmYiRenZhengVC alloc] init];
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
        case 6: {
            LxmMenDianChaXunVC *vc = [[LxmMenDianChaXunVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7: {
            LxmMyKefuAlertView *alertView = [[LxmMyKefuAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alertView.code = [LxmTool ShareTool].userModel.serviceName;
            [alertView show];
        }
            break;
        case 8: {
            
            //            LxmJiFenShopFatherVC * vc =[[LxmJiFenShopFatherVC alloc] init];
            //            vc.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:vc animated:YES];
            LxmSettingVC *vc = [LxmSettingVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    } else {
        NSString *roleType = LxmTool.ShareTool.userModel.roleType;
        if (indexPath.row == 3 || indexPath.row == 4 ) {//我的红包 保证金
            if ([roleType isEqualToString:@"-1"] || [roleType isEqualToString:@"0"] || [roleType isEqualToString:@"1"] || [roleType isEqualToString:@"-0.3"] || [roleType isEqualToString:@"-0.4"] || [roleType isEqualToString:@"-0.5"] || [roleType isEqualToString:@"1.1"] || [roleType isEqualToString:@"1.05"]) {
                return 0.01;
            }
            return 60;
        }else if (indexPath.row == 1) {
            if ([roleType isEqualToString:@"3"] || [roleType isEqualToString:@"4"]) {
                return 60;
            }else {
                return 0;
            }
        }else if (indexPath.row == 2) {
            if (roleType.floatValue >-1) {
                return 60;;
            }else {
                return 0;
            }
        } else if (indexPath.row == 6) {//门店查询
            if ([roleType isEqualToString:@"-1"] || [roleType isEqualToString:@"0"] || [roleType isEqualToString:@"1"] || [roleType isEqualToString:@"-0.3"] || [roleType isEqualToString:@"-0.4"] || [roleType isEqualToString:@"-0.5"] || [roleType isEqualToString:@"1.1"] || [roleType isEqualToString:@"2.1"] || [roleType isEqualToString:@"3.1"] || [roleType isEqualToString:@"1.05"] ) {
                return 0.01;
            }
            return 60;
        } else {
            return 60;
        }
    }
}

/**
 消息
 */
- (void)xiaoxiClick {
    
    
    LxmNotifyMessageVC *vc = [[LxmNotifyMessageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 个人中心
 */
- (void)userInfoClick {
    LxmUserInfoVC *vc = [[LxmUserInfoVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 查看我的订单
 */
- (void)gotoMyOrder {
    LxmMyOrderVC *vc = [[LxmMyOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.selectIndex = 0;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pageToList:(NSInteger)index {
    LxmMyOrderVC *vc = [[LxmMyOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    if (index == 4) {
        vc.selectIndex = 105;
    } else {
        vc.selectIndex = index + 100;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@interface LxmQianBaoButton ()



@end

@implementation LxmQianBaoButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.textLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@30);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(10);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = CharacterGrayColor;
    }
    return _textLabel;
}

@end

@implementation LxmQianBaoTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftButton];
        [self addSubview:self.centerButton];
        [self addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
            make.trailing.equalTo(self.centerButton.mas_leading);
            make.width.equalTo(self.centerButton);
        }];
        [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self.rightButton.mas_leading);
            make.width.equalTo(self.rightButton);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self);
            make.width.equalTo(self.leftButton);
        }];
    }
    return self;
}

- (LxmQianBaoButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[LxmQianBaoButton alloc] init];
        _leftButton.imgView.image = [UIImage imageNamed:@"wdqb_cz"];
        _leftButton.textLabel.text = @"充值";
    }
    return _leftButton;
}

- (LxmQianBaoButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[LxmQianBaoButton alloc] init];
        _centerButton.imgView.image = [UIImage imageNamed:@"wdqb_tx"];
        _centerButton.textLabel.text = @"提现";
    }
    return _centerButton;
}

- (LxmQianBaoButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[LxmQianBaoButton alloc] init];
        _rightButton.imgView.image = [UIImage imageNamed:@"wdqb_zz"];
        _rightButton.textLabel.text = @"转账";
    }
    return _rightButton;
}

@end
