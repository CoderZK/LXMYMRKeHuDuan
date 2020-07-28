//
//  LxmPayVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPayVC.h"
#import "LxmBuHuoOrderVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "LxmShengJiVC.h"
#import "LxmShopVC.h"

#import "LxmJieDanPlatTabbarController.h"

#import "LxmKuCunBuZuAletView.h"

#import "LxmSubShopVC.h"

#import "LxmOrderChaXunVC.h"

#import "LxmDingDanMessageVC.h"

#import "LxmDaoJishiView.h"

@implementation LxmPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectImgView];
        [self addSubview:self.lineView ];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
    }
    return _selectImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end

/* 交完保证金跳转--服务区域 */
#import "LxmWanShanInfoVC.h"

@interface LxmPayVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIButton *payButton;//支付

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) LxmPayVC_type type;

//倒计时
@property (nonatomic , strong)NSTimer * timer;

@property (nonatomic , assign)int time;

@property (nonatomic, strong)LxmDaoJishiView *daojishiView;//倒计时

@end

@implementation LxmPayVC

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayNoti:) name:@"WXPAY" object:nil];
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPayVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
        
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [[UIButton alloc] init];
        [_payButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 22;
        _payButton.layer.masksToBounds = YES;
        _payButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.currentIndex = 0;
    
    if (self.type == LxmPayVC_type_jiaobaozhengjin) {
        CGFloat money = self.shengjiModel.deposit.doubleValue - LxmTool.ShareTool.userModel.deposit.doubleValue;
        [_payButton setTitle:[NSString stringWithFormat:@"支付%.2f元",money] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_bujiaobaozhengjin) {
        [_payButton setTitle:[NSString stringWithFormat:@"支付%@元", LxmTool.ShareTool.userModel.depositMoney] forState:UIControlStateNormal];
    }  else if (self.type == LxmPayVC_type_gwcJieSuan) {
        [_payButton setTitle:[NSString stringWithFormat:@"支付%@元",self.orderModel.price] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_ddcx) {
        CGFloat f = self.shifuMoney.doubleValue;
        NSInteger d = self.shifuMoney.integerValue;
        [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_zjgm) {
        CGFloat f = self.zhijieGoumaiMoney.doubleValue;
        NSInteger d = self.zhijieGoumaiMoney.integerValue;
        [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_yjbh) {
        CGFloat f = self.buhuoModel.price.doubleValue;
        NSInteger d = self.buhuoModel.price.integerValue;
        [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_wfbd) {
        CGFloat f = self.wfbdMoney.doubleValue;
        NSInteger d = self.wfbdMoney.integerValue;
        [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_jiajia) {
        CGFloat f = self.jiajiaPrice.doubleValue;
        NSInteger d = self.jiajiaPrice.integerValue;
        [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
    } else if (self.type == LxmPayVC_type_shengjigouwu) {
        if (self.shengjiGouwuModel) {
            CGFloat f = self.shengjiGouwuModel.price.doubleValue;
            NSInteger d = self.shengjiGouwuModel.price.integerValue;
            [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
        } else {
            CGFloat f = self.shifuMoney.doubleValue;
            NSInteger d = self.shifuMoney.integerValue;
            [_payButton setTitle:d == f ? [NSString stringWithFormat:@"支付%ld元",(long)d] : [NSString stringWithFormat:@"支付%.2f元",f] forState:UIControlStateNormal];
        }
        
    } else{
        [_payButton setTitle:@"支付500元" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.tableView.tableFooterView = footView;
    
    [footView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.bottom.equalTo(footView);
        make.height.equalTo(@44);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPayCell"];
    if (!cell) {
        cell = [[LxmPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPayCell"];
    }
    cell.selectImgView.image = [UIImage imageNamed:self.currentIndex == indexPath.row ? @"xuanzhong_y" : @"xuanzhong_n"] ;
    if (indexPath.row == 0) {
        
        CGFloat f = [LxmTool ShareTool].userModel.balance.doubleValue;
        NSInteger d = [LxmTool ShareTool].userModel.balance.integerValue;
        
        cell.iconImgView.image = [UIImage imageNamed:@"yue_pay"];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"余额支付"];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:f == d ? [NSString stringWithFormat:@"¥%ld",(long)d] : [NSString stringWithFormat:@"¥%.2f",f] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        cell.titleLabel.attributedText = att;
    } else if (indexPath.row == 1) {
        cell.iconImgView.image = [UIImage imageNamed:@"alipay_pay"];
        cell.titleLabel.text = @"支付宝支付";
    } else {
        cell.iconImgView.image = [UIImage imageNamed:@"wechat_pay"];
        cell.titleLabel.text = @"微信支付";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == LxmPayVC_type_shengjigouwu || self.type == LxmPayVC_type_yjbh) {
        if (self.creatTime.isValid) {
            LxmDaoJishiView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LxmDaoJishiView"];
            if (!headerView) {
                headerView = [[LxmDaoJishiView alloc] initWithReuseIdentifier:@"LxmDaoJishiView"];
            }
            self.daojishiView = headerView;
            headerView.contentView.backgroundColor = MainColor;
            if (self.type == LxmPayVC_type_shengjigouwu || self.type == LxmPayVC_type_yjbh) {
                NSString *time = self.creatTime;
                if (time.length > 10) {
                    time = [time substringToIndex:10];
                }
                double chaTime = [NSString chaWithCreateTime:time];
                if (chaTime < 0) {
                    //已取消的订单
                    headerView.daojishiLabel.text = @"订单已被取消!";
                } else {
                    [self.timer invalidate];
                    self.timer = nil;
                    self.time = chaTime;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer1) userInfo:nil repeats:YES];
                    [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
                    [self.timer fire];
                }
            }
            return headerView;
        }
        return nil;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == LxmPayVC_type_shengjigouwu || self.type == LxmPayVC_type_yjbh) {
        if (self.creatTime.isValid) {
            return 60;
        }
        return 0.01;
    }
    return 0.01;
}

-(void)onTimer1 {
    NSString *timeStr = [NSString durationTimeStringWithDuration:_time--];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"请在" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:timeStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"内完成付款,否则订单会被系统取消" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [att appendAttributedString:str1];
    [att appendAttributedString:str2];
    self.daojishiView.daojishiLabel.attributedText = att;
    if (_time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        //订单变为已取消
        [LxmEventBus sendEvent:@"cancelSuccess" data:nil];
        [SVProgressHUD showErrorWithStatus:@"订单已经被取消!"];
        if (self.type == LxmPayVC_type_shengjigouwu) {
            [self popvc];
        } else if(self.type == LxmPayVC_type_yjbh) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LxmBuHuoOrderVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
                if ([vc isKindOfClass:[LxmDingDanMessageVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)popvc {
//    BOOL isJump = NO;
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[LxmShopVC class]]) {
//            isJump = YES;
//            [self.navigationController popToViewController:vc animated:YES];
//            break;
//        }
//    }
//    if (!isJump) {
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

/**
 支付 9100
 */
- (void)payButtonClick {
    if (self.type == LxmPayVC_type_jiaobaozhengjin) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"token"] = SESSION_TOKEN;
        dic[@"role_type"] = self.shengjiModel.roleType;
        dic[@"pay_type"] = self.currentIndex == 0 ? @3 : @(self.currentIndex);
        if (self.recommend_code.isValid) {
            dic[@"recommend_code"] = self.recommend_code;
        }
      
        [SVProgressHUD show];
        
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:role_deposit_pay parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"保证金已缴纳!"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (selfWeak.isBuJiao) {
                            [selfWeak loadMyUserInfoWithOkBlock:^{
                                [selfWeak.navigationController popToRootViewControllerAnimated:YES];
                            }];
                        } else {
                            [selfWeak loadMyUserInfoWithOkBlock:nil];
                            LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                            vc.model = self.shengjiModel;
                            [selfWeak.navigationController pushViewController:vc animated:YES];
                        }
                    });
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
               
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    } else if (self.type == LxmPayVC_type_bujiaobaozhengjin) {
        NSDictionary *dic = @{
                              @"token" : SESSION_TOKEN,
                              @"pay_type" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                              };
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:more_deposit parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [selfWeak loadMyUserInfoWithOkBlock:^{
                            [selfWeak.navigationController popViewControllerAnimated:YES];
                        }];
                    });
                   
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    }  else if (self.type == LxmPayVC_type_gwcJieSuan) {
        NSDictionary *dic = @{
                              @"token" : SESSION_TOKEN,
                              @"orderId" : self.orderModel.orderId,
                              @"payType" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                              };
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:pay_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [selfWeak.navigationController popToRootViewControllerAnimated:YES];
                    });
                    
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else if ([responseObject[@"key"] integerValue] == 9100){//库存不足 重新选货 等待支付
                LxmKuCunBuZuAletView *alertView = [[LxmKuCunBuZuAletView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                alertView.bottomClickBlock = ^(NSInteger index) {
                    [selfWeak alertViewClickAction:index];
                };
                [alertView show];
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    } else if (self.type == LxmPayVC_type_ddcx) {
        NSDictionary *dic = @{
                              @"token" : SESSION_TOKEN,
                              @"orderId" : self.orderID,
                              @"payType" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                              };
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:pay_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LxmEventBus sendEvent:@"shengjiBuyAction" data:nil];
                        if (selfWeak.isShengji) {
                            for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[LxmShengJiVC class]]) {
                                    [selfWeak.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        } else {
                             if (self.isDDcxDetail) {
                               for (UIViewController *vc in self.navigationController.viewControllers) {
                                   if ([vc isKindOfClass:[LxmOrderChaXunVC class]]) {
                                       [self.navigationController popToViewController:vc animated:NO];
                                       break;
                                   }
                               }
                           } else {
                               [self.navigationController popViewControllerAnimated:YES];
                           }
                        }
                    });
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else if ([responseObject[@"key"] integerValue] == 9100){//库存不足 重新选货 等待支付
                LxmKuCunBuZuAletView *alertView = [[LxmKuCunBuZuAletView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                alertView.bottomClickBlock = ^(NSInteger index) {
                    [selfWeak alertViewClickAction:index];
                };
                [alertView show];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    } else if (self.type == LxmPayVC_type_wfbd) {
        NSDictionary *dic = @{
                              @"token" : SESSION_TOKEN,
                              @"id" : self.wfbdID,
                              @"pay_type" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                              };
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:pay_service_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LxmEventBus sendEvent:@"danzifabusuccess" data:nil];
                        for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[LxmJieDanPlatTabbarController class]]) {
                                [selfWeak.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    });
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    }  else if (self.type == LxmPayVC_type_yjbh) {
        if (self.currentIndex == 0) {
            if ([LxmTool ShareTool].userModel.balance.doubleValue < self.buhuoModel.price.doubleValue) {
                [SVProgressHUD showErrorWithStatus:@"余额不足,请选择其他支付方式!"];
                return;
            }
        }
        NSDictionary *dic = @{
                              @"token" : SESSION_TOKEN,
                              @"id" : self.buhuoModel.orderId,
                              @"pay_type" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                              };
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:do_pay_back_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [selfWeak loadMyUserInfoWithOkBlock:nil];
                    for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LxmBuHuoOrderVC class]]) {
                            [selfWeak.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                        if ([vc isKindOfClass:[LxmDingDanMessageVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else if ([responseObject[@"key"] integerValue] == 9100){//库存不足 重新选货 等待支付
                LxmKuCunBuZuAletView *alertView = [[LxmKuCunBuZuAletView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                alertView.bottomClickBlock = ^(NSInteger index) {
                    [selfWeak alertViewClickAction:index];
                };
                [alertView show];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    } else if (self.type == LxmPayVC_type_jiajia) {
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:pay_more parameters:@{@"token":SESSION_TOKEN,@"id":self.jiajiaModel.id,@"morePay":self.jiajiaPrice,@"pay_type" : self.currentIndex == 0 ? @3 : @(self.currentIndex)} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"已加价!"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    } else if (self.type == LxmPayVC_type_shengjigouwu) {
        NSDictionary *dic = nil;
        if (self.shengjiGouwuModel.orderId) {
            dic = @{
                                  @"token" : SESSION_TOKEN,
                                  @"orderId" : self.shengjiGouwuModel.orderId,
                                  @"payType" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                                  };
        } else if(self.orderID) {
            dic = @{
                                  @"token" : SESSION_TOKEN,
                                  @"orderId" : self.orderID,
                                  @"payType" : self.currentIndex == 0 ? @3 : @(self.currentIndex)
                                  };
        } else {
            return;
        }
        
        [SVProgressHUD show];
        WeakObj(self);
        selfWeak.payButton.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:pay_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.payButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                if (selfWeak.currentIndex == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [selfWeak popvc];
                    });
                } else if (selfWeak.currentIndex == 1) {//支付宝
                    NSString *payStr = responseObject[@"result"][@"data"];
                    if (payStr.isValid) {
                        [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                    }
                } else if (selfWeak.currentIndex == 2) {//微信
                    NSDictionary * dict = responseObject[@"result"][@"map"];
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }
                
            } else if ([responseObject[@"key"] integerValue] == 9100){//库存不足 重新选货 等待支付
                LxmKuCunBuZuAletView *alertView = [[LxmKuCunBuZuAletView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                alertView.bottomClickBlock = ^(NSInteger index) {
                    [selfWeak alertViewClickAction:index];
                };
                [alertView show];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.payButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
    }
}



- (void)zhiFuBaoNoti:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"取消支付"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        if (self.type == LxmPayVC_type_jiaobaozhengjin) {
            if (self.isBuJiao) {
                [self loadMyUserInfoWithOkBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                [self loadMyUserInfoWithOkBlock:nil];
                LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                vc.model = self.shengjiModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (self.type == LxmPayVC_type_bujiaobaozhengjin){
            [self loadMyUserInfoWithOkBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if (self.type == LxmPayVC_type_gwcJieSuan) {
           [self.navigationController popToRootViewControllerAnimated:YES];
        } else if (self.type == LxmPayVC_type_ddcx) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"shengjiBuyAction" data:nil];
                if (self.isShengji) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LxmShengJiVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                } else {
                    if (self.isDDcxDetail) {
                       for (UIViewController *vc in self.navigationController.viewControllers) {
                           if ([vc isKindOfClass:[LxmOrderChaXunVC class]]) {
                               [self.navigationController popToViewController:vc animated:NO];
                               break;
                           }
                       }
                   } else {
                       [self.navigationController popViewControllerAnimated:YES];
                   }
                }
            });
        } else if (self.type == LxmPayVC_type_wfbd) {
            //商品直接购买不要了
            WeakObj(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"danzifabusuccess" data:nil];
                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LxmJieDanPlatTabbarController class]]) {
                        [selfWeak.navigationController popToViewController:vc animated:YES];
                    }
                }
            });
        } else if (self.type == LxmPayVC_type_yjbh) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LxmBuHuoOrderVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
                if ([vc isKindOfClass:[LxmDingDanMessageVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        } else if (self.type == LxmPayVC_type_jiajia) {
            [SVProgressHUD showSuccessWithStatus:@"已加价!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else if (self.type == LxmPayVC_type_shengjigouwu) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            [self popvc];
        } else{
           
        }
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

- (void)wechatPayNoti:(NSNotification *)noti{
    BaseResp * resp = noti.object;
    if (resp.errCode==WXSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        if (self.type == LxmPayVC_type_jiaobaozhengjin) {
            if (self.isBuJiao) {
                [self loadMyUserInfoWithOkBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                [self loadMyUserInfoWithOkBlock:nil];
                LxmWanShanInfoVC *vc = [[LxmWanShanInfoVC alloc] init];
                vc.model = self.shengjiModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (self.type == LxmPayVC_type_bujiaobaozhengjin){
            [self loadMyUserInfoWithOkBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if (self.type == LxmPayVC_type_gwcJieSuan) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else if (self.type == LxmPayVC_type_ddcx) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"shengjiBuyAction" data:nil];
                if (self.isShengji) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LxmShengJiVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                } else {
                    if (self.isDDcxDetail) {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[LxmOrderChaXunVC class]]) {
                                [self.navigationController popToViewController:vc animated:NO];
                                break;
                            }
                        }
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            });
        } else if (self.type == LxmPayVC_type_wfbd) {
            WeakObj(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"danzifabusuccess" data:nil];
                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LxmJieDanPlatTabbarController class]]) {
                        [selfWeak.navigationController popToViewController:vc animated:YES];
                    }
                }
            });
        } else if (self.type == LxmPayVC_type_yjbh) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LxmBuHuoOrderVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
                if ([vc isKindOfClass:[LxmDingDanMessageVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        } else if (self.type == LxmPayVC_type_jiajia) {
            [SVProgressHUD showSuccessWithStatus:@"已加价!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else if (self.type == LxmPayVC_type_shengjigouwu) {
            [LxmEventBus sendEvent:@"jiesuanSuccess" data:nil];
            [self popvc];
        } else{
            
        }
    } else if (resp.errCode==WXErrCodeUserCancel) {
        [SVProgressHUD showErrorWithStatus:@"用户取消了支付"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

/**
 库存不足弹窗

 @param index 600 重新选货 601等待库存
 */
- (void)alertViewClickAction:(NSInteger)index {
    if (index == 600) {//调用 取消订单接口 返回购进商品页
        [self tuidan];
    } else if (index == 601) {//601等待库存
        [self pageto];
    }
}

/**
 申请退单
 */
- (void)tuidan {
    NSString *orderId = nil;
    NSString *str = @"";
    if (self.type == LxmPayVC_type_gwcJieSuan) {//self.orderModel.orderId
        orderId = self.orderModel.orderId;
        str = return_send_order;
    } else if (self.type == LxmPayVC_type_ddcx) {//self.orderID
        orderId = self.orderID;
        str = return_send_order;
    } else if (self.type == LxmPayVC_type_yjbh) {//self.buhuoModel.orderId
        orderId = self.buhuoModel.orderId;
        str = return_buy_order;
    }
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:str parameters:@{@"token":SESSION_TOKEN,@"id":orderId} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [selfWeak pageto];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//页面跳转
- (void)pageto {
    if (self.type == LxmPayVC_type_gwcJieSuan) {//self.orderModel.orderId
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (self.type == LxmPayVC_type_ddcx) {//self.orderID
        if (self.isShengji) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LxmShengJiVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        } else {
             if (self.isDDcxDetail) {
               for (UIViewController *vc in self.navigationController.viewControllers) {
                   if ([vc isKindOfClass:[LxmOrderChaXunVC class]]) {
                       [self.navigationController popToViewController:vc animated:NO];
                       break;
                   }
                }
               } else {
                   [self.navigationController popViewControllerAnimated:YES];
               }
        }
    } else if (self.type == LxmPayVC_type_yjbh) {//self.buhuoModel.orderId
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LxmBuHuoOrderVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
            if ([vc isKindOfClass:[LxmDingDanMessageVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}

@end
