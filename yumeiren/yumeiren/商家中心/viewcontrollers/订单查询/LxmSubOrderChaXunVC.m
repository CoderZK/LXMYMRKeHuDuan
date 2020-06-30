//
//  LxmSubOrderChaXunVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubOrderChaXunVC.h"
#import "LxmSubBuHuoOrderVC.h"
#import "LxmJieSuanView.h"
#import "LxmOrderDetailVC.h"
#import "LxmMyOrderDetailVC.h"
#import "LxmMyAddressVC.h"

@interface LxmSubOrderChaXunVC ()

@property (nonatomic, assign) LxmSubOrderChaXunVC_type type;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubOrderChaXunVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂无订单哦~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmSubOrderChaXunVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        StrongObj(self);
        [self loadData];
    }];
    [LxmEventBus registerEvent:@"detailBottomAction" block:^(id data) {
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].sub.count + 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmSubBuHuoOrderTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderTopCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderTopCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == 1) {
        LxmSubOrderChaXunAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubOrderChaXunAddressCell"];
        if (!cell) {
            cell = [[LxmSubOrderChaXunAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubOrderChaXunAddressCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        WeakObj(self);
        cell.modifyAddressClick = ^(LxmShopCenterOrderModel *orderModel) {
            [selfWeak modifyAddress:orderModel];
        };
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub.count + 4 - 2) {
        LxmSubBuHuoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub.count + 4 - 1){
        LxmSubBuHuoOrderButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        WeakObj(self);
        cell.gotobuhuoBlock = ^{
            [selfWeak buttonAction:selfWeak.dataArr[indexPath.section]];
        };
        return cell;
    } else {
        LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section].sub[indexPath.row - 2];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCenterOrderModel *orderModel = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == 1) {
        if (orderModel.postage_type.intValue == 1) {
            return 0.001;
        }
        return orderModel.addressHeight;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub.count + 4 - 2) {
        return 44;
    } else if(indexPath.row == self.dataArr[indexPath.section].sub.count + 4 - 1) {
        if (orderModel.status.intValue == 2 || orderModel.status.intValue == 3 || orderModel.status.intValue == 8) {
            return 60;
        }
        return 0.001;
    } else {
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCenterOrderModel *orderModel = self.dataArr[indexPath.section];
    if (self.type == LxmSubOrderChaXunVC_type_shopCenter) {
        LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
        vc.orderID = orderModel.id;
        [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
    } else {
        LxmMyOrderDetailVC *vc = [[LxmMyOrderDetailVC alloc] init];
        vc.postage_code = orderModel.postage_code;
        vc.orderID = orderModel.id;
        [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
    }
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        dict[@"status"] = self.status;
        dict[@"type"] = @1;
        [LxmNetworking networkingPOST:order_list parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.page ++;
                self.emptyView.hidden = self.dataArr.count > 0;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}

/**
 2 申请退单 3 确认收货 7 确认自提
 */
- (void)buttonAction:(LxmShopCenterOrderModel *)model {
    if (model.status.intValue == 2) {
        [self shenqingTuidan:model];
    } else if (model.status.intValue == 3) {
        [self sureshouhuo:model isOver:NO];
    } else if (model.status.intValue == 7) {//确认自提
//        [self sureshouhuo:model isOver:YES];
    }
}

/**
 确认收货
 */
- (void)sureshouhuo:(LxmShopCenterOrderModel *)model isOver:(BOOL)isZiti {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:confirm_send_order parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            if (isZiti) {
                [SVProgressHUD showSuccessWithStatus:@"已确认自提!"];
                model.status = @"8";
            } else {
                [SVProgressHUD showSuccessWithStatus:@"已收货!"];
                model.status = @"4";
            }
            
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 申请退单加弹窗
 */
- (void)shenqingTuidan:(LxmShopCenterOrderModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要申请退单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    WeakObj(self);
    [alertView addAction:[UIAlertAction actionWithTitle:@"申请退单" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak tuidan:model];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}
/**
申请退单
*/
- (void)tuidan:(LxmShopCenterOrderModel *)model {
    [SVProgressHUD show];
       WeakObj(self);
       [LxmNetworking networkingPOST:return_send_order parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
           if (responseObject.key.integerValue == 1000) {
               [SVProgressHUD showSuccessWithStatus:@"已提交退单申请!"];
               model.status = @"5";
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
            selfWeak.page = 1;
            selfWeak.allPageNum = 1;
            [selfWeak loadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end

/**
 地址
 */
@interface LxmSubOrderChaXunAddressCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//定位图标

@property (nonatomic, strong) UILabel *titleLabel;//姓名 + 电话

@property (nonatomic, strong) UILabel *addressLabel;//地址

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmModifyButton *modifyButton;

@end
@implementation LxmSubOrderChaXunAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.modifyButton];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.trailing.lessThanOrEqualTo(self.modifyButton.mas_leading);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self.modifyButton.mas_leading);
    }];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.equalTo(@80);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"local"];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = CharacterDarkColor;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmModifyButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [LxmModifyButton new];
        [_modifyButton addTarget:self action:@selector(modifyAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}

- (void)setOrderModel:(LxmShopCenterOrderModel *)orderModel {
    _orderModel = orderModel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ",_orderModel.username] attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:_orderModel.telephone ? _orderModel.telephone : @"" attributes:@{ NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [att appendAttributedString:str];
    self.titleLabel.attributedText = att;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_orderModel.province, _orderModel.city, _orderModel.district, _orderModel.address_detail];
    if (_orderModel.postage_type.intValue == 2 && _orderModel.status.intValue == 2) {
        self.modifyButton.hidden = NO;
        //待确认发货的订单且是快递的发货订单才可以修改
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.equalTo(self.modifyButton.mas_leading);
        }];
        [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.equalTo(self.modifyButton.mas_leading);
        }];
    } else {
        self.modifyButton.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    [self layoutIfNeeded];
}

- (void)modifyAddressButtonClick {
    if (self.modifyAddressClick) {
        self.modifyAddressClick(self.orderModel);
    }
}

@end


@interface LxmModifyButton()

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *textLabel;//修改

@end
@implementation LxmModifyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/// 添加子视图
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.textLabel];
}

/// 设置约束
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
        make.size.equalTo(@(16));
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(8);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"xiugaiAddress"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor= CharacterLightGrayColor;
        _textLabel.text = @"修改";
    }
    return _textLabel;
}

@end
