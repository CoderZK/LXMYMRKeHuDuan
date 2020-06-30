//
//  LxmJieDanMyPublishDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanMyPublishDetailVC.h"
#import "LxmJiedanMyPublishVC.h"
#import "LxmJiedanMyAcceptVC.h"
#import "LxmJieDanListViewController.h"
#import "LxmHomeModel.h"
#import "LxmJiaJiaAlertView.h"

#import "LxmPayVC.h"

@interface LxmJieDanMyPublishDetailVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmJieDanMyPublishDetailBottomView *bottomView;//底部确认发布view

@property (nonatomic, strong) LxmJieDanListModel *detailmodel;

@end

@implementation LxmJieDanMyPublishDetailVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmJieDanMyPublishDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmJieDanMyPublishDetailBottomView alloc] init];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        WeakObj(self);
        _bottomView.bottomButtonActionBlock = ^(NSInteger index, LxmJieDanListModel *model) {
            [selfWeak bottomActionIndex:index currentModel:model];
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
    self.navigationItem.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initView];
    [self loadDetailData];
    /* 详情操作 */
    WeakObj(self);
    [LxmEventBus registerEvent:@"jiesuanSuccess" block:^(id data) {
        StrongObj(self);
        [self loadDetailData];
    }];
}

/**
 view添加子视图
 */
- (void)initView {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//订单编号
            LxmJieDanOrderBianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderBianHaoCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderBianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderBianHaoCell"];
            }
            cell.model = self.detailmodel;
            return cell;
        } else if (indexPath.row == 1) {
            LxmJieDanOrderServiceTypeAndMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderServiceTypeAndMoneyCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderServiceTypeAndMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderServiceTypeAndMoneyCell"];
            }
            cell.detailModel = self.detailmodel;
            return cell;
        } else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 8) {
            LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
            }
            if (indexPath.row == 2) {
                cell.titleLabel.text = @"时间区间:";
                if (self.detailmodel.beginTime.length > 10) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.detailmodel.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[self.detailmodel.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
                } else {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[self.detailmodel.beginTime getIntervalToFXXTNoHHmmime],[self.detailmodel.endTime getIntervalToFXXTNoHHmmime]];
                }
            } else if (indexPath.row == 3) {
                cell.titleLabel.text = @"服务时间:";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@天",self.detailmodel.serviceDay];
            } else if (indexPath.row == 4){
                NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.detailmodel.province,self.detailmodel.city,self.detailmodel.district,self.detailmodel.addressDetail];
                cell.titleLabel.text = @"服务地址:";
                cell.detailLabel.text = str;
            } else if (indexPath.row == 5) {
                cell.titleLabel.text = @"被服务人:";
                cell.detailLabel.text = self.detailmodel.username;
            } else if (indexPath.row == 6) {
                cell.titleLabel.text = @"联系电话:";
                cell.detailLabel.text = self.detailmodel.telephone;
            } else {
                cell.titleLabel.text = @"打分结果:";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@分",self.detailmodel.score];
            }
            return cell;
        } else if (indexPath.row == 7) {
            LxmJieDanMyAcceptCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyAcceptCenterCell"];
            if (!cell) {
                cell = [[LxmJieDanMyAcceptCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyAcceptCenterCell"];
            }
            cell.detailModel = self.detailmodel;
            return cell;
        } else {
            LxmJieDanListRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanListRenCell"];
            if (!cell) {
                cell = [[LxmJieDanListRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanListRenCell"];
            }
            cell.detailModel = self.detailmodel;
            return cell;
        }
    } else {
        if (self.detailmodel.status.intValue == 6) {//已完成
            LxmJieDanListRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanListRenCell"];
            if (!cell) {
                cell = [[LxmJieDanListRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanListRenCell"];
            }
            cell.detailModel = self.detailmodel;
            return cell;
        } else {
            LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
            }
            cell.detailModel = self.detailmodel;
            cell.titleLabel.text = @"加 价 至:";
            cell.detailLabel.textColor = MainColor;
            cell.detailLabel.font = [UIFont systemFontOfSize:18];
            CGFloat f = self.detailmodel.servicePrice.doubleValue + self.detailmodel.addPrice.doubleValue;
            NSInteger d = self.detailmodel.servicePrice.integerValue + self.detailmodel.addPrice.integerValue;
            if (f == d) {
                cell.detailLabel.text = [NSString stringWithFormat:@"￥%ld",d];
            } else {
                cell.detailLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row == 1) {
            return 30;
        } else if (indexPath.row == 2) {
            if (self.detailmodel.beginTime.length > 10) {
                NSString *str = [NSString stringWithFormat:@"%@-%@",[[self.detailmodel.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[self.detailmodel.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
                CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
                return h;
            } else {
                NSString *str = [NSString stringWithFormat:@"%@-%@",[self.detailmodel.beginTime getIntervalToFXXTNoHHmmime],[self.detailmodel.endTime getIntervalToFXXTNoHHmmime]];
                CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
                return h;
            }
        } else if (indexPath.row == 3) {
            CGFloat h = [[self.detailmodel.servicePrice stringByAppendingString:@"天"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 4) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.detailmodel.province,self.detailmodel.city,self.detailmodel.district,self.detailmodel.addressDetail];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 5) {
            CGFloat h = [self.detailmodel.username getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 6) {
            CGFloat h = [self.detailmodel.telephone  getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
            return h;
        } else if (indexPath.row == 7) {
            if (self.detailmodel.backPic.isValid) {//待打分 已评价
                NSArray *temp = [self.detailmodel.backPic componentsSeparatedByString:@","];
                CGFloat width = floor((ScreenW - 110 - 10) / 3.0);
                CGFloat hhh = ceil(temp.count/3.0);
                return width * hhh + 15;
            } else {
                return 0.01;
            }
        } else if (indexPath.row == 8) {
            if (self.detailmodel.score.isValid && self.detailmodel.score.doubleValue != 0 ) {
                CGFloat h = [[self.detailmodel.score stringByAppendingString:@"分"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
                return h;
            }
            return 0.01;
        } else {
            // 1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
            if (self.detailmodel.status.intValue == 3 || self.detailmodel.status.intValue == 4 || self.detailmodel.status.intValue == 5 ||  self.detailmodel.status.intValue == 7 ||  self.detailmodel.status.intValue == 8) {
                return 80;
            } else {
                return 0.001;
            }
        }
    } else {
        if (self.detailmodel.status.intValue == 6) {//已完成
            return 80;
        } else {
            if (self.detailmodel.status.intValue == 2 && self.detailmodel.status.doubleValue != 0) {
                return 44;
            }
            return 0.01;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

/**
 获取订单详情
 */
- (void)loadDetailData {
   
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"type" : @1,
                           @"id" : self.model.id
                           };
    if (!self.detailmodel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:order_detail parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        _bottomView.hidden = NO;
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.detailmodel = [LxmJieDanListModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
            if (selfWeak.detailmodel.status.intValue == 1 || selfWeak.detailmodel.status.intValue == 2 || selfWeak.detailmodel.status.intValue == 4 || selfWeak.detailmodel.status.intValue == 5 ) {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(70 + TableViewBottomSpace));
                }];
            } else {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
            selfWeak.bottomView.model = self.detailmodel;
            [selfWeak.view layoutIfNeeded];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _bottomView.hidden = NO;
        [SVProgressHUD dismiss];
    }];
}


/**
底部按钮操作

@param index //222左 333右
@param model 当前实例
*/
- (void)bottomActionIndex:(NSInteger)index currentModel:(LxmJieDanListModel *)model {
    switch (model.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {//去支付
            LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_wfbd];
            vc.wfbdID = model.id;
            vc.wfbdMoney = model.servicePrice;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            if (index == 222) {//申请撤单
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认撤单" message:@"您确定要撤单吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self shenqingchedan:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
            } else {//加价
                [self jiajia:model];
            }
        }
            break;
        case 3: {//待完成 没有底部按钮
            
        }
            break;
        case 4: {//处理退单
            [self chulituidan:model];
        }
            break;
        case 5: {//去打分
            [self dafen:model];
        }
            break;
            
        default:
            break;
    }
}

/**
 加价
 */
- (void)jiajia:(LxmJieDanListModel *)model {
    LxmJiaJiaAlertView *alertView = [[LxmJiaJiaAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds type:LxmJiaJiaAlertView_type_jiajia];
    WeakObj(self);
    alertView.jiajiaBlock = ^(NSString *price) {
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_jiajia];
        vc.jiajiaModel = model;
        vc.jiajiaPrice = price;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    [alertView show];
}


/**
 申请撤单
 */
- (void)shenqingchedan:(LxmJieDanListModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:cancel_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"撤单申请已提交!"];
            [LxmEventBus sendEvent:@"detailAction" data:nil];
            [selfWeak loadDetailData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)dafen:(LxmJieDanListModel *)model {
    LxmJiaJiaAlertView *alertView = [[LxmJiaJiaAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds type:LxmJiaJiaAlertView_type_dafen];
    WeakObj(self);
    alertView.jiajiaBlock = ^(NSString *price) {//分数
        [selfWeak dafenRequest:model price:price];
    };
    [alertView show];
}

/**
 打分
 */
- (void)dafenRequest:(LxmJieDanListModel *)model price:(NSString *)price {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    dict[@"score"] = price;
    [SVProgressHUD show];
 
    [LxmNetworking networkingPOST:score_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"打分已提交!"];
            [LxmEventBus sendEvent:@"detailAction" data:nil];
            [self loadDetailData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 处理退单
 */
- (void)chulituidan:(LxmJieDanListModel *)model {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"退单" message:@"您是否同意退单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak chulituidan:model state:@3];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak chulituidan:model state:@7];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)chulituidan:(LxmJieDanListModel *)model state:(NSNumber *)status {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    dict[@"status"] = status;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:verify_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:status.intValue == 3 ? @"已拒绝!" : @"退单成功!"];
            [LxmEventBus sendEvent:@"detailAction" data:nil];
            [selfWeak loadDetailData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end

/**
 底部按钮
 */
@interface LxmJieDanMyPublishDetailBottomView ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button1;

@end
@implementation LxmJieDanMyPublishDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.button];
    [self addSubview:self.button1];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@28);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(21);
    }];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@28);
        make.trailing.equalTo(self.button.mas_leading).offset(-15);
        make.top.equalTo(self).offset(21);
    }];
}

- (UIButton *)button {
    if (!_button) {
        _button = UIButton.new;
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setTitleColor:MainColor forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_bk"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = UIButton.new;
        _button1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button1 setTitleColor:MainColor forState:UIControlStateNormal];
        [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_bk"] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

/**
 底部按钮操作
 */
- (void)btnClick:(UIButton *)btn {
    
    NSInteger index;
    if (btn == _button) {//右侧按钮
        index = 333;
    } else {//左侧按钮
        index = 222;
    }
    if (self.model) {
        if (self.bottomButtonActionBlock) {
            self.bottomButtonActionBlock(index,self.model);
        }
    }
    if (self.jieshouModel) {
        if (self.bottomButtonActionBlock) {
            self.bottomButtonActionBlock(index,self.jieshouModel);
        }
    }
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    switch (_model.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {
            _button1.hidden = YES;
            [_button setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 2: {
            _button1.hidden = NO;
            [_button setTitle:@"加价" forState:UIControlStateNormal];
            [_button1 setTitle:@"申请撤单" forState:UIControlStateNormal];
        }
            break;
        case 3: {//待完成 没有底部按钮
            
        }
            break;
        case 4: {
            _button1.hidden = YES;
            [_button setTitle:@"处理退单" forState:UIControlStateNormal];
        }
            break;
        case 5: {
            _button1.hidden = YES;
            [_button setTitle:@"去打分" forState:UIControlStateNormal];
        }
            break;
        case 6: {//已评价 已完成 没有底部按钮
            
        }
            break;
        case 7: {//已退单 没有底部按钮
            
        }
            break;
        case 8: {//已失效 没有底部按钮
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setJieshouModel:(LxmJieDanListModel *)jieshouModel {
    _jieshouModel = jieshouModel;
    switch (_jieshouModel.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 3: {
            if ([_jieshouModel.backCommend isValid]) {//退单被驳回
                [_button1 setTitle:@"申诉" forState:UIControlStateNormal];
                [_button setTitle:@"上传评价单" forState:UIControlStateNormal];
            } else {//已接单
                [_button1 setTitle:@"申请撤单" forState:UIControlStateNormal];
                [_button setTitle:@"上传评价单" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

@end
