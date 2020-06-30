//
//  LxmZiTiJIeSuanVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmZiTiJieSuanVC.h"
#import "LxmJieSuanView.h"
#import "LxmPeiSongAlertView.h"
#import "LxmMyAddressVC.h"
#import "LxmOrderChaXunVC.h"
#import "LxmZiTiVC.h"

@interface LxmZiTiJieSuanVC ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmJieSuanBottomView *bottomView;

@property (nonatomic, assign) NSInteger style;//100快递 101自提 102没选择

@property (nonatomic, assign) CGFloat allPrice;

@property (nonatomic, assign) CGFloat lingshouPrice;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) LxmAddressModel *addressModel;

@property (nonatomic, strong) LxmAcGoodsModel *acgoods;

@property (nonatomic, strong) NSMutableArray <LxmAcGoodsModel *> *ac_goods;

@property (nonatomic, strong) IQTextView *noteView;//备注

@end

@implementation LxmZiTiJieSuanVC
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmJieSuanBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"结算";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.style = 100;
    self.allPrice = 0;
    self.lingshouPrice = 0;
    self.count = 0;
    for (LxmShopCarModel *m in self.fahuoArr) {
        if (!m.num.isValid) {
            m.num = @"1";
        }
        self.count += m.num.intValue;
        self.allPrice += m.proxy_price.doubleValue * m.num.intValue;
        self.lingshouPrice += m.good_price.doubleValue * m.num.intValue;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"实付金额 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",self.allPrice] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.bottomView.moneyLabel.attributedText = att;
    WeakObj(self);
    self.bottomView.tijiaoBlock = ^{
        [selfWeak tijiaoOrder];
    };
    [self loadMorenAddressData];
    [self.tableView reloadData];
    
    //查看有没有赠品活动
    self.ac_goods = [NSMutableArray array];
    [self seeFavourable];
}

/**
查看有没有赠品活动
*/
- (void)seeFavourable {
    [LxmNetworking networkingPOST:get_send_ac parameters:@{@"token" : SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class] && [responseObject[@"key"] integerValue] == 1000) {
            NSDictionary *dict = [responseObject valueForKeyPath:@"result.data"];
            if ([dict isKindOfClass:NSDictionary.class]) {
                LxmAcGoodsModel *ac_goodsModel = [LxmAcGoodsModel mj_objectWithKeyValues:dict];
                self.acgoods = ac_goodsModel;
                [self.ac_goods removeAllObjects];
                if (ac_goodsModel.infoType.integerValue == 1) {
                    // 1：满金额赠送
                    if (self.allPrice >= ac_goodsModel.infoMoney.floatValue) {
                        ac_goodsModel.loc_num = floor(self.allPrice / ac_goodsModel.infoMoney.floatValue);
                        [self.ac_goods addObject:ac_goodsModel];
                    }
                } else if (ac_goodsModel.infoType.integerValue == 2) {
                    //2：满数量赠送
                    NSArray *goodIdList = [ac_goodsModel.goodIdList componentsSeparatedByString:@","];
                    for (LxmShopCarModel *m in self.fahuoArr) {
                        if (!m.num.isValid) {
                            m.num = @"1";
                        }
                        if ([goodIdList containsObject:m.good_id]) {
                            if (m.num.intValue >= ac_goodsModel.infoNum.integerValue) {
                                ac_goodsModel.isCanShow = YES;
                                LxmAcGoodsModel *m0 = [LxmAcGoodsModel new];
                                m0.goodPic = m.give_pic;
                                m0.goodName = m.good_name;
                                m0.loc_num = floor(m.num.intValue / ac_goodsModel.infoNum.integerValue);
                                [self.ac_goods addObject:m0];
                            }
                        }
                    }
                }
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 请求数据
 */
- (void)loadMorenAddressData {
    [LxmNetworking networkingPOST:address_list parameters:@{@"token":SESSION_TOKEN,@"pageNum": @1,@"defaultStatus":@2} returnClass:LxmAddressRootModel.class success:^(NSURLSessionDataTask *task, LxmAddressRootModel *responseObject) {
            if (responseObject.key.intValue == 1000) {
                NSArray *tempArr = responseObject.result.list;
                if ([tempArr isKindOfClass:NSArray.class]) {
                    if (tempArr.count > 0) {
                        self.addressModel = tempArr.firstObject;
                    }
                }
                [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        }];
}


/**
 初始化子视图
 */
- (void)initSubviews {
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
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.style == 100) {//快递 那么要选择收货地址
            return 2;
        }
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.fahuoArr.count + self.ac_goods.count;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.style == 100) {
            if (indexPath.row == 0) {
                LxmJieSuanPeiSongStyleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongStyleCell"];
                if (!cell) {
                    cell = [[LxmJieSuanPeiSongStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongStyleCell"];
                }
                cell.titleLabel.text = @"配送方式";
                if (LxmTool.ShareTool.userModel.postMoney.integerValue > 0) {
                    cell.styleLabel.text = [NSString stringWithFormat:@"快递(满%@元包邮或到付)",LxmTool.ShareTool.userModel.lowMoney];
                } else {
                    cell.styleLabel.text = @"物流发货";
                }
                cell.styleLabel.hidden = NO;
                return cell;
            } else {
                LxmJieSuanPeiSongAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongAddressCell"];
                if (!cell) {
                    cell = [[LxmJieSuanPeiSongAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongAddressCell"];
                }
                if (self.addressModel) {
                    cell.titleLabel.hidden = YES;
                    cell.addressModel = self.addressModel;
                } else {
                    cell.titleLabel.hidden = NO;
                }
                return cell;
            }
        }
        LxmJieSuanPeiSongStyleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongStyleCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongStyleCell"];
        }
        if (self.style == 102) {
            cell.titleLabel.text = @"请选择配送方式";
            cell.styleLabel.hidden = YES;
        } else {
            cell.titleLabel.text = @"配送方式";
            cell.styleLabel.text = @"自提";
            cell.styleLabel.hidden = NO;
        }
        return cell;
    } else if (indexPath.section == 1) {
        LxmZiTiNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmZiTiNoteCell"];
        if (!cell) {
            cell = [[LxmZiTiNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmZiTiNoteCell"];
        }
        self.noteView = cell.noteView;
        self.noteView.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row >= self.fahuoArr.count) {
            LxmAcGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAcGoodsCell"];
            if (!cell) {
                cell = [[LxmAcGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAcGoodsCell"];
            }
            cell.model = self.ac_goods[indexPath.row - self.fahuoArr.count];
            return cell;
        } else {
            LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
            if (!cell) {
                cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
            }
            cell.model = self.fahuoArr[indexPath.row];
            return cell;
        }
    } else {
        LxmJieSuanPeiSongInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongInfoCell"];
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"商品件数";
            cell.detailLabel.text = [NSString stringWithFormat:@"%lu件",(unsigned long)self.count];
        } else {
            cell.titleLabel.text = @"商品零售总价";
            cell.detailLabel.text = [NSString stringWithFormat: @"¥%.2f", self.lingshouPrice];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WeakObj(self);
            LxmPeiSongAlertView *alerView = [[LxmPeiSongAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alerView.index1 = self.style;
            alerView.selectTypeBlock = ^(NSInteger index) {
                selfWeak.style = index;
                [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            };
            [alerView show];
        }
        if (self.style == 100 && indexPath.row == 1) {//选择地址
            LxmMyAddressVC *vc = [[LxmMyAddressVC alloc] init];
            WeakObj(self);
            vc.didselectedAddressBlock = ^(LxmAddressModel *model) {
                selfWeak.addressModel = model;
                [selfWeak.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (indexPath.section == 1) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.style == 100) {
            if (indexPath.row == 1) {
                if (self.addressModel) {
                    NSString *detail =  [NSString stringWithFormat:@"%@ %@ %@ %@",_addressModel.province, _addressModel.city, _addressModel.district, _addressModel.addressDetail];
                    CGFloat detailH = [detail getSizeWithMaxSize:CGSizeMake(ScreenW - 85, 9999) withFontSize:13].height;
                    return 20 + 20 + 10 + detailH + 20;
                } else {
                    return 80;
                }
            }
            return 50;
        }
        return 50;
    } else if (indexPath.section == 1) {
        return 60;
    } else if (indexPath.section == 2) {
        return 110;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (void)tijiaoOrder {
    if (self.style == 100 && !self.addressModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择收货地址!"];
        return;
    }
    
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (LxmShopCarModel *model in self.fahuoArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:model.id forKey:@"id"];
        [dic setValue:model.num forKey:@"num"];
        [dic setValue:model.good_id forKey:@"goodId"];
        [dic setValue:model.proxy_price forKey:@"proxyPrice"];
        [tempArr addObject:dic];
    }
    NSString *goods = [NSString convertToJsonData:tempArr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"goods"] = goods;
    dict[@"postage_type"] = self.style == 100 ? @2 : @1;
    if (self.style == 100) {
        dict[@"address_id"] = self.addressModel.id;
    }
    if (self.ac_goods.count > 0 && self.acgoods.id.length > 0) {
        dict[@"activityId"] = self.acgoods.id;
    }
    
    if (self.noteView.text.isValid) {
       dict[@"order_info"] = self.noteView.text;
    }
    
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:send_good_order parameters:dict returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"发货下单成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"fahuoxaidanSuccess" data:nil];
                LxmOrderChaXunVC *vc = [LxmOrderChaXunVC new];
                [self.navigationController pushViewController:vc animated:YES];
                [self popSelfVC];
//                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
//                    if ([vc isKindOfClass:[LxmZiTiVC class]]) {
//                        [selfWeak.navigationController popToViewController:vc animated:YES];
//                    }
//                }
            });
//            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end


@interface LxmZiTiNoteCell ()

@property (nonatomic, strong) UILabel *noteLable;//备注

@end
@implementation LxmZiTiNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.noteLable];
        [self addSubview:self.noteView];
        [self.noteLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.height.equalTo(@20);
        }];
        [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.noteLable.mas_trailing).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-8);
            make.top.equalTo(self).offset(8);
        }];
    }
    return self;
}

- (UILabel *)noteLable {
    if (!_noteLable) {
        _noteLable = [UILabel new];
        _noteLable.font = [UIFont systemFontOfSize:13];
        _noteLable.textColor = CharacterDarkColor;
        _noteLable.text = @"备注";
    }
    return _noteLable;
}

- (IQTextView *)noteView {
    if (!_noteView) {
        _noteView = [IQTextView new];
        _noteView.font = [UIFont systemFontOfSize:13];
        _noteView.textColor = CharacterDarkColor;
        _noteView.placeholder = @"请输入";
        _noteView.maxLength = 200;
    }
    return _noteView;
}

@end
