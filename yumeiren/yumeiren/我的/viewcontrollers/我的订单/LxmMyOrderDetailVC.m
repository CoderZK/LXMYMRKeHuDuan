//
//  LxmMyOrderDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyOrderDetailVC.h"
#import "LxmSubOrderChaXunVC.h"
#import "LxmJieSuanView.h"
#import "LxmSubBuHuoOrderVC.h"
#import "LxmWuLiuInfoVC.h"
#import "LxmOrderDetailVC.h"
#import "LxmMyAddressVC.h"

@interface LxmMyOrderDetailWuLiuCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *stateLabel;//待发货 已发货 已完成

@property (nonatomic, strong) UILabel *detailLabel;//物流信息

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) LxmWuLiuInfoStateModel *model;

@end
@implementation LxmMyOrderDetailWuLiuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = MainColor;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.accImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.iconImgView);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.stateLabel);
        make.trailing.lessThanOrEqualTo(self.accImgView.mas_leading);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.stateLabel);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.textColor = CharacterDarkColor;
    }
    return _stateLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = CharacterDarkColor;
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
    }
    return _accImgView;
}


- (void)setModel:(LxmWuLiuInfoStateModel *)model {
    _model = model;
    self.stateLabel.text = _model.title;
    if (_model.list.count >= 1) {
        self.detailLabel.text = _model.list.firstObject.context;
    } else {
        self.detailLabel.text = @"物流信息:暂无物流信息";
    }
    if ([_model.title isEqualToString:@"已签收"]) {
        _iconImgView.image = [UIImage imageNamed:@"fahuocar"];
    } else {
        _iconImgView.image = [UIImage imageNamed:@"fahuocar"];
    }
}


@end



@interface LxmMyOrderDetailVC ()

@property (nonatomic, strong) LxmOrderDetailBottomView *bottomView;//底部操作按钮

@property (nonatomic, strong) LxmShopCenterOrderDetailModel *detailModel;

@property (nonatomic, assign) CGFloat lingshiTotalPrice;/* 商品零售总价 */

@property (nonatomic, assign) CGFloat shangpinTotalPrice;/* 商品总价 */

@property (nonatomic, assign) NSInteger count;//商品件数

@property (nonatomic, strong) LxmWuLiuInfoRootModel *rootModel;/* 快递信息什么的 */

@property (nonatomic, strong) NSArray <LxmWuLiuInfoStateModel *>*dataArr;

@end

@implementation LxmMyOrderDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:MainColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
}

- (LxmOrderDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmOrderDetailBottomView alloc] init];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [UIColor whiteColor];
        WeakObj(self);
        _bottomView.gotobuhuoBlock = ^{
            [selfWeak bottomButtonAction];
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self loadDetailData];
    if (self.postage_code.isValid) {
        [self loadWuLiuInfo];
    }
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 60));
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.detailModel.map.sub.count + self.detailModel.map.sends.count;
    }else if (section == 2) {
        return 6;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LxmMyOrderDetailWuLiuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyOrderDetailWuLiuCell"];
            if (!cell) {
                cell = [[LxmMyOrderDetailWuLiuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyOrderDetailWuLiuCell"];
            }
            if (self.dataArr.count >= 1) {
                cell.model = self.dataArr.firstObject;
            }
            return cell;
        } else {
            LxmSubOrderChaXunAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubOrderChaXunAddressCell"];
            if (!cell) {
                cell = [[LxmSubOrderChaXunAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubOrderChaXunAddressCell"];
            }
            cell.orderModel = self.detailModel.map;
            WeakObj(self);
            cell.modifyAddressClick = ^(LxmShopCenterOrderModel *orderModel) {
                [selfWeak modifyAddress:orderModel];
            };
            return cell;
        }
        
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
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld件",self.count];
        } else if (indexPath.row == 2){
            cell.titleLabel.text = @"商品零售总价";
            cell.detailLabel.textColor = CharacterDarkColor;
            CGFloat f = self.lingshiTotalPrice;
            NSInteger d = self.lingshiTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 3){
            cell.titleLabel.text = @"商品总额";
            cell.detailLabel.textColor = MainColor;
            CGFloat f = self.shangpinTotalPrice;
            NSInteger d = self.shangpinTotalPrice;
            cell.detailLabel.text = f == d ? [NSString stringWithFormat:@"¥%ld",d] : [NSString stringWithFormat:@"¥%.2f",f];
        } else if (indexPath.row == 4){
            cell.titleLabel.text = @"运费";
            cell.detailLabel.textColor = MainColor;
            cell.detailLabel.text = @"物流发货";
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
           
            cell.detailLabel.text = self.detailModel.map.r_create_time;;
            
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!self.postage_code.isValid) {
                return 0.01;
            } else {
                if (self.dataArr.count >= 1) {
                    return self.dataArr.firstObject.list.firstObject.detailH;
                }
                return 0.01;
            }
        } else {
            if (self.detailModel.map.postage_type.intValue == 2) {
                return self.detailModel.map.addressHeight;
            }
            return 0.001;
        }
    } else if (indexPath.section == 1) {
        return 120;
    } else {
        if (indexPath.section == 2 && indexPath.row == 0) {
            if (self.detailModel.map.order_info.isValid) {
                return self.detailModel.map.orderHeight > 50 ? self.detailModel.map.orderHeight : 50;
            }
            return 0.01;
        }
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//物流详情
            LxmWuLiuInfoVC *vc = [[LxmWuLiuInfoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.rootModel = self.rootModel;
            vc.dataArr = self.dataArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

/**
 2 申请退单 3 确认收货 7 确认自提
 */
- (void)bottomButtonAction {
    NSInteger status = self.detailModel.map.status.intValue;
    if (status == 2) {//申请退单
        [self shenqingTuidan];
    } else if (status == 3) {//确认收货
        [self sureshouhuoisOver:NO];
    } else if (status == 7) {//确认自提
//        [self sureshouhuoisOver:YES];
    }
}

/**
 确认收货
 */
- (void)sureshouhuoisOver:(BOOL)isZiti {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:confirm_send_order parameters:@{@"token":SESSION_TOKEN,@"id":selfWeak.detailModel.map.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [LxmEventBus sendEvent:@"detailBottomAction" data:nil];
            if (isZiti) {
                [SVProgressHUD showSuccessWithStatus:@"已确认自提!"];
                selfWeak.detailModel.map.status = @"8";
            } else {
                [SVProgressHUD showSuccessWithStatus:@"已收货!"];
                selfWeak.detailModel.map.status = @"4";
            }
            selfWeak.bottomView.model = selfWeak.detailModel.map;
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
    [LxmNetworking networkingPOST:return_send_order parameters:@{@"token":SESSION_TOKEN,@"id":selfWeak.detailModel.map.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
       if (responseObject.key.integerValue == 1000) {
           [SVProgressHUD showSuccessWithStatus:@"已提交退单申请!"];
           [LxmEventBus sendEvent:@"detailBottomAction" data:nil];
           selfWeak.detailModel.map.status = @"5";
           [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.equalTo(@0);
           }];
           [selfWeak.view layoutIfNeeded];
           selfWeak.bottomView.model = selfWeak.detailModel.map;
       } else {
           [UIAlertController showAlertWithmessage:responseObject.message];
       }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [SVProgressHUD dismiss];
    }];
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
            for (LxmShopCenterOrderGoodsModel *goods in selfWeak.detailModel.map.sub) {
                selfWeak.count += goods.num.intValue;
                selfWeak.lingshiTotalPrice += goods.good_price.doubleValue * goods.num.intValue;
                selfWeak.shangpinTotalPrice += goods.proxy_price.doubleValue * goods.num.intValue;
            }
            selfWeak.bottomView.model = selfWeak.detailModel.map;
            NSInteger status = selfWeak.detailModel.map.status.intValue;
            if (status == 2 || status == 3 || status == 8) {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(TableViewBottomSpace + 60));
                }];
            } else {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
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


/**
 获取物流信息
 数组逆序
 //NSArray *strRevArray = [[strArr reverseObjectEnumerator] allObjects];
 */
- (void)loadWuLiuInfo {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:way_detail parameters:@{@"token":SESSION_TOKEN,@"id":self.orderID} returnClass:LxmWuLiuInfoRootModel.class success:^(NSURLSessionDataTask *task, LxmWuLiuInfoRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.rootModel = responseObject;
            selfWeak.dataArr = [[selfWeak.rootModel.result.list reverseObjectEnumerator] allObjects];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/// 修改地址
- (void)modifyAddress:(LxmShopCenterOrderModel *)orderModel {
    LxmMyAddressVC *vc = [[LxmMyAddressVC alloc] init];
    WeakObj(self);
    vc.didselectedAddressBlock = ^(LxmAddressModel *model) {
        [selfWeak modifyAddress:model.id orderModel:orderModel];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)modifyAddress:(NSString *)addressID orderModel:(LxmShopCenterOrderModel *)orderModel {
    WeakObj(self);
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:up_send_order_address parameters:@{@"token":SESSION_TOKEN,@"id":orderModel.id,@"address_id":addressID} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            [SVProgressHUD showErrorWithStatus:@"地址修改成功!"];
            [selfWeak loadDetailData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
