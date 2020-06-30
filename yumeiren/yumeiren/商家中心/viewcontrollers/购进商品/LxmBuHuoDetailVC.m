//
//  LxmBuHuoDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmBuHuoDetailVC.h"
#import "LxmOrderDetailVC.h"
#import "LxmYiJianBuHuoVC.h"
#import "LxmYiJianBuHuoVC1.h"
#import "LxmSubOrderChaXunVC.h"
#import "LxmJieSuanView.h"
#import "LxmSubBuHuoOrderVC.h"
#import "LxmWuLiuInfoVC.h"
#import "LxmOrderDetailVC.h"
#import "LxmGoodsDetailVC.h"
#import "LxmPayVC.h"

@interface LxmBuHuoDetailVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmOrderDetailBottomView *bottomView;//底部操作按钮

@property (nonatomic, assign) CGFloat lingshiTotalPrice;/* 商品零售总价 */

@property (nonatomic, assign) CGFloat shangpinTotalPrice;/* 商品总价 */

@property (nonatomic, assign) NSInteger count;//商品件数

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*dataArr;

@property (nonatomic, strong) LxmBuhuoDetailRootModel *rootModel;
//倒计时
@property (nonatomic , strong)NSTimer * timer;

@property (nonatomic , assign)int time;

@property (nonatomic, strong) UITableViewCell *timeCell;//倒计时cell

@end

@implementation LxmBuHuoDetailVC

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
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
        _bottomView.backgroundColor = [UIColor whiteColor];
        WeakObj(self);
        _bottomView.gotobuhuoBlock = ^{
            [selfWeak buttonAction:selfWeak.rootModel.result.map];
        };
        _bottomView.tuidanBlock = ^{
            [selfWeak tuidanBottomButtonAction];
        };
    }
    return _bottomView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"补货订单详情";
    [self initSubviews];
    [self loadDetailData];
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
    return self.dataArr.count + 1 + 2 + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else if (section == self.dataArr.count + 1 + 2 + 1 -1) {//最后一区
        return 2;
    } else if (section == self.dataArr.count + 1 + 2 + 1 -2) {
        return 5;
    } else {
        return self.dataArr[section - 2].sub.count + 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeCell = cell;
        cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:182/255.0 blue:191/255.0 alpha:1];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    } else if (indexPath.section == 1) {
        LxmYiJianBuHuoDanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoDanCell"];
        if (!cell) {
            cell = [[LxmYiJianBuHuoDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoDanCell"];
        }
        cell.isHaveSelect = YES;
        return cell;
    }  else if (indexPath.section == self.dataArr.count + 1 + 2 + 1 -1) {//最后一区
        LxmJieSuanPeiSongInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"订单编号";
            cell.detailLabel.text = self.rootModel.result.map.order_code;
        } else {
            cell.titleLabel.text = @"下单时间";
            if (self.rootModel.result.map.create_time.length > 10) {
                cell.detailLabel.text = [[self.rootModel.result.map.create_time substringToIndex:10] getIntervalToZHXLongTime];
            } else {
                cell.detailLabel.text = [self.rootModel.result.map.create_time getIntervalToZHXLongTime];
            }
        }
        return cell;
    } else if (indexPath.section == self.dataArr.count + 1 + 2 + 1 -2) {
        if (indexPath.row == 4) {
            LxmSubBuHuoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderPriceCell"];
            if (!cell) {
                cell = [[LxmSubBuHuoOrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderPriceCell"];
            }
            cell.isDaiBuHuo = self.rootModel.result.map.status.integerValue == 9;
            cell.shifujineMoney = [NSString stringWithFormat:@"%lf",self.shangpinTotalPrice];
            return cell;
        }
        LxmJieSuanPeiSongInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"商品件数";
            cell.detailLabel.textColor = CharacterDarkColor;
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld件",(long)self.count];
        } else if (indexPath.row == 1){
            cell.titleLabel.text = @"商品零售总价";
            cell.detailLabel.textColor = CharacterDarkColor;
            CGFloat f = self.lingshiTotalPrice;
            NSInteger d = self.lingshiTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",(long)d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 2){
            cell.titleLabel.text = @"商品总额";
            cell.detailLabel.textColor = MainColor;
            CGFloat f = self.shangpinTotalPrice;
            NSInteger d = self.shangpinTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",(long)d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 3){
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
        if (indexPath.row == 0) {
            LxmYiJianBuHuoOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoOrderCell"];
            if (!cell) {
                cell = [[LxmYiJianBuHuoOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoOrderCell"];
            }
            cell.isHaveSelect = YES;
            cell.orderModel = self.dataArr[indexPath.section - 2];
            return cell;
        } else if (indexPath.row == 1) {
            LxmYiJianBuHuoRenOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoRenOrderCell"];
            if (!cell) {
                cell = [[LxmYiJianBuHuoRenOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoRenOrderCell"];
            }
            cell.orderModel = self.dataArr[indexPath.section - 2];
            return cell;
        } else {
            LxmYiJianBuHuoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoGoodsCell"];
            if (!cell) {
                cell = [[LxmYiJianBuHuoGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoGoodsCell"];
            }
            cell.isHaveSelect = YES;
            cell.orderModel = self.dataArr[indexPath.section - 2].sub[indexPath.row - 2];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.bottomView.model.status.intValue == 1 || self.bottomView.model.status.intValue == 10 || self.bottomView.model.status.intValue == -11) {
            return 80;
        }
        return 0.01;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == self.dataArr.count + 1 + 2 + 1 -1) {//最后一区
        return 50;
    } else if (indexPath.section == self.dataArr.count + 1 + 2 + 1 -2) {
        if (indexPath.row == 3) {
            return 0.01;
        }
        return 50;
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row == 1) {
            if (self.rootModel.result.map.status.intValue == 9) {
                return 0.01;
            }
            return 40;
        }
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == self.dataArr.count + 1 + 2 + 1 -1) {//最后一区
        return 10;
    } else if (section == self.dataArr.count + 1 + 2 + 1 -2) {
        return 10;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//全选
        
    } else {
        if (indexPath.row == 0) {//单选
           
        } else {//商品
           
        }
    }
}

/**
 获取补货订单详情
 */
- (void)loadDetailData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:good_order_detail parameters:@{@"token":SESSION_TOKEN,@"id":self.orderID} returnClass:LxmBuhuoDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmBuhuoDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.rootModel = responseObject;
            selfWeak.bottomView.model = responseObject.result.map;
            [selfWeak.dataArr removeAllObjects];
            NSMutableArray *tempArr1 = [NSMutableArray array];
            if (responseObject.result.map.orders.count > 0) {
                for (LxmShopCenterOrderModel *m in responseObject.result.map.orders) {
                    [tempArr1 addObject:m];
                }
            }
            if (responseObject.result.map) {
                LxmShopCenterOrderModel *m = responseObject.result.map;
                m.isShiFu = YES;
                [tempArr1 addObject:m];
            }
            selfWeak.dataArr = tempArr1;
            
            NSInteger status = selfWeak.rootModel.result.map.status.intValue;
            if (status == 9 || status == 10) {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(TableViewBottomSpace + 60));
                }];
            } else {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
            
            selfWeak.lingshiTotalPrice = 0;
            selfWeak.shangpinTotalPrice = 0;
            for (LxmShopCenterOrderModel *goods in selfWeak.dataArr) {
                if (goods.isShiFu) {
                    for (LxmShopCenterOrderGoodsModel *m in goods.sub) {
                        selfWeak.count += m.num.intValue;
                        selfWeak.lingshiTotalPrice += m.good_price.doubleValue * m.num.intValue;
                        selfWeak.shangpinTotalPrice += m.proxy_price.doubleValue * m.num.intValue;
                    }
                }
            }
            if (selfWeak.bottomView.model.status.intValue == 1 || selfWeak.bottomView.model.status.intValue == 10 ||selfWeak.bottomView.model.status.intValue == -11) {
                
                NSString *time = responseObject.result.map.create_time;
                if (time.length > 10) {
                    time = [time substringToIndex:10];
                }
                
                double chaTime = [NSString chaWithCreateTime:time];
//                double chaTime = [NSString chaWithCreateTime:@"1568947446"];
                if (chaTime < 0) {
                    //已取消的订单
                    selfWeak.timeCell.textLabel.text = @"订单已被取消!";
                } else {
                    [selfWeak.timer invalidate];
                    selfWeak.timer = nil;
                    selfWeak.time = chaTime;
                    selfWeak.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer1) userInfo:nil repeats:YES];
                    [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
                    [selfWeak.timer fire];
                    [selfWeak.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.leading.trailing.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                }
                
            } else {
                [selfWeak.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.trailing.equalTo(self.view);
                    make.height.equalTo(@1);
                }];
                [selfWeak.timer invalidate];
                selfWeak.timer = nil;
            }
            [selfWeak.view layoutIfNeeded];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.key];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)onTimer1 {
    NSString *timeStr = [NSString durationTimeStringWithDuration:_time--];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"请在" attributes:@{NSForegroundColorAttributeName:CharacterGrayColor}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:timeStr attributes:@{NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"内完成付款,否则订单会被系统取消" attributes:@{NSForegroundColorAttributeName:CharacterGrayColor}];
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
 9-待补货，10-补货待支付
 */
- (void)buttonAction:(LxmShopCenterOrderModel *)model {
    if (model.status.intValue == 9) {
        LxmYiJianBuHuoVC1 *vc = [[LxmYiJianBuHuoVC1 alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.status.intValue == 10) {
        if (self.time <= 0) {
            [SVProgressHUD showErrorWithStatus:@"订单已经被取消!"];
            return;
        }
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_yjbh];
        vc.creatTime = self.rootModel.result.map.create_time;
        LxmBuHuoModel *model = [LxmBuHuoModel new];
        model.price = [NSString stringWithFormat:@"%lf",self.shangpinTotalPrice];
        model.orderId = self.orderID;
        vc.buhuoModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.status.intValue == 12) {
//        [self deleteModel];
    }
}

/**
 申请退单
*/
- (void)tuidanBottomButtonAction {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认退单" message:@"您确定要申请退单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self tuidan];
    }]];
    [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)tuidan {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:return_bu_order parameters:@{@"token":SESSION_TOKEN,@"id":self.rootModel.result.map.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已提交退单申请!"];
            [LxmEventBus sendEvent:@"yitijianbuhuotuidanshenqing" data:nil];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
12删除已过期订单
*/
- (void)deleteModel {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认订单" message:@"您确定要删除已过期订单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteOrder];
    }]];
    [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)deleteOrder {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:log_del_order parameters:@{@"token":SESSION_TOKEN,@"id":self.orderID} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除"];
            [LxmEventBus sendEvent:@"yitijianbuhuotuidanshenqing" data:nil];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end
