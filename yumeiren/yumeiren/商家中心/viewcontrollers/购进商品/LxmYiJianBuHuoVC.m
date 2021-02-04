//
//  LxmYiJianBuHuoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmYiJianBuHuoVC.h"
#import "LxmShopCarView.h"
#import "LxmShopVC.h"
#import "LxmPanButton.h"
#import "LxmPayVC.h"

@interface LxmYiJianBuHuoVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmShopCarBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*dataArr;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterModel *> *myKuCunDataArr;

@property (nonatomic, strong) LxmYiJianBuHuoDanCell *allSelectCell;//全选

@property (nonatomic, assign) NSInteger cellDianJiCount;

@property (nonatomic, strong) LxmYiJianBuHuoDanFootView *footerView;

@property (nonatomic, strong) LxmPanButton *addCarButton;//加入购物车的悬浮按钮

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@property (nonatomic, assign) CGFloat allPrice;//总价

@property (nonatomic, assign) CGFloat proxyPrice;//代理总价

@end

@implementation LxmYiJianBuHuoVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您还没有补货单呢!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


- (LxmPanButton *)addCarButton {
    if (!_addCarButton) {
        _addCarButton = [[LxmPanButton alloc] init];
        _addCarButton.hidden = YES;
        _addCarButton.marginInsets = UIEdgeInsetsMake(15, 15, 65, 15);
        WeakObj(self);
        _addCarButton.panBlock = ^{
            [selfWeak addGoodsToLocolList];
        };
    }
    return _addCarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (LxmYiJianBuHuoDanFootView *)footerView {
    if (!_footerView) {
        _footerView = [[LxmYiJianBuHuoDanFootView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
        [_footerView addTarget:self action:@selector(addGoodsToLocolList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmShopCarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmShopCarBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.isYIjianbuhuo = YES;
        _bottomView.allImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        WeakObj(self);
        _bottomView.jiesuanBlock = ^{
            [selfWeak jiesuanClick];
        };
        _bottomView.allSelectBlock = ^(BOOL isSelect) {
            [selfWeak allSelectClick:isSelect];
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellDianJiCount = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"一键补货";
    [self.view addSubview:self.addCarButton];
    self.myKuCunDataArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    [self initSubviews];
    
    [self loadKuCunData];
    WeakObj(self);
    [LxmEventBus registerEvent:@"localListUpdate" block:^(id data) {
        [selfWeak.tableView reloadData];
    }];
}


/**
获取我的店铺里面的商品库存 和 补货列表进行比对
*/
- (void)loadKuCunData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] = @1;
    dict[@"pageSize"] = @300;
    [LxmNetworking networkingPOST:stock_list parameters:dict returnClass:LxmShopCenterRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterRootModel *responseObject) {
        if (responseObject.key.intValue == 1000) {
            [self.myKuCunDataArr addObjectsFromArray:responseObject.result.list];
            [self loadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}



/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.emptyView];
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
        make.height.equalTo(@(TableViewBottomSpace + 60));
    }];
    [self.addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-(TableViewBottomSpace + 80));
        make.width.height.equalTo(@50);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count > 0 ? 1 : 0;
    } else if (section == self.dataArr.count + 2 -1) {//最后一区
        return [LxmTool ShareTool].goodsList.count;
    } else {
        return self.dataArr[section - 1].sub.count + 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmYiJianBuHuoDanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoDanCell"];
        if (!cell) {
            cell = [[LxmYiJianBuHuoDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoDanCell"];
        }
        self.allSelectCell = cell;
        return cell;
    } else if (indexPath.section == self.dataArr.count + 2 -1) {//最后一区
        LxmLocalGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmLocalGoodsCell"];
        if (!cell) {
            cell = [[LxmLocalGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmLocalGoodsCell"];
        }
        cell.goodsModel = [LxmTool ShareTool].goodsList[indexPath.row];
        WeakObj(self);
        cell.modifySuccessBlock = ^(LxmHomeGoodsModel *goodsModel) {
            StrongObj(self);
            self.allPrice = 0;
            self.proxyPrice = 0;
            for (LxmShopCenterOrderModel *model in self.dataArr) {
                if (model.isSelected) {
                    for (LxmShopCenterOrderGoodsModel *m in model.sub) {
                        self.allPrice += m.good_price.doubleValue * m.num.intValue;
                        self.proxyPrice += m.proxy_price.doubleValue * m.num.intValue;
                    }
                }
            }
            for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].goodsList) {
                if (m1.isSelected) {
                    self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
                    self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
                }
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            self.bottomView.vipPrice.attributedText = att;
            self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
        };
        return cell;
    } else {
        if (indexPath.row == 0) {
            LxmYiJianBuHuoOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoOrderCell"];
            if (!cell) {
                cell = [[LxmYiJianBuHuoOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoOrderCell"];
            }
            
            cell.orderModel = self.dataArr[indexPath.section - 1];
            return cell;
        }
        LxmYiJianBuHuoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoGoodsCell"];
        if (!cell) {
            cell = [[LxmYiJianBuHuoGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoGoodsCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section - 1].sub[indexPath.row - 1];
        return cell;
    }
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == self.dataArr.count + 2 -1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeGoodsModel *model = [LxmTool ShareTool].goodsList[indexPath.row];
    [[LxmTool ShareTool] delSubGoods:model];
    [LxmEventBus sendEvent:@"localListUpdate" data:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == self.dataArr.count + 2 -1) {
        return 120;
    } else {
        if (indexPath.row == 0) {
            return 40;
        }
        LxmShopCenterOrderGoodsModel *mo = self.dataArr[indexPath.section - 1].sub[indexPath.row - 1];
        return mo.num.intValue == 0 ? 0 : 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == self.dataArr.count + 2 -1) {
        return 10;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//全选
        self.cellDianJiCount++;
        NSInteger count1 = 0;
        NSInteger count2 = 0;
        
        self.allPrice = 0;
        self.proxyPrice = 0;
        for (LxmShopCenterOrderModel *model in self.dataArr) {
            model.isSelected = self.cellDianJiCount %2 != 0;
            if (model.isSelected) {
                for (LxmShopCenterOrderGoodsModel *m in model.sub) {
                    self.allPrice += m.good_price.doubleValue * m.num.intValue;
                    self.proxyPrice += m.proxy_price.doubleValue * m.num.intValue;
                }
            }
        }
        for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].goodsList) {
            if (m1.isSelected) {
                self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
                self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
                count1++;
            }
        }
        count2 = [LxmTool ShareTool].goodsList.count + self.dataArr.count;
        self.allSelectCell.iconImgView.image = [UIImage imageNamed:self.cellDianJiCount %2 != 0 ? @"xuanzhong_y" : @"xuanzhong_n" ];
        if (self.cellDianJiCount %2 != 0) {
             self.bottomView.allImgView.image = [UIImage imageNamed:count1 ==  [LxmTool ShareTool].goodsList.count ? @"xuanzhong_y" : @"xuanzhong_n"];
        } else {
            self.bottomView.allImgView.image = [UIImage imageNamed: @"xuanzhong_n"];
        }
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        self.bottomView.vipPrice.attributedText = att;
        self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
        [self.tableView reloadData];
    } else if (indexPath.section == self.dataArr.count + 2 -1) {
        LxmHomeGoodsModel *model = [LxmTool ShareTool].goodsList[indexPath.row];
        model.isSelected = !model.isSelected;
        [[LxmTool ShareTool] saveSubGoods:model];
        [LxmEventBus sendEvent:@"localListUpdate" data:nil];
        [self setBottomSelectStatus];
    } else {
        if (indexPath.row == 0) {//单选
            LxmShopCenterOrderModel *model = self.dataArr[indexPath.section - 1];
            model.isSelected = !model.isSelected;
            [self.tableView reloadData];
            NSInteger count = 0;
            self.allPrice = 0;
            self.proxyPrice = 0;
            for (LxmShopCenterOrderModel *model in self.dataArr) {
                if (model.isSelected) {
                    for (LxmShopCenterOrderGoodsModel *m in model.sub) {
                        self.allPrice += m.good_price.doubleValue * m.num.intValue;
                        self.proxyPrice += m.proxy_price.doubleValue * m.num.intValue;
                    }
                    count ++;
                }
            }
            self.allSelectCell.iconImgView.image = [UIImage imageNamed:count == self.dataArr.count ? @"xuanzhong_y" : @"xuanzhong_n"];
            NSInteger count2 = 0;
            NSInteger count3 = 0;
            for (LxmHomeGoodsModel *m2 in [LxmTool ShareTool].goodsList) {
                if (m2.isSelected) {
                    self.allPrice += m2.good_price.doubleValue * m2.num.intValue;
                    self.proxyPrice += m2.proxy_price.doubleValue * m2.num.intValue;
                    count2 ++;
                }
            }
            count3 = [LxmTool ShareTool].goodsList.count + self.dataArr.count;
            self.bottomView.allImgView.image = [UIImage imageNamed:count3 == count + count2 ? @"xuanzhong_y" : @"xuanzhong_n"];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            self.bottomView.vipPrice.attributedText = att;
            self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
        }
    }
}

- (void)allSelectClick:(BOOL)isSelect {
    NSInteger count = 0;
    NSInteger count1 = 0;
    NSInteger count2 = 0;
    self.allPrice = 0;
    self.proxyPrice = 0;
    for (LxmShopCenterOrderModel *model in self.dataArr) {
        model.isSelected = isSelect;
        if (model.isSelected) {
            for (LxmShopCenterOrderGoodsModel *m in model.sub) {
                self.allPrice += m.good_price.doubleValue * m.num.intValue;
                self.proxyPrice += m.proxy_price.doubleValue * m.num.intValue;
            }
        }
        count++;
    }
    for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].goodsList) {
        m1.isSelected = isSelect;
        if (m1.isSelected) {
            self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
            self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
        }
        [[LxmTool ShareTool] saveSubGoods:m1];
        [LxmEventBus sendEvent:@"localListUpdate" data:nil];
        count1++;
    }
    count2 = [LxmTool ShareTool].goodsList.count + self.dataArr.count;
    self.allSelectCell.iconImgView.image = [UIImage imageNamed:isSelect ? @"xuanzhong_y" : @"xuanzhong_n" ];
    self.bottomView.allImgView.image = [UIImage imageNamed:isSelect ? @"xuanzhong_y" : @"xuanzhong_n"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.bottomView.vipPrice.attributedText = att;
    self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
    [self.tableView reloadData];
}

/**
 设置底部选中状态
 */
- (void)setBottomSelectStatus {
    NSInteger count1 = 0;
    NSInteger count2 = 0;
    NSInteger count3 = 0;
    self.allPrice = 0;
    self.proxyPrice = 0;
    for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].goodsList) {
        if (m1.isSelected) {
            self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
            self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
            count1++;
        }
    }
    for (LxmShopCenterOrderModel *m2 in self.dataArr) {
        if (m2.isSelected) {
            for (LxmShopCenterOrderGoodsModel *m in m2.sub) {
                self.allPrice += m.good_price.doubleValue * m.num.intValue;
                self.proxyPrice += m.proxy_price.doubleValue * m.num.intValue;
            }
            count2 ++;
        }
    }
    count3 = [LxmTool ShareTool].goodsList.count + self.dataArr.count;
    self.bottomView.allImgView.image = [UIImage imageNamed:count3 == count1 + count2 ? @"xuanzhong_y" : @"xuanzhong_n"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.bottomView.vipPrice.attributedText = att;
    self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.dataArr.count <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    
    WeakObj(self);
    [LxmNetworking networkingPOST:get_all_wait_back parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (selfWeak.model) {
                NSArray *tempArr = responseObject.result.list;
                [selfWeak.dataArr removeAllObjects];
                for (LxmShopCenterOrderModel *m in tempArr) {
                    if (m.id && m.id == selfWeak.model.id) {
                        for (LxmShopCenterOrderGoodsModel *good in m.sub) {
                            for (LxmShopCenterModel *m in selfWeak.myKuCunDataArr) {
                                if (m.good_id.intValue == good.good_id.intValue) {
                                    if (m.good_num.intValue >= good.num.intValue) {
                                        m.good_num = @(m.good_num.intValue - good.num.intValue).stringValue;
                                        good.num = @"0";
                                    } else {
                                        good.num = @(good.num.intValue - m.good_num.intValue).stringValue;
                                        m.good_num = @"0";
                                    }
                                }
                            }
                        }
                        [selfWeak.dataArr addObject:m];
                        break;
                    }
                }
                NSInteger count = selfWeak.dataArr.count + LxmTool.ShareTool.goodsList.count;
                selfWeak.emptyView.hidden = count > 0;
                selfWeak.addCarButton.hidden = count == 0;
                selfWeak.bottomView.hidden = count == 0;
                [selfWeak.tableView reloadData];
            } else {
                [selfWeak.dataArr removeAllObjects];
                [selfWeak.dataArr addObjectsFromArray:responseObject.result.list];
                
                for (LxmShopCenterOrderModel *goods in selfWeak.dataArr) {
                    for (LxmShopCenterOrderGoodsModel *good in goods.sub) {
                        for (LxmShopCenterModel *m in selfWeak.myKuCunDataArr) {
                            if (m.good_id.intValue == good.good_id.intValue) {
                                if (m.good_num.intValue >= good.num.intValue) {
                                    m.good_num = @(m.good_num.intValue - good.num.intValue).stringValue;
                                    good.num = @"0";
                                } else {
                                    good.num = @(good.num.intValue - m.good_num.intValue).stringValue;
                                    m.good_num = @"0";
                                }
                            }
                        }
                    }
                }
                
                NSInteger count = selfWeak.dataArr.count + LxmTool.ShareTool.goodsList.count;
                selfWeak.emptyView.hidden = count > 0;
                selfWeak.addCarButton.hidden = count == 0;
                selfWeak.bottomView.hidden = count == 0;
                [selfWeak.tableView reloadData];
            }
            
            self.allPrice = 0;
            self.proxyPrice = 0;
            for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].goodsList) {
                if (m1.isSelected) {
                    self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
                    self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
                }
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            self.bottomView.vipPrice.attributedText = att;
            self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

/**
 添加本地商品
 */
- (void)addGoodsToLocolList {
    self.bottomView.allImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    LxmShopVC *vc = [[LxmShopVC alloc] init];
    vc.isDeep = YES;
    vc.isAddLocolGoods = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 一件补货结算
 */
- (void)jiesuanClick {
    NSMutableArray *idArr = [NSMutableArray array];
    for (LxmShopCenterOrderModel *m1 in self.dataArr) {
        if (m1.isSelected) {
            [idArr addObject:m1.id];
        }
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (LxmHomeGoodsModel *m2 in [LxmTool ShareTool].goodsList) {
        if (m2.isSelected) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:m2.num forKey:@"num"];
            [dic setValue:m2.id forKey:@"goodId"];
            [dic setValue:m2.proxy_price forKey:@"proxyPrice"];
            [dic setValue:m2.special_type forKey:@"specialType"];
            [tempArr addObject:dic];
        }
    }
    if (idArr.count == 0 && tempArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选中任何商品,请选择后下单!"];
        return;
    }
    NSString *ids = [idArr componentsJoinedByString:@","];
    NSString *goods = [NSString convertToJsonData:tempArr];
    
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"ids" : ids,
                           @"goods" : goods,
                           @"totalM" : @(self.proxyPrice)
                           };
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:do_back_order parameters:dict returnClass:LxmBuHuoRootModel.class success:^(NSURLSessionDataTask *task, LxmBuHuoRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [LxmEventBus sendEvent:@"yijianjiesuan" data:nil];
            selfWeak.emptyView.hidden = NO;
            selfWeak.bottomView.hidden = YES;
            [selfWeak.dataArr removeAllObjects];
            [[LxmTool ShareTool] delAllGoods];
            [selfWeak setBottomSelectStatus];
            [selfWeak.tableView reloadData];
            LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_yjbh];
            vc.buhuoModel = responseObject.result.map;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        } else if (responseObject.key.integerValue == 2981) {
            CGFloat price = responseObject.result.map.price.doubleValue;
            CGFloat lowMoney = responseObject.result.map.lowMoney.doubleValue;
            if (price < lowMoney) {
                [UIAlertController showAlertWithmessage:[NSString stringWithFormat:@"请满足最低下单金额%@元",responseObject.result.map.lowMoney]];
            } else {
                [[LxmTool ShareTool] delAllGoods];
                LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_yjbh];
                vc.buhuoModel = responseObject.result.map;
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }
        } else if (responseObject.key.integerValue == 2986) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"金额不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
            WeakObj(self);
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }]];
            [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
        } else if (responseObject.key.integerValue == 3986) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"订单已过期或者已经被补货" message:nil preferredStyle:UIAlertControllerStyleAlert];
            WeakObj(self);
           [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   [selfWeak.navigationController popViewControllerAnimated:YES];
            }]];
           [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end

/**
 一键补货 补货单
 */
@interface LxmYiJianBuHuoDanCell ()

@property (nonatomic, strong) UILabel *titleLabel;//补货单

@end
@implementation LxmYiJianBuHuoDanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

/**
 是否有选择按钮
 */
- (void)setIsHaveSelect:(bool)isHaveSelect {
    _isHaveSelect = isHaveSelect;
    self.iconImgView.hidden = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"补货单";
    }
    return _titleLabel;
}

@end


@interface LxmYiJianBuHuoOrderCell ()

@property (nonatomic, strong) UILabel *orderLabel;//订单号

@property (nonatomic, strong) UIImageView *iconImgView;//选择按钮

@property (nonatomic, strong) UILabel *shifuLabel;//是否是实付的订单

@end
@implementation LxmYiJianBuHuoOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.orderLabel];
        [self addSubview:self.iconImgView];
        [self addSubview:self.shifuLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(40);
            make.centerY.equalTo(self);
        }];
        [self.shifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
    return _iconImgView;
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.font = [UIFont systemFontOfSize:12];
        _orderLabel.text = @"订单号：801248383905496323";
    }
    return _orderLabel;
}

- (UILabel *)shifuLabel {
    if (!_shifuLabel) {
        _shifuLabel = [UILabel new];
        _shifuLabel.font = [UIFont systemFontOfSize:12];
        _shifuLabel.textColor = MainColor;
        _shifuLabel.text = @"实付";
        _shifuLabel.hidden = YES;
        
    }
    return _shifuLabel;
}

- (void)setOrderModel:(LxmShopCenterOrderModel *)orderModel {
    _orderModel = orderModel;
    if (_orderModel.isShiFu) {
        if (_orderModel.status.intValue == 9) {
           _shifuLabel.hidden = YES;
        } else {
            _shifuLabel.hidden = NO;
        }
    } else {
        _shifuLabel.hidden = YES;
    }
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderModel.order_code];
    _iconImgView.image = [UIImage imageNamed:_orderModel.isSelected ? @"xuanzhong_y" : @"xuanzhong_n"];
}

/**
 是否有选择按钮
 */
- (void)setIsHaveSelect:(bool)isHaveSelect {
    _isHaveSelect = isHaveSelect;
    self.iconImgView.hidden = YES;
    [self.orderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}

@end

//补货人信息
@interface LxmYiJianBuHuoRenOrderCell ()

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *phoneLabel;//手机号

@property (nonatomic, strong) UILabel *rankLabel;//等级

@end

@implementation LxmYiJianBuHuoRenOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        [self addSubview:self.nameLabel];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.rankLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.phoneLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textColor = CharacterGrayColor;
    }
    return _phoneLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.font = [UIFont systemFontOfSize:10];
        _rankLabel.textColor = MainColor;
        _rankLabel.layer.cornerRadius = 3;
        _rankLabel.layer.borderWidth = 0.5;
        _rankLabel.layer.borderColor = MainColor.CGColor;
        
    }
    return _rankLabel;
}

- (void)setOrderModel:(LxmShopCenterOrderModel *)orderModel {
    _orderModel = orderModel;
   
    _nameLabel.text = _orderModel.t_name;
    _phoneLabel.text = _orderModel.t_tel;
    NSArray<YMRRoleTypeModel *> *roleArr = [YMRRoleTypeModel mj_objectArrayWithKeyValuesArray:[LxmTool ShareTool].roleTypeNameList];
    for (YMRRoleTypeModel * rModel in roleArr) {
        if ([_orderModel.role_type isEqualToString: rModel.role]) {
            _rankLabel.text = [NSString stringWithFormat:@" %@ ",rModel.name];
            break;
        }
    }
    
//    if ([_orderModel.role_type isEqualToString:@"-0.5"]){
//           _rankLabel.text = @" 小红包系列-vip会员";
//    } else if ([_orderModel.role_type isEqualToString:@"-0.4"]) {
//           _rankLabel.text = @" 小红包系列-高级会员 ";
//    } else if ([_orderModel.role_type isEqualToString:@"-0.3"]) {
//           _rankLabel.text = @" 小红包系列-荣誉会员 ";
//    } else if ([_orderModel.role_type isEqualToString:@"1.1"]) {
//            _rankLabel.text = @" 小红包系列-市服务商 ";
//    } else if ([_orderModel.role_type isEqualToString:@"2.1"]) {
//            _rankLabel.text = @" 小红包系列-省服务商 ";
//    } else if ([_orderModel.role_type isEqualToString:@"3.1"]) {
//            _rankLabel.text = @" 小红包系列-CEO ";
//    } else {
//        switch (_orderModel.role_type.intValue) {
//            case -1:
//                _rankLabel.text = @" 无 ";
//                break;
//            case 0:
//                _rankLabel.text = @" vip门店 ";
//                break;
//            case 1:
//                _rankLabel.text = @" 高级门店 ";
//                break;
//            case 2:
//                _rankLabel.text = @" 市服务商 ";
//                break;
//            case 3:
//                _rankLabel.text = @" 省服务商 ";
//                break;
//            case 4:
//                _rankLabel.text = @" CEO ";
//                break;
//            case 5:
//                _rankLabel.text = @" 总经销商 ";
//                break;
//            default:
//                break;
//        }
//    }
     
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
        
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        messageAttach.image = [UIImage imageNamed:@"ss"];
        messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
        //创建带有图片的富文本
        NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
//         [messageStr appendAttributedString:messageImageStr];
        
        //富文本中的文字
       NSString *messageText = _rankLabel.text;
    
    if (orderModel.suType.intValue == 1) {
        NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
        [messageStr appendAttributedString:messageTextStr];
    
        if (messageText.length >1) {
            [messageStr insertAttributedString:messageImageStr atIndex:1];
        }else {
            [messageStr insertAttributedString:messageImageStr atIndex:0];
        }
        
        _rankLabel.attributedText = messageStr;
    }
    
}


@end




@interface LxmYiJianBuHuoGoodsCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *numLabel;//数量

@end
@implementation LxmYiJianBuHuoGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(40);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImgView).offset(-10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.numLabel.mas_leading).offset(-5);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.numLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.backgroundColor = MainColor;
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:13];
        _numLabel.textColor = CharacterGrayColor;
    }
    return _numLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (void)setData {
    self.titleLabel.text = @"高端魅力修护套装";
    self.moneyLabel.text = @"¥198";
    self.numLabel.text = @"X2";
}

- (void)setOrderModel:(LxmShopCenterOrderGoodsModel *)orderModel {
    _orderModel = orderModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_orderModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _orderModel.good_name;
    CGFloat f = _orderModel.good_price.doubleValue;
    NSInteger d = _orderModel.good_price.integerValue;
    
    CGFloat f1 = _orderModel.proxy_price.doubleValue;
    NSInteger d1 = _orderModel.proxy_price.integerValue;
    
    if (self.isXiaJi) {
        f1 = _orderModel.down_price.doubleValue;
        d1 = _orderModel.down_price.integerValue;
    }
    
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:f1==d1 ? [NSString stringWithFormat:@"¥%ld ",d1] : [NSString stringWithFormat:@"¥%.2f ",f1] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:f==d ? [NSString stringWithFormat:@"¥%ld ",d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    _moneyLabel.attributedText = att;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _orderModel.num];
}

/**
 是否有选择按钮
 */
- (void)setIsHaveSelect:(bool)isHaveSelect {
    _isHaveSelect = isHaveSelect;
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
}


@end

@implementation LxmYiJianBuHuoDanFootView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
@end


//本地购物车cell
@interface LxmLocalGoodsCell()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *selectImgView;//选择背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@end

@implementation LxmLocalGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.selectImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self.contentView addSubview:self.numView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(50);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImgView).offset(-10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
        make.height.equalTo(@26);
    }];
}


- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
    }
    return _selectImgView;
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}

- (LxmNumView *)numView {
    if (!_numView) {
        _numView = [[LxmNumView alloc] init];
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _numView.numTF.delegate = self;
    }
    return _numView;
}

- (void)btnClick:(UIButton *)btn {
    [_numView endEditing:YES];
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
        }else {
            [SVProgressHUD showErrorWithStatus:@"受不了了,不能再少了!"];
            return;
        }
    }else {
        num ++;
    }
    _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    self.goodsModel.num = _numView.numTF.text;
    [[LxmTool ShareTool] saveSubGoods:self.goodsModel];
    [LxmEventBus sendEvent:@"localListUpdate" data:nil];
    if (self.modifySuccessBlock) {
        self.modifySuccessBlock(self.goodsModel);
    }
}

- (void)setGoodsModel:(LxmHomeGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    _selectImgView.image = [UIImage imageNamed:_goodsModel.isSelected ? @"xuanzhong_y" : @"xuanzhong_n"];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.titleLabel.text = _goodsModel.good_name;
    
    CGFloat f1 = _goodsModel.good_price.doubleValue;
    NSInteger d1 = _goodsModel.good_price.integerValue;
    
    CGFloat f = _goodsModel.proxy_price.doubleValue;
    NSInteger d = _goodsModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:d == f ? [NSString stringWithFormat:@"¥%ld ",(long)d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:d1 == f1 ? [NSString stringWithFormat:@"¥%ld ",(long)d1] : [NSString stringWithFormat:@"¥%.2f ",f1]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = _goodsModel.num;
}

/**
 选中不选中
 */
- (void)selectBottonClick {
    if (self.selectClick) {
        self.selectClick(self.goodsModel);
    }
}

- (void)setData {
    self.titleLabel.text = @"高端魅力修护套装";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"¥0 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = @"1";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.intValue < 1) {
        _numView.numTF.text = @"1";
        [SVProgressHUD showErrorWithStatus:@"至少购买一件商品!"];
        return;
    }
    self.goodsModel.num = _numView.numTF.text;
    [[LxmTool ShareTool] saveSubGoods:self.goodsModel];
    [LxmEventBus sendEvent:@"localListUpdate" data:nil];
    if (self.modifySuccessBlock) {
        self.modifySuccessBlock(self.goodsModel);
    }
}


@end


//本地购物车cell
@interface LxmLocalGoodsCell1 ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *selectImgView;//选择背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *kucunJinZhangLabel;//库存不足

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@end

@implementation LxmLocalGoodsCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
   
   

    [self addSubview:self.selectImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self.contentView addSubview:self.numView];
    [self addSubview:self.kucunJinZhangLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(50);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.kucunJinZhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kucunJinZhangLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
        make.height.equalTo(@26);
    }];
}


- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
    }
    return _selectImgView;
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)kucunJinZhangLabel {
    if (!_kucunJinZhangLabel) {
        _kucunJinZhangLabel = [[UILabel alloc] init];
        _kucunJinZhangLabel.font = [UIFont systemFontOfSize:12];
        _kucunJinZhangLabel.textColor = MainColor;
        _kucunJinZhangLabel.text = @"库存紧张";
        _kucunJinZhangLabel.hidden = YES;
    }
    return _kucunJinZhangLabel;
}


- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}

- (LxmNumView *)numView {
    if (!_numView) {
        _numView = [[LxmNumView alloc] init];
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _numView.numTF.delegate = self;
    }
    return _numView;
}

- (void)btnClick:(UIButton *)btn {
    [_numView endEditing:YES];
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
            _numView.numTF.text = [NSString stringWithFormat:@"%ld", num];
            self.goodsModel.num = _numView.numTF.text;
            [[LxmTool ShareTool] saveShengJiSubGoods:self.goodsModel];
            [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
            if (self.modifySuccessBlock) {
                self.modifySuccessBlock(self.goodsModel);
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"受不了了,不能再少了!"];
            return;
        }
    }else {
//        NSString *maxNum = self.goodsModel.up_num.integerValue > self.goodsModel.com_num.integerValue ? self.goodsModel.up_num : self.goodsModel.com_num;
//        if (num + 1 > maxNum.intValue) {
//            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"库存不足!" message:[NSString stringWithFormat:@"%@的库存量:%ld",self.goodsModel.good_name,maxNum.integerValue] preferredStyle:UIAlertControllerStyleAlert];
//            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
//            [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
//        } else {
            num ++;
            _numView.numTF.text = [NSString stringWithFormat:@"%ld", num];
            self.goodsModel.num = _numView.numTF.text;
            [[LxmTool ShareTool] saveShengJiSubGoods:self.goodsModel];
            [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
            if (self.modifySuccessBlock) {
                self.modifySuccessBlock(self.goodsModel);
            }
//        }
    }
}

- (void)setGoodsModel:(LxmHomeGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
//    NSString *maxNum = _goodsModel.up_num.integerValue > _goodsModel.com_num.integerValue ? _goodsModel.up_num : _goodsModel.com_num;
//    if (_goodsModel.num.floatValue > maxNum.floatValue) {
//        _kucunJinZhangLabel.hidden = NO;
//        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.kucunJinZhangLabel.mas_bottom).offset(10);
//            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
//            make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
//        }];
//    } else {
        _kucunJinZhangLabel.hidden = YES;
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
        }];
//    }
    _selectImgView.image = [UIImage imageNamed:_goodsModel.isSelected ? @"xuanzhong_y" : @"xuanzhong_n"];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.titleLabel.text = _goodsModel.good_name;
    
    CGFloat f1 = _goodsModel.good_price.doubleValue;
    NSInteger d1 = _goodsModel.good_price.integerValue;
    
    CGFloat f = _goodsModel.proxy_price.doubleValue;
    NSInteger d = _goodsModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:d == f ? [NSString stringWithFormat:@"¥%ld ",(long)d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:d1 == f1 ? [NSString stringWithFormat:@"¥%ld ",(long)d1] : [NSString stringWithFormat:@"¥%.2f ",f1]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = _goodsModel.num;
}

/**
 选中不选中
 */
- (void)selectBottonClick {
    if (self.selectClick) {
        self.selectClick(self.goodsModel);
    }
}

- (void)setData {
    self.titleLabel.text = @"高端魅力修护套装";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"¥0 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = @"1";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_numView endEditing:YES];
    if (textField.text.intValue < 1) {
        _numView.numTF.text = @"1";
        [SVProgressHUD showErrorWithStatus:@"至少购买一件商品!"];
        return;
    }
    
//    NSString *maxNum = self.goodsModel.up_num.integerValue > self.goodsModel.com_num.integerValue ? self.goodsModel.up_num : self.goodsModel.com_num;
//    WeakObj(self);
//    if (maxNum.intValue == 0) {
//        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"库存不足!" message:[NSString stringWithFormat:@"%@的库存量:%ld",self.goodsModel.good_name,maxNum.integerValue] preferredStyle:UIAlertControllerStyleAlert];
//        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
//        [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
//        return;
//    } else {
//        if (_numView.numTF.text.integerValue > maxNum.integerValue) {
//            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"库存不足!" message:[NSString stringWithFormat:@"%@的库存量:%ld",self.goodsModel.good_name,maxNum.integerValue] preferredStyle:UIAlertControllerStyleAlert];
//            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                _numView.numTF.text = maxNum;
//                selfWeak.goodsModel.num = maxNum;
//                [[LxmTool ShareTool] saveShengJiSubGoods:self.goodsModel];
//                [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
//                if (self.modifySuccessBlock) {
//                    self.modifySuccessBlock(self.goodsModel);
//                }
//            }]];
//            [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
//        } else {
            self.goodsModel.num = _numView.numTF.text;
            [[LxmTool ShareTool] saveShengJiSubGoods:self.goodsModel];
            [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
            if (self.modifySuccessBlock) {
                self.modifySuccessBlock(self.goodsModel);
            }
//        }
//    }

}

@end
