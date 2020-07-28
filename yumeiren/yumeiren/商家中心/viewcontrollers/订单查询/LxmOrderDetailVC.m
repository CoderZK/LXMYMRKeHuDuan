//
//  LxmOrderDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmOrderDetailVC.h"
#import "LxmJieSuanView.h"
#import "LxmSubBuHuoOrderVC.h"
#import "LxmPayVC.h"
#import "LxmShengJiVC.h"

@interface LxmOrderDetailVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmShopCenterOrderDetailModel *detailModel;

@property (nonatomic, assign) CGFloat lingshiTotalPrice;/* 商品零售总价 */

@property (nonatomic, assign) CGFloat shangpinTotalPrice;/* 商品总价 */

@property (nonatomic, assign) NSInteger count;//商品件数

@property (nonatomic, strong) LxmOrderDetailBottomView *bottomView;//底部操作按钮

//倒计时
@property (nonatomic , strong)NSTimer * timer;

@property (nonatomic , assign)int time;

@property (nonatomic, strong) UITableViewCell *timeCell;//倒计时cell

//9是待补货，10是待支付，11是已完成，12已过期

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderGoodsModel *> *xiajiGoodsArr;

@end

@implementation LxmOrderDetailVC

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmOrderDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmOrderDetailBottomView alloc] init];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [UIColor whiteColor];
        WeakObj(self);
        [_bottomView.leftButton setTitle:@"申请退单" forState:UIControlStateNormal];
        [_bottomView.leftButton addTarget:selfWeak action:@selector(shenqingTuiHuoClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.gotobuhuoBlock = ^{
            [selfWeak BottomButtonAction];
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"订单详情";
    [self initSubviews];
    [self loadDetailData];
    self.xiajiGoodsArr = [NSMutableArray array];
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
    if (self.isHiddenBottom) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.leading.bottom.trailing.equalTo(self.view);
        }];
    } else {
        [self.view addSubview:self.bottomView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self.view);
            make.height.equalTo(@(TableViewBottomSpace + 60));
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.detailModel.map.sub.count + self.detailModel.map.sends.count;
    } else if (section == 2) {
        return self.xiajiGoodsArr.count;
    } else if (section == 3) {
        return 6;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeCell = cell;
        cell.backgroundColor = MainColor;
        cell.textLabel.textColor = UIColor.whiteColor;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row >= self.detailModel.map.sub.count) {
            LxmAcGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAcGoodsCell"];
            if (!cell) {
                cell = [[LxmAcGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAcGoodsCell"];
            }
            cell.detailGoodsModel = self.detailModel.map.sends[indexPath.row - self.detailModel.map.sub.count];
            return cell;
        } else {
            LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
            if (!cell) {
                cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
            }
            if ([self.detailModel.map.no_vip isEqualToString:@"2"]) {
                cell.isHaoCai = YES;
            }else {
                cell.isHaoCai = NO;
            }
            cell.orderDetailGoodsModel = self.detailModel.map.sub[indexPath.row];
            return cell;
        }
    } else if (indexPath.section == 2) {
        LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        }
        if ([self.detailModel.map.no_vip isEqualToString:@"2"]) {
            cell.isHaoCai = YES;
        }else {
            cell.isHaoCai = NO;
        }
        cell.orderDetailGoodsModel = self.xiajiGoodsArr[indexPath.row];
        return cell;
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            LxmNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNoteCell"];
            if (!cell) {
                cell = [[LxmNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNoteCell"];
            }
            cell.titleLabel.text = @"备注";
            cell.detailLabel.text = self.detailModel.map.order_info;
            return cell;
        } else if (indexPath.row == 5) {
            LxmSubBuHuoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderPriceCell"];
            if (!cell) {
                cell = [[LxmSubBuHuoOrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderPriceCell"];
            }
            cell.shifujineMoney = [NSString stringWithFormat:@"%lf",self.shangpinTotalPrice];
            return cell;
        }
        LxmJieSuanPeiSongInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        }
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"商品件数";
            cell.detailLabel.textColor = CharacterDarkColor;
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld件",(long)self.count];
        } else if (indexPath.row == 2){
            cell.titleLabel.text = @"商品零售总价";
            cell.detailLabel.textColor = CharacterDarkColor;
            CGFloat f = self.lingshiTotalPrice;
            NSInteger d = self.lingshiTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",(long)d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 3){
            cell.titleLabel.text = @"商品总额";
            cell.detailLabel.textColor = MainColor;
            CGFloat f = self.shangpinTotalPrice;
            NSInteger d = self.shangpinTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",(long)d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 4){
            cell.titleLabel.text = @"运费";
            cell.detailLabel.textColor = MainColor;
            if (LxmTool.ShareTool.userModel.postMoney.intValue == 0) {
                cell.detailLabel.text = @"物流发货";
            } else {
                cell.detailLabel.text = [NSString stringWithFormat:@"满%@包邮或者到付",LxmTool.ShareTool.userModel.postMoney];
            }
        }
        return cell;
    } else {
        LxmJieSuanPeiSongInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"订单编号";
            cell.detailLabel.text = self.detailModel.map.order_code;
        } else {
            cell.titleLabel.text = @"下单时间";
            NSString *time = self.detailModel.map.create_time;
            if (time.length > 10) {
                cell.detailLabel.text = [time substringToIndex:10].getIntervalToZHXLongTime;
            } else {
                cell.detailLabel.text = time.getIntervalToZHXLongTime;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.bottomView.model.status.intValue == 1 || self.bottomView.model.status.intValue == 10 || self.bottomView.model.status.intValue == -11) {
            return 80;
        }
        return 0.01;
    }
    if (indexPath.section == 1) {
        return 120;
    }
    if (indexPath.section == 2) {
        return 120;
    }
    if (indexPath.section == 3 && indexPath.row == 4) {
        if (self.detailModel.map.postage_type.intValue == 1) {
            return 0.001;
        }
        if (self.iscaiGouandXiaoshou) {
            return 0.001;
        }
        return 50;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        if (self.detailModel.map.order_info.isValid) {
            return self.detailModel.map.orderHeight > 50 ? self.detailModel.map.orderHeight : 50;
        }
        return 0.01;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 0.01;
    }
    return 10;
}

/**
 订单详情
 */
- (void)loadDetailData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:good_order_detail parameters:@{@"token":SESSION_TOKEN,@"id":self.orderID} returnClass:LxmShopCenterOrderDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            _bottomView.hidden = NO;
            selfWeak.detailModel = responseObject.result;
            selfWeak.lingshiTotalPrice = 0;
            selfWeak.shangpinTotalPrice = 0;
            [selfWeak.xiajiGoodsArr removeAllObjects];
            for (LxmShopCenterOrderModel *orders in selfWeak.detailModel.map.orders) {
                for (LxmShopCenterOrderGoodsModel *goods in orders.sub) {
                    [selfWeak.xiajiGoodsArr addObject:goods];
                }
            }
            
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObjectsFromArray:selfWeak.detailModel.map.sub];
            [tempArr addObjectsFromArray:selfWeak.xiajiGoodsArr];
            for (LxmShopCenterOrderGoodsModel *goods in tempArr) {
                selfWeak.count += goods.num.integerValue;
                selfWeak.lingshiTotalPrice += goods.good_price.doubleValue * goods.num.intValue;
                selfWeak.shangpinTotalPrice += goods.proxy_price.doubleValue * goods.num.intValue;
            }
            if (selfWeak.isShengji) {
                selfWeak.bottomView.leftButton.hidden = NO;
                LxmShopCenterOrderModel *m = [LxmShopCenterOrderModel new];
                m.status = @"-11";
                selfWeak.bottomView.model = m;
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(TableViewBottomSpace + 60));
                }];
            } else {
                selfWeak.bottomView.model = selfWeak.detailModel.map;
                NSInteger status = selfWeak.detailModel.map.status.intValue;
                if (status == 1 || status == 2 || status == 3) {
                    if (status == 1) {
                         selfWeak.bottomView.leftButton.hidden = NO;
                    }
                    [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(TableViewBottomSpace + 60));
                    }];
                } else {
                    [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                }
            }
            
            if (selfWeak.bottomView.model.status.intValue == 1 || selfWeak.bottomView.model.status.intValue == 10 ||selfWeak.bottomView.model.status.intValue == -11) {
                
                NSString *time = selfWeak.detailModel.map.create_time;
                if (time.length > 10) {
                    time = [time substringToIndex:10];
                }

                double chaTime = [NSString chaWithCreateTime:time];
//                double chaTime = [NSString chaWithCreateTime:@"1568943799"];
                if (chaTime < 0) {
                    //已取消的订单
                    selfWeak.timeCell.textLabel.text = @"订单已被取消!";
                   
                } else {
                    [self.timer invalidate];
                    self.timer = nil;
                    self.time = chaTime;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer1) userInfo:nil repeats:YES];
                    [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
                    [self.timer fire];
                    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.leading.trailing.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                }
                
            } else {
                [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.trailing.equalTo(self.view);
                    make.height.equalTo(@1);
                }];
                [self.timer invalidate];
                self.timer = nil;
            }
            [selfWeak.view layoutIfNeeded];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}





-(void)onTimer1 {
    NSString *timeStr = [NSString durationTimeStringWithDuration:_time--];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"请在" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:timeStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"内完成付款,否则订单会被系统取消" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [att appendAttributedString:str1];
    [att appendAttributedString:str2];
    self.timeCell.textLabel.attributedText = att;
    if (_time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        //订单变为已取消
        [LxmEventBus sendEvent:@"cancelSuccess" data:nil];
        [SVProgressHUD showErrorWithStatus:@"订单已经被取消!"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 底部操作按钮事件
 */
- (void)BottomButtonAction {
    if (self.isShengji) {
        //去支付
        if (self.time <= 0) {
            [SVProgressHUD showErrorWithStatus:@"订单已被取消!"];
            return;
        }
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_shengjigouwu];
        vc.creatTime = self.detailModel.map.create_time;
        vc.orderID = self.orderID;
        vc.isShengji = YES;
        vc.shifuMoney = @(self.shangpinTotalPrice).stringValue;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSInteger status = self.detailModel.map.status.intValue;
        if (status == 1) {//去支付
            if (self.time <= 0) {
                [SVProgressHUD showErrorWithStatus:@"订单已被取消!"];
                return;
            }
            LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_ddcx];
            
            vc.isDDcxDetail = YES;
            vc.orderID = self.detailModel.map.id;
            vc.shifuMoney = @(self.shangpinTotalPrice).stringValue;
            [self.navigationController pushViewController:vc animated:YES];
          
        } else if (status == 2) {//申请退单
            [self shenqingTuidan];
        } else if (status == 3) {//确认收货
            [self sureshouhuo];
        } else if (status == 7) {//确认自提
            
        }
    }
}
//无身份升级时  退货
- (void)shenqingTuiHuoClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    if (self.isShengji) {
        dict[@"id"] = self.orderID;
    } else {
         dict[@"id"] = self.detailModel.map.id;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:return_buy_order parameters:dict returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            
            [SVProgressHUD showSuccessWithStatus:@"已退货"];
            if (self.isShengji) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LxmEventBus sendEvent:@"shengjiBuyAction" data:nil];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LxmShengJiVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LxmEventBus sendEvent:@"tuihuoSuccess" data:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



- (void)sureshouhuo {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:confirm_send_order parameters:@{@"token":SESSION_TOKEN,@"id":self.detailModel.map.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [LxmEventBus sendEvent:@"detailBottomAction" data:nil];
            [SVProgressHUD showSuccessWithStatus:@"已确认收货!"];
            selfWeak.detailModel.map.status = @"4";
            [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(TableViewBottomSpace + 60));
            }];
            [selfWeak.view layoutIfNeeded];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


/**
 申请退单
 */
- (void)shenqingTuidan {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要申请退单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    WeakObj(self);
    [alertView addAction:[UIAlertAction actionWithTitle:@"申请退单" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak tuidan];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)tuidan {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:return_send_order parameters:@{@"token":SESSION_TOKEN,@"id":self.detailModel.map.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [LxmEventBus sendEvent:@"detailBottomAction" data:nil];
            [SVProgressHUD showSuccessWithStatus:@"已提交退单申请!"];
            selfWeak.detailModel.map.status = @"5";
            [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
            [selfWeak.view layoutIfNeeded];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD dismiss];
    }];
}


@end

/**
 商品详情 底部操作按钮
 */
@interface LxmOrderDetailBottomView ()

@property (nonatomic, strong) UIButton *buhuoButton;

@end

@implementation LxmOrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.buhuoButton];
        [self addSubview:self.leftButton];
        [self.buhuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.buhuoButton.mas_leading).offset(-15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
    }
    return self;
}

- (UIButton *)buhuoButton {
    if (!_buhuoButton) {
        _buhuoButton = [UIButton new];
        [_buhuoButton setTitle:@"去补货" forState:UIControlStateNormal];
        [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
        _buhuoButton.layer.borderColor = MainColor.CGColor;
        
        _buhuoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _buhuoButton.layer.cornerRadius = 15;
        _buhuoButton.layer.borderWidth = 0.5;
        _buhuoButton.layer.masksToBounds = YES;
        [_buhuoButton addTarget:self action:@selector(buhuoclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buhuoButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        _leftButton.hidden = YES;
        [_leftButton setTitle:@"申请退单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _leftButton.layer.borderColor = CharacterGrayColor.CGColor;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _leftButton.layer.cornerRadius = 15;
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.masksToBounds = YES;
        [_leftButton addTarget:self action:@selector(tuidanclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}


- (void)buhuoclick {
    if (self.gotobuhuoBlock) {
        self.gotobuhuoBlock();
    }
}

- (void)tuidanclick {
    if (self.tuidanBlock) {
        self.tuidanBlock();
    }
}

- (void)setModel:(LxmShopCenterOrderModel *)model {
    _model = model;
    switch (_model.status.intValue) {
        case 1: {//待支付
            [_buhuoButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 2: {//待发货
            [_buhuoButton setTitle:@"申请退单" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = CharacterGrayColor.CGColor;
        }
            break;
        case 3: {//待补货
            [_buhuoButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 7: {//待自提
            [_buhuoButton setTitle:@"确认自提" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 8: {//已自提
            [_buhuoButton setTitle:@"已自提" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 9: {//待补货
            [_buhuoButton setTitle:@"待补货" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 10: {//待支付
            _leftButton.hidden = NO;
            [_buhuoButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 12: {//已过期
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"删除" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = CharacterGrayColor.CGColor;
        }
            break;
        case -11: {//待支付
            _leftButton.hidden = NO;
            [_buhuoButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
            
        default:
            break;
    }
}

@end
