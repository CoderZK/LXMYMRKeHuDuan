//
//  LxmShengJiTiaoJianVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShengJiTiaoJianVC.h"
#import "LxmJiaoNaBaoZhengJinVC.h"
#import "LxmShengJiProtocolAlertView.h"
#import "LxmWanShanInfoVC.h"
#import "LxmOrderDetailVC.h"
#import "LxmShopVC.h"
#import "LxmWebViewController.h"

#import "LxmShopCenterVC.h"

#import "LxmShenQingReasonAlertView.h"

#import "LxmTianXieRecommendCodeVC.h"



@implementation LxmCenterButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.oneButton];
        [self addSubview:self.secondButton];
        [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self);
            make.height.equalTo(@30);
        }];
        
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@30);
            make.top.equalTo(self.oneButton.mas_bottom);
        }];
        
    }
    return self;
}

- (UIButton *)oneButton {
    if (!_oneButton) {
        _oneButton = [UIButton new];
        [_oneButton setTitle:@"缴纳2000元保证金" forState:UIControlStateNormal];
        [_oneButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _oneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _oneButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
        _oneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _oneButton;
}

- (UIButton *)secondButton {
    if (!_secondButton) {
        _secondButton = [UIButton new];
        [_secondButton setTitle:@"购买6888元货物" forState:UIControlStateNormal];
        [_secondButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _secondButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _secondButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
        _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _secondButton;
}

@end

@interface LxmShengJiTiaoJianVC ()

@property (nonatomic, strong) LxmMyTeamNavView *navView;//导航栏

@property (nonatomic, strong) UIImageView *topView;//顶部背景

@property (nonatomic, strong) LxmShengJiTiaoJianHeaderView *headerView;

@end

@implementation LxmShengJiTiaoJianVC

- (UIImageView *)topView {
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        _topView.image = [UIImage imageNamed:@"bg_jianbian11"];
    }
    return _topView;
}

- (LxmShengJiTiaoJianHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmShengJiTiaoJianHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView.shengjiButton addTarget:self action:@selector(jiaoNaClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.agreeButton addTarget:self action:@selector(pageToProtocol) forControlEvents:UIControlEventTouchUpInside];

    }
    return _headerView;
}

- (LxmMyTeamNavView *)navView {
    if (!_navView) {
        _navView = [[LxmMyTeamNavView alloc] init];
        _navView.titleLabel.text = @"升级条件";
        [_navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _navView.rightButton.hidden = YES ;
    }
    return _navView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.topView];
    [self.view bringSubviewToFront:self.tableView];
    [self.view addSubview:self.navView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 165));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    
    self.headerView.agreeButton.hidden = !self.model.depositUrl.isValid;
    if (self.model.checkType.intValue == 1) {//1：购买商品补足金额
        [self.headerView.centerBtn.oneButton setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
        [self.headerView.centerBtn.secondButton setImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
        [self.headerView.centerBtn.oneButton setTitle:[NSString stringWithFormat:@" 缴纳%@元保证金",self.model.deposit] forState:UIControlStateNormal];
        [self.headerView.centerBtn.secondButton setTitle:[NSString stringWithFormat:@" 一次性购物金额 ≥ %@元",self.model.payMoney] forState:UIControlStateNormal];
        self.headerView.shengjiButton.hidden = NO;
    } else if (self.model.checkType.intValue == 2) {//2：后台审核
        [self.headerView.centerBtn.oneButton setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
        [self.headerView.centerBtn.oneButton setTitle:@" 通过公司面试" forState:UIControlStateNormal];
        self.headerView.centerBtn.secondButton.hidden = YES;
        self.headerView.shengjiButton.hidden = NO;
    } else if (self.model.checkType.intValue == 3){//3：ceo五个省代
        [self.headerView.centerBtn.oneButton setTitle:@"培养五个省代" forState:UIControlStateNormal];
        self.headerView.centerBtn.secondButton.hidden = YES;
        self.headerView.shengjiButton.hidden = NO;
    } else {//4：
        [self.headerView.centerBtn.oneButton setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
        [self.headerView.centerBtn.secondButton setImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
        [self.headerView.centerBtn.oneButton setTitle:@"完善地址信息" forState:UIControlStateNormal];
        [self.headerView.centerBtn.secondButton setTitle:[NSString stringWithFormat:@" 一次性购物金额 ≥ %@元",self.model.payMoney] forState:UIControlStateNormal];
        self.headerView.shengjiButton.hidden = NO;
    }
    NSInteger role = self.model.roleType.integerValue;
    NSInteger state = self.model.inStatus.integerValue;
//0-未付保证金，1：已付保证金，2：已填信息，3：已购买商品,4：申请省级中，5：后台通过省长审核待升级,6-未升级,7-当前已升级，8-已升级
    
    if (state == 0) {
        [self.headerView.shengjiButton setTitle:@"去支付保证金" forState:UIControlStateNormal];
        [self.headerView.cancelShengjiButton setTitle:@"取消申请" forState:UIControlStateNormal];
    } else if (state == 1 || state == 2) { //1：已付保证金，2：已填信息，
        self.headerView.shengjiButton.hidden = NO;
        if (state == 1) {
            [self.headerView.shengjiButton setTitle:@"去完善个人信息" forState:UIControlStateNormal];
        } else {
            if (self.orderID.isValid) {
                [self.headerView.shengjiButton setTitle:@"去付款" forState:UIControlStateNormal];
            } else {
                if (self.model.locStatus.intValue == 0 || self.model.locStatus.intValue == 2) {
                   [self.headerView.shengjiButton setTitle:@"去购物" forState:UIControlStateNormal];
                } else if (self.model.locStatus.intValue == 1) {//申请中
                   [self.headerView.shengjiButton setTitle:@"取消申请" forState:UIControlStateNormal];
                } else if (self.model.locStatus.intValue == 3){//失败
                    [self.headerView.shengjiButton setTitle:@"继续申请" forState:UIControlStateNormal];
                } else {
                    [self.headerView.shengjiButton setTitle:@"去购物" forState:UIControlStateNormal];
                }
            }
        }
    } else if (state == 3) {
        self.headerView.shengjiButton.hidden = NO;
        self.headerView.shengjiButton.userInteractionEnabled = NO;
        [self.headerView.shengjiButton setTitle:@"已购物" forState:UIControlStateNormal];
    } else if (state == 4) {
        self.headerView.shengjiButton.hidden = NO;
        self.headerView.iconImgView.image = [UIImage imageNamed:@"shengdai"];
        self.headerView.shengjiButton.userInteractionEnabled = NO;
        [self.headerView.shengjiButton setTitle:@"已申请" forState:UIControlStateNormal];
        [self.headerView.cancelShengjiButton setTitle:@"取消申请" forState:UIControlStateNormal];
    } else if (state == 5) {
        self.headerView.shengjiButton.hidden = NO;
        self.headerView.iconImgView.image = [UIImage imageNamed:@"shengdai"];
        self.headerView.shengjiButton.userInteractionEnabled = YES;
        [self.headerView.shengjiButton setTitle:@"审核成功可升级" forState:UIControlStateNormal];
    } else if (state == 6) {
        if (self.model.checkType.intValue == 4) {//直接完善信息购物
            [self.headerView.shengjiButton setTitle:@"完善信息" forState:UIControlStateNormal];
        } else {
            self.headerView.shengjiButton.hidden = NO;
            self.headerView.shengjiButton.userInteractionEnabled = YES;
            if ([self.model.roleType isEqualToString:@"3"] || [self.model.roleType isEqualToString:@"4"]|| [self.model.roleType isEqualToString:@"5"] || [self.model.roleType isEqualToString:@"2.1"] || [self.model.roleType isEqualToString:@"3.1"]) {
                [self.headerView.shengjiButton setTitle:@"申请审核" forState:UIControlStateNormal];
            } else {
                [self.headerView.shengjiButton setTitle:@"立即升级" forState:UIControlStateNormal];
            }
        }
    } else if (state == 7 || state == 8) {
        self.headerView.shengjiButton.hidden = NO;
        self.headerView.shengjiButton.userInteractionEnabled = NO;
        [self.headerView.shengjiButton setTitle:@"已升级" forState:UIControlStateNormal];
    }
    
    self.headerView.agreeButton.hidden = YES;
    if ([self.model.roleType isEqualToString:@"2"] || [self.model.roleType isEqualToString:@"3"] || [self.model.roleType isEqualToString:@"4"] || [self.model.roleType isEqualToString:@"5"] ||[self.model.roleType isEqualToString:@"1.1"] || [self.model.roleType isEqualToString:@"2.1"] || [self.model.roleType isEqualToString:@"3.1"]) {
        if (state == 0 || state == 1 || state == 2 || state == 3 || state == 7 || state == 8) {
            self.headerView.agreeButton.hidden = NO;
        }
    }
    //0-未付保证金，1：已付保证金，2：已填信息，3：已购买商品,4：申请省级中，5：后台通过省长审核待升级,6-未升级,7-当前已升级，8-已升级
    if (!(state == 0 || state == 4)) {
        self.headerView.isHiddleCancel = YES;
        if (state == 2 && ([self.model.roleType isEqualToString:@"0"] || [self.model.roleType isEqualToString:@"1"] ||[self.model.roleType isEqualToString:@"-0.3"] || [self.model.roleType isEqualToString:@"-0.4"]||[self.model.roleType isEqualToString:@"-0.5"] || [self.model.roleType isEqualToString:@"1.05"])) {
            self.headerView.isHiddleCancel = NO;
            [self.headerView.cancelShengjiButton setTitle:@"取消申请" forState:UIControlStateNormal];
        }
    }
//    self.headerView.isHiddleCancel = !(state == 0 || state == 4);
    
    [self.headerView.cancelShengjiButton addTarget:self action:@selector(cancelShengjiClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.model.roleType isEqualToString:@"-0.3"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeirongyu"];
    } else if ([self.model.roleType isEqualToString:@"-0.4"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeigaoji"];
    } else if ([self.model.roleType isEqualToString:@"-0.5"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeivip"];
    } else if ([self.model.roleType isEqualToString:@"1.1"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeishidai"];
    } else if ([self.model.roleType isEqualToString:@"2.1"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeishengdai"];
    } else if ([self.model.roleType isEqualToString:@"3.1"]) {
        _headerView.iconImgView.image = [UIImage imageNamed:@"jianfeiceo"];
    } else {
        switch (role) {//0：无，1：县代，2：市代，3：省代，4：ceo
            case 0:
                _headerView.iconImgView.image = [UIImage imageNamed:@"vip"];
                break;
            case 1:
                _headerView.iconImgView.image = [UIImage imageNamed:@"xiandai"];
                break;
            case 2:
                _headerView.iconImgView.image = [UIImage imageNamed:@"shidai"];
                break;
            case 3:
                _headerView.iconImgView.image = [UIImage imageNamed:@"shengdai"];
                break;
            case 4: {
                _headerView.iconImgView.image = [UIImage imageNamed:@"ceo1"];
            }
            case 5: {
                _headerView.iconImgView.image = [UIImage imageNamed:@"ceo1"];
            }
                break;
                
            default:
                break;
        }
    }
    
}
//显示已读协议按钮的 协议跳转
- (void)pageToProtocol {
    LxmWebViewController *webVC = [[LxmWebViewController alloc] init];
    webVC.navigationItem.title = @"保证金协议";
    NSString *url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.model.depositUrl,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        // 针对 9.0 以上的iOS系统进行处理
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        // 针对 9.0 以下的iOS系统进行处理
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    webVC.loadUrl = [NSURL URLWithString:url];
    [self.navigationController pushViewController:webVC animated:YES];
}



/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 缴纳保证金
 */
- (void)jiaoNaClick {
//    NSInteger role = self.model.roleType.integerValue;
    NSInteger state = self.model.inStatus.integerValue;
//0-未付保证金，1：已付保证金，2：已填信息，3：已购买商品,4：申请省级中，5：后台通过省长审核待升级,6-未升级,7-当前已升级，8-已升级
    if (state == 0) {//未付保证金
        ////判断是否要填写推荐码
        if (self.model.inStatus.intValue < 6) {
            //升级中
            LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
                WeakObj(self);
                   [SVProgressHUD show];
                   _headerView.shengjiButton.userInteractionEnabled = NO;
                   [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":self.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                       [SVProgressHUD dismiss];
                       if ([responseObject[@"key"] intValue] == 1000) {
                           NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                           //1-不要填，2-要填
                           if (recommend_code.intValue == 1) {
                               _headerView.shengjiButton.userInteractionEnabled = YES;
                               LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                               vc.model = self.model;
                               [selfWeak.navigationController pushViewController:vc animated:YES];
                           } else if (recommend_code.intValue == 2){
                               _headerView.shengjiButton.userInteractionEnabled = YES;
                               LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                               vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                                   [selfWeak.navigationController popViewControllerAnimated:YES];
                                   LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                   vc.model = self.model;
                                   vc.recommend_code = code;
                                   [selfWeak.navigationController pushViewController:vc animated:YES];
                               };
                           } else {
                               _headerView.shengjiButton.userInteractionEnabled = YES;
                           }
                       } else {
                           _headerView.shengjiButton.userInteractionEnabled = YES;
                           [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                       }
                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       _headerView.shengjiButton.userInteractionEnabled = YES;
                       [SVProgressHUD dismiss];
                   }];
        }
       
    } else if (state == 1) {//已付保证金 去完善信息
        ////判断是否要填写推荐码
        if (self.model.inStatus.intValue < 6) {//升级中
            LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WeakObj(self);
            [SVProgressHUD show];
            _headerView.shengjiButton.userInteractionEnabled = NO;
            [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":self.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"key"] intValue] == 1000) {
                    NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                    //1-不要填，2-要填
                    if (recommend_code.intValue == 1) {
                        _headerView.shengjiButton.userInteractionEnabled = YES;
                        LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                        vc.model = self.model;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if (recommend_code.intValue == 2){
                        _headerView.shengjiButton.userInteractionEnabled = YES;
                       LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                       vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                           [selfWeak.navigationController popViewControllerAnimated:YES];
                           LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                           vc.model = self.model;
                           vc.recommend_code = code;
                           [selfWeak.navigationController pushViewController:vc animated:YES];
                       };
                       [selfWeak.navigationController pushViewController:vc animated:YES];
                    } else {
                        _headerView.shengjiButton.userInteractionEnabled = YES;
                    }
                } else {
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                    [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }
    } else if (state == 2) {//去购物
        if (self.orderID.isValid) {
            LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
            vc.orderID = self.orderID;
            vc.isShengji = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.model.locStatus.intValue == 0 || self.model.locStatus.intValue == 2) {
                LxmShopVC *vc = [[LxmShopVC alloc] init];
                vc.roleType = [NSString stringWithFormat:@"%@",self.model.roleType];
                vc.shengjiModel = self.model;
                vc.isDeep = YES;
                vc.isAddLocolGoods = YES;
                vc.isGotoGouwuChe = YES;
                UINavigationController *navi = self.navigationController;
                [navi popToRootViewControllerAnimated:NO];
                [navi pushViewController:vc animated:YES];
            } else if (self.model.locStatus.intValue == 1) {//申请中 取消申请
                [self calcelshenqing];
            } else if (self.model.locStatus.intValue == 3) {//失败
                
            } else {
                LxmShopVC *vc = [[LxmShopVC alloc] init];
                vc.roleType = [NSString stringWithFormat:@"%@",self.model.roleType];
                vc.shengjiModel = self.model;
                vc.isDeep = YES;
                vc.isAddLocolGoods = YES;
                vc.isGotoGouwuChe = YES;
                UINavigationController *navi = self.navigationController;
                [navi popToRootViewControllerAnimated:NO];
                [navi pushViewController:vc animated:YES];
            }
        }
    } else if (state == 5){
        LxmShengJiProtocolAlertView *alertView = [[LxmShengJiProtocolAlertView alloc] initWithFrame: UIScreen.mainScreen.bounds];
        
        alertView.url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.model.depositUrl,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
        alertView.bottomButtonClickBlock = ^(NSInteger index) {
            if (index == 300) {//取消
            } else {//确定
                if (self.model.inStatus.intValue < 6) {//升级中
                    LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    WeakObj(self);
                    [SVProgressHUD show];
                    _headerView.shengjiButton.userInteractionEnabled = NO;
                    [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":self.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        [SVProgressHUD dismiss];
                        if ([responseObject[@"key"] intValue] == 1000) {
                            NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                            //1-不要填，2-要填
                            if (recommend_code.intValue == 1) {
                                _headerView.shengjiButton.userInteractionEnabled = YES;
                                LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                vc.model = self.model;
                                [selfWeak.navigationController pushViewController:vc animated:YES];
                            } else if (recommend_code.intValue == 2){
                                _headerView.shengjiButton.userInteractionEnabled = YES;
                                LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                                vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                                    [selfWeak.navigationController popViewControllerAnimated:YES];
                                    LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                    vc.model = self.model;
                                    vc.recommend_code = code;
                                    [selfWeak.navigationController pushViewController:vc animated:YES];
                                };
                            } else {
                                _headerView.shengjiButton.userInteractionEnabled = YES;
                            }
                        } else {
                            _headerView.shengjiButton.userInteractionEnabled = YES;
                            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        _headerView.shengjiButton.userInteractionEnabled = YES;
                        [SVProgressHUD dismiss];
                    }];
                }
            }
        };
        [alertView show];
        
    } else if (state == 6){
        //有补货的订单就不给升级
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @1;
        dict[@"pageSize"] = @10;
        dict[@"status"] = @9;
        WeakObj(self);
        [LxmNetworking networkingPOST:back_order_list parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                if (responseObject.result.list.count > 0) {
                    [UIAlertController showAlertWithmessage:@"您有待补货的订单 暂时不能升级!"];
                } else {
                    if ([self.model.roleType isEqualToString:@"3"] || [self.model.roleType isEqualToString:@"2.1"] ) {
                        [selfWeak becomeShengjiDaili];
                    } else if ([self.model.roleType isEqualToString:@"4"] || [self.model.roleType isEqualToString:@"5"] || [self.model.roleType isEqualToString:@"3.1"]) {
                        [selfWeak becomeCEO];
                    } else {
                        if (self.model.checkType.intValue == 4) {//直接完善信息购物
                            ////判断是否要填写推荐码
                            if (self.model.inStatus.intValue < 6) {//升级中
                                LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                                vc.model = self.model;
                                [selfWeak.navigationController pushViewController:vc animated:YES];
                            } else {
                                [SVProgressHUD show];
                                _headerView.shengjiButton.userInteractionEnabled = NO;
                                [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":selfWeak.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SVProgressHUD dismiss];
                                    if ([responseObject[@"key"] intValue] == 1000) {
                                        NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                                        //1-不要填，2-要填
                                        if (recommend_code.intValue == 1) {
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                            LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                                            vc.model = self.model;
                                            [selfWeak.navigationController pushViewController:vc animated:YES];
                                        } else if (recommend_code.intValue == 2){
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                            LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                                            vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                                                [selfWeak.navigationController popViewControllerAnimated:YES];
                                                LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                                                vc.model = self.model;
                                                vc.recommend_code = code;
                                                [selfWeak.navigationController pushViewController:vc animated:YES];
                                            };
                                            [selfWeak.navigationController pushViewController:vc animated:YES];
                                        } else {
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                        }
                                        
                                    } else {
                                        _headerView.shengjiButton.userInteractionEnabled = YES;
                                        [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                                    }
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    _headerView.shengjiButton.userInteractionEnabled = YES;
                                    [SVProgressHUD dismiss];
                                }];
                            }
                
                        } else {
                            
                            ////判断是否要填写推荐码
                             if (self.model.inStatus.intValue < 6) {//升级中
                                 LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                 vc.model = self.model;
                                 [selfWeak.navigationController pushViewController:vc animated:YES];
                             } else {
                                [SVProgressHUD show];
                                _headerView.shengjiButton.userInteractionEnabled = NO;
                                [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":selfWeak.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SVProgressHUD dismiss];
                                    if ([responseObject[@"key"] intValue] == 1000) {
                                        NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                                        //1-不要填，2-要填
                                        if (recommend_code.intValue == 1) {
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                            LxmShengJiProtocolAlertView *alertView = [[LxmShengJiProtocolAlertView alloc] initWithFrame: UIScreen.mainScreen.bounds];
                                            
                                            alertView.url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.model.depositUrl,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
                                            alertView.bottomButtonClickBlock = ^(NSInteger index) {
                                                if (index == 300) {//取消
                                                } else {//确定
                                                    LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                                    vc.model = self.model;
                                                    [selfWeak.navigationController pushViewController:vc animated:YES];
                                                }
                                            };
                                            [alertView show];
                                            
                            
                                        } else if (recommend_code.intValue == 2){
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                           LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                                           vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                                               [selfWeak.navigationController popViewControllerAnimated:YES];
                                               LxmShengJiProtocolAlertView *alertView = [[LxmShengJiProtocolAlertView alloc] initWithFrame: UIScreen.mainScreen.bounds];
                                               
                                               alertView.url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.model.depositUrl,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
                                               alertView.bottomButtonClickBlock = ^(NSInteger index) {
                                                   if (index == 300) {//取消
                                                   } else {//确定
                                                      LxmJiaoNaBaoZhengJinVC *vc = [[LxmJiaoNaBaoZhengJinVC alloc] init];
                                                      vc.model = self.model;
                                                      vc.recommend_code = code;
                                                      [selfWeak.navigationController pushViewController:vc animated:YES];
                                                   }
                                               };
                                               [alertView show];
                                           };
                                           [selfWeak.navigationController pushViewController:vc animated:YES];
                                        } else {
                                            _headerView.shengjiButton.userInteractionEnabled = YES;
                                        }
                                    } else {
                                        _headerView.shengjiButton.userInteractionEnabled = YES;
                                        [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                                    }
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    _headerView.shengjiButton.userInteractionEnabled = YES;
                                    [SVProgressHUD dismiss];
                                }];
                                                
                             }
                        }
                    }
                }
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}

- (void)calcelshenqing {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:cancel_role_up parameters:@{@"token":SESSION_TOKEN} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已取消申请!"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 申请成为省服务商
 */
- (void)becomeShengjiDaili {//role_province和role_ceo  申请省代申请CEO,加个字段up_message，申请理由
    if (self.model.inStatus.intValue < 6) {//升级中
        [self becomeShengjiDailiCode:nil];
    } else {
        ////判断是否要填写推荐码
        WeakObj(self);
        [SVProgressHUD show];
        _headerView.shengjiButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":self.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1000) {
                NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                //1-不要填，2-要填
                if (recommend_code.intValue == 1) {
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                    [selfWeak becomeShengjiDailiCode:nil];
                } else if (recommend_code.intValue == 2){
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                   LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                   vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                       [selfWeak.navigationController popViewControllerAnimated:YES];
                       [selfWeak becomeShengjiDailiCode:code];
                   };
                   [selfWeak.navigationController pushViewController:vc animated:YES];
                } else {
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                }
            } else {
                _headerView.shengjiButton.userInteractionEnabled = YES;
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            _headerView.shengjiButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)becomeShengjiDailiCode: (NSString *)code {
    void(^shenqingBlock)(NSString *reason) = ^(NSString *reason) {
        [SVProgressHUD show];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"up_message"] = reason;
        dict[@"role_type"] = self.model.roleType;
        if (code.isValid) {
            dict[@"code"] = code;
        }
        [LxmNetworking networkingPOST:role_province parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"已提交申请!"];
                [LxmEventBus sendEvent:@"yitijiaoshenqing" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    };
    LxmShenQingReasonAlertView *alertView = [[LxmShenQingReasonAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    alertView.shenqingReasonBlock = shenqingBlock;
    [alertView show];
}


/**
 申请成为CEO
 */
- (void)becomeCEO {
    ////判断是否要填写推荐码
    if (self.model.inStatus.intValue < 6) {//升级中
        [self becomeCEOCode:nil];
    } else {
        WeakObj(self);
        [SVProgressHUD show];
        _headerView.shengjiButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:top_info parameters:@{@"token":SESSION_TOKEN,@"roleType":self.model.roleType} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1000) {
                NSString *recommend_code = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"data"]];
                //1-不要填，2-要填
                if (recommend_code.intValue == 1) {
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                    [selfWeak becomeCEOCode:nil];
                } else if (recommend_code.intValue == 2){
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                   LxmTianXieRecommendCodeVC *vc = [[LxmTianXieRecommendCodeVC alloc] init];
                   vc.recommendCodeBlock = ^(NSString * _Nonnull code) {
                       [selfWeak.navigationController popViewControllerAnimated:YES];
                       [selfWeak becomeCEOCode:code];
                   };
                   [selfWeak.navigationController pushViewController:vc animated:YES];
                } else {
                    _headerView.shengjiButton.userInteractionEnabled = YES;
                }
            } else {
                _headerView.shengjiButton.userInteractionEnabled = YES;
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            _headerView.shengjiButton.userInteractionEnabled = YES;_headerView.shengjiButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)becomeCEOCode:(NSString *)code {
    void(^becomeCEOBlock)(NSString *reason) = ^(NSString *reason){
        [SVProgressHUD show];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"up_message"] = reason;
        dict[@"role_type"] = self.model.roleType;
        if (code.isValid) {
            dict[@"code"] = code;
        }
        [LxmNetworking networkingPOST:role_ceo parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"已提交申请!"];
                [LxmEventBus sendEvent:@"yitijiaoshenqing" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    };
    LxmShenQingReasonAlertView *alertView = [[LxmShenQingReasonAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    alertView.shenqingReasonBlock = becomeCEOBlock;
    [alertView show];
}

/**
 取消升级
 */
- (void)cancelShengjiClick:(UIButton *)btn {
//    double role = self.model.roleType.doubleValue;
    NSInteger state = self.model.inStatus.integerValue;
    if (state == 2 && ([self.model.roleType isEqualToString:@"0"] || [self.model.roleType isEqualToString:@"1"] || [self.model.roleType isEqualToString:@"-0.3"] || [self.model.roleType isEqualToString:@"-0.4"]||[self.model.roleType isEqualToString:@"-0.5"] || [self.model.roleType isEqualToString:@"1.05"])) {
        //取消申请
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您确定要取消申请吗?" preferredStyle:UIAlertControllerStyleAlert];
               [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
               [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                  btn.userInteractionEnabled = NO;
                  [SVProgressHUD show];
                  [LxmNetworking networkingPOST:cancel_finish_message parameters:@{@"token":SESSION_TOKEN} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
                      [SVProgressHUD dismiss];
                      if (responseObject.key.integerValue == 1000) {
                          [[LxmTool ShareTool] delShengJiAllGoods];
                          [SVProgressHUD showSuccessWithStatus:@"已取消申请"];
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              [LxmEventBus sendEvent:@"cancelUp" data:nil];
                              [self.navigationController popViewControllerAnimated:YES];
                          });
                      } else {
                          [UIAlertController showAlertWithmessage:responseObject.message];
                      }
                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                      [SVProgressHUD dismiss];
                  }];
              }]];
              [self presentViewController:alertView animated:YES completion:nil];
    } else {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您确定要取消升级吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           btn.userInteractionEnabled = NO;
           [SVProgressHUD show];
           [LxmNetworking networkingPOST:cancel_role_up parameters:@{@"token":SESSION_TOKEN} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
               [SVProgressHUD dismiss];
               if (responseObject.key.integerValue == 1000) {
                   [SVProgressHUD showSuccessWithStatus:@"已取消申请"];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [LxmEventBus sendEvent:@"cancelUp" data:nil];
                       [self.navigationController popViewControllerAnimated:YES];
                   });
               } else {
                   [UIAlertController showAlertWithmessage:responseObject.message];
               }
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               [SVProgressHUD dismiss];
           }];
       }]];
       [self presentViewController:alertView animated:YES completion:nil];
    }
    
}


@end

@implementation LxmShengJiTiaoJianHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
        [self setData];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.shaowView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.leftLineView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.rightLineView];
    [self.bgView addSubview:self.centerBtn];
    [self.bgView addSubview:self.agreeButton];
    [self.bgView addSubview:self.shengjiButton];
    [self.bgView addSubview:self.cancelShengjiButton];
}

/**
 
 */
- (void)setConstrains {
    [self.shaowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NavigationSpace + 25);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 55));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NavigationSpace + 20);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 50));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(25);
        make.centerX.equalTo(self.bgView);
        make.width.equalTo(@132);
        make.height.equalTo(@99);
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.titleLabel.mas_leading).offset(-5);
        make.centerY.equalTo(self.titleLabel);
        make.leading.equalTo(self.bgView).offset(30);
        make.height.equalTo(@1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(25);
        make.centerX.equalTo(self.bgView);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.bgView).offset(-30);
        make.height.equalTo(@1);
    }];
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self.titleLabel);
    }];
   
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.shengjiButton.mas_top);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    [self.shengjiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(35);
        make.trailing.equalTo(self.bgView).offset(-35);
        make.bottom.equalTo(self.bgView).offset(-60);
        make.centerX.equalTo(self.bgView);
        make.height.equalTo(@44);
    }];
    [self.cancelShengjiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(35);
        make.trailing.equalTo(self.bgView).offset(-35);
        make.bottom.equalTo(self.bgView).offset(-20);
        make.centerX.equalTo(self.bgView);
        make.height.equalTo(@40);
    }];
}

- (UIView *)shaowView {
    if (!_shaowView) {
        _shaowView = [UIView new];
        _shaowView.backgroundColor = [UIColor whiteColor];
        _shaowView.layer.shadowColor = UIColor.blackColor.CGColor;
        _shaowView.layer.shadowRadius = 5;
        _shaowView.layer.shadowOpacity = 0.5;
        _shaowView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _shaowView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = BGGrayColor;
    }
    return _leftLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [UIView new];
        _rightLineView.backgroundColor = BGGrayColor;
    }
    return _rightLineView;
}

- (LxmCenterButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [LxmCenterButton new];
    }
    return _centerBtn;
}

- (LxmAgreeButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[LxmAgreeButton alloc] init];
        _agreeButton.iconImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
    }
    return _agreeButton;
}

- (UIButton *)shengjiButton {
    if (!_shengjiButton) {
        _shengjiButton = [[UIButton alloc] init];
        [_shengjiButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_shengjiButton setTitle:@"去升级" forState:UIControlStateNormal];
        [_shengjiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _shengjiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _shengjiButton.layer.cornerRadius = 22;
        _shengjiButton.layer.masksToBounds = YES;
    }
    return _shengjiButton;
}

- (UIButton *)cancelShengjiButton {
    if (!_cancelShengjiButton) {
        _cancelShengjiButton = [[UIButton alloc] init];
        [_cancelShengjiButton setTitle:@"取消升级" forState:UIControlStateNormal];
        [_cancelShengjiButton setTitleColor:[UIColor colorWithRed:242/255.0 green:164/255.0 blue:11/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelShengjiButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelShengjiButton.layer.cornerRadius = 22;
        _cancelShengjiButton.layer.masksToBounds = YES;
    }
    return _cancelShengjiButton;
}

- (void)setIsHiddleCancel:(BOOL)isHiddleCancel {
    _isHiddleCancel = isHiddleCancel;
    _cancelShengjiButton.hidden = isHiddleCancel;
    if (_isHiddleCancel) {
        [self.shengjiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView).offset(35);
            make.trailing.equalTo(self.bgView).offset(-35);
            make.bottom.equalTo(self.bgView).offset(-20);
            make.centerX.equalTo(self.bgView);
            make.height.equalTo(@44);
        }];
    } else {
        [self.shengjiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView).offset(35);
            make.trailing.equalTo(self.bgView).offset(-35);
            make.bottom.equalTo(self.bgView).offset(-60);
            make.centerX.equalTo(self.bgView);
            make.height.equalTo(@44);
        }];
    }
}

- (void)setData {
    _titleLabel.text = @"升级条件";
}

@end
