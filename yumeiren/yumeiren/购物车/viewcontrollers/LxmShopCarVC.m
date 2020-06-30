//
//  LxmShopCarVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCarVC.h"
#import "LxmShopCarView.h"
#import "LxmPayVC.h"
#import "LxmGoodsDetailVC.h"
#import "LxmTabBarVC.h"
#import "LxmShengJiVC.h"

@interface LxmShopCarVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmShopCarBottomView *bottomView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCarModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, assign) CGFloat allPrice;//总价

@property (nonatomic, assign) CGFloat proxyPrice;//代理总价

@property (nonatomic, strong) NSMutableDictionary *isSelectedDictionary;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@property (nonatomic, assign) BOOL noshow;

@end

@implementation LxmShopCarVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您还没有添加商品信息呢!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)saveSelectedDict {
    [NSUserDefaults.standardUserDefaults setObject:self.isSelectedDictionary forKey:@"isExiseDict"];
    [NSUserDefaults.standardUserDefaults synchronize];
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
        [_bottomView.allSelectButton addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.hidden = YES;
        WeakObj(self);
        _bottomView.jiesuanBlock = ^{
            [selfWeak bottomViewAction];
        };
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"购物袋";
    self.isSelectedDictionary = [NSMutableDictionary dictionary];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"isExiseDict"];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [self.isSelectedDictionary addEntriesFromDictionary:dict];
    }
    
    [self initSubviews];
    [LxmEventBus registerEvent:@"addCarSuccess" block:^(id data) {
        self.noshow = YES;
        self.dataArr = [NSMutableArray array];
        self.allPageNum = 1;
        self.page = 1;
        [self loadData];
    }];
    /* 购物车结算成功 */
    [LxmEventBus registerEvent:@"jiesuanSuccess" block:^(id data) {
        [self.isSelectedDictionary removeAllObjects];
        self.dataArr = [NSMutableArray array];
        self.allPageNum = 1;
        self.page = 1;
        [self loadData];
    }];
    
    
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
        make.height.equalTo(@60);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmShopCarCell"];
    if (!cell) {
        cell = [[LxmShopCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmShopCarCell"];
    }
    if (self.dataArr.count > indexPath.row) {
      cell.carModel = self.dataArr[indexPath.row];
    }
    WeakObj(self);
    cell.selectClick = ^(LxmShopCarModel *carModel) {
        carModel.isSelected = !carModel.isSelected;
        if (carModel.id) {
            selfWeak.isSelectedDictionary[carModel.id] = @(carModel.isSelected);
            [selfWeak saveSelectedDict];
        }
        
        if (carModel.isSelected) {
            selfWeak.allPrice += carModel.good_price.doubleValue * carModel.num.intValue;
            selfWeak.proxyPrice += carModel.proxy_price.doubleValue * carModel.num.intValue;
        }else {
            selfWeak.allPrice -= carModel.good_price.doubleValue * carModel.num.intValue;
            selfWeak.proxyPrice -= carModel.proxy_price.doubleValue * carModel.num.intValue;
        }
        [selfWeak.tableView reloadData];
        
        NSInteger count = 0;
        for (LxmShopCarModel *model in selfWeak.dataArr) {
            if (model.isSelected) {
                count ++;
            }
        }
        self.bottomView.allImgView.image = [UIImage imageNamed:count == selfWeak.dataArr.count ? @"xuanzhong_y" : @"xuanzhong_n"];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"代理总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.proxyPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        
        
        self.bottomView.yuanPrice.attributedText = att;
        self.bottomView.vipPrice.text = [NSString stringWithFormat:@"零售总价: ¥%.2f",self.allPrice];
    };
    cell.modifyCarSuccess = ^(LxmShopCarModel *model) {
        selfWeak.allPrice = 0;
        selfWeak.proxyPrice = 0;
        NSInteger count = 0;
        for (LxmShopCarModel *model in self.dataArr) {
            if (model.isSelected) {
                selfWeak.allPrice += model.good_price.doubleValue * model.num.intValue;
                selfWeak.proxyPrice += model.proxy_price.doubleValue * model.num.intValue;
                count ++;
            }
        }
        self.bottomView.allImgView.image = [UIImage imageNamed:count == selfWeak.dataArr.count ? @"xuanzhong_y" : @"xuanzhong_n"];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"代理总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.proxyPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        
        self.bottomView.yuanPrice.attributedText = att;
        self.bottomView.vipPrice.text = [NSString stringWithFormat:@"零售总价: ¥%.2f",self.allPrice];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCarModel *model = self.dataArr[indexPath.row];
    CGFloat h = [model.good_name getSizeWithMaxSize:CGSizeMake(ScreenW - 155, 9999) withBoldFontSize:15].height;
//    NSString *maxNum = model.good_num.integerValue > model.com_num.integerValue ? model.good_num : model.com_num;
    CGFloat kucunH = 0;
//    if (model.num.integerValue > maxNum.integerValue) {
//        kucunH = 10 + 20;
//    } else {
//        kucunH = 10;
//    }
    CGFloat cellH  = 15 + h + kucunH + 10 + 26 + 15;
    return cellH > 120 ? cellH : 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmGoodsDetailVC *vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.goodsID = self.dataArr[indexPath.row].good_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            StrongObj(self);
            LxmShopCarModel *carModel = self.dataArr[indexPath.row];
            [self deleteCar:carModel];
        }]];
    [self presentViewController:alertView animated:YES completion:nil];

}


/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            if (!self.noshow) {
                [SVProgressHUD show];
            }
        }
        [LxmNetworking networkingPOST:cart_list parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page)} returnClass:LxmShopCarRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCarRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                WeakObj(self);
                selfWeak.allPrice = 0;
                selfWeak.proxyPrice = 0;
                NSInteger count = 0;
                for (LxmShopCarModel *model in self.dataArr) {
                    if (model.id) {
                        model.isSelected = [self.isSelectedDictionary[model.id] boolValue];
                        if (model.isSelected) {
                            selfWeak.allPrice += model.good_price.doubleValue * model.num.intValue;
                            selfWeak.proxyPrice += model.proxy_price.doubleValue * model.num.intValue;
                            count ++;
                        }
                        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"代理总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
                        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.proxyPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
                        [att appendAttributedString:str];
                        
                        
                        self.bottomView.yuanPrice.attributedText = att;
                        self.bottomView.vipPrice.text = [NSString stringWithFormat:@"零售总价: ¥%.2f",self.allPrice];
                        self.bottomView.allImgView.image = [UIImage imageNamed:count == selfWeak.dataArr.count ? @"xuanzhong_y" : @"xuanzhong_n"];
                    }
                }
                self.emptyView.hidden = self.dataArr.count > 0;
                self.bottomView.hidden = self.dataArr.count == 0;
                self.page ++;
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
 购物车全选操作
 */
- (void)allSelectClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.bottomView.allImgView.image = [UIImage imageNamed:btn.selected ? @"xuanzhong_y" : @"xuanzhong_n"];
    WeakObj(self);
    self.allPrice = 0;
    self.proxyPrice = 0;
    NSInteger count = 0;
    for (LxmShopCarModel *model in self.dataArr) {
        if (btn.selected) {
            model.isSelected = YES;
            selfWeak.allPrice += model.good_price.doubleValue * model.num.intValue;
            selfWeak.proxyPrice += model.proxy_price.doubleValue * model.num.intValue;
            count ++;
        }else {
            model.isSelected = NO;
        }
        if (model.id) {
            selfWeak.isSelectedDictionary[model.id] = @(model.isSelected);
            [selfWeak saveSelectedDict];
        }
    }
    [self.tableView reloadData];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.bottomView.vipPrice.attributedText = att;
    self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
}

/**
 底部按钮 结算或删除操作
 */
- (void)bottomViewAction {
    /* 结算 */
    _bottomView.jiesuanButton.userInteractionEnabled = NO;
    WeakObj(self);
    void(^jiesuanBlock)(void) = ^(){
        StrongObj(self);
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];
        NSMutableArray *buzuArr = [NSMutableArray array];
        NSMutableArray *buzuGoodsArr = [NSMutableArray array];
        for (LxmShopCarModel *model in self.dataArr) {
            if (model.isSelected) {
                [tempArr addObject:model];
                [ids addObject:model.id];
                NSString *maxNum = model.good_num.integerValue > model.com_num.integerValue ? model.good_num : model.com_num;
                if (model.num.doubleValue > maxNum.doubleValue) {
                    model.pinjieStr = [NSString stringWithFormat:@"%@的库存量:%ld",model.good_name,(long)maxNum.integerValue];
                    model.maxNum = maxNum;
                    [buzuGoodsArr addObject:model];
                    [buzuArr addObject:model.pinjieStr];
                }
            }
        }
        if (tempArr.count == 0) {
            _bottomView.jiesuanButton.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:@"您还没有选择宝贝哦!"];
            return;
        }
        
        
        CGFloat money = LxmTool.ShareTool.userModel.upPayMoney.doubleValue;
        if (money == 0) {
            if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"0"] ||[LxmTool.ShareTool.userModel.roleType isEqualToString:@"1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"4"]) {//正常角色
                CGFloat roletype = LxmTool.ShareTool.userModel.roleType.floatValue;
                if (roletype == 4) {//ceo直接下单
                   [selfWeak settleCarOrder:[ids componentsJoinedByString:@","] goods:tempArr];
                }  else {//其他取正常上级的升级金额
                    static CGFloat shengjiMoney = 0;
                    [LxmNetworking networkingPOST:get_role_info parameters:@{@"token":SESSION_TOKEN} returnClass:LxmShengjiRootModel.class success:^(NSURLSessionDataTask *task, LxmShengjiRootModel *responseObject) {
                        if (responseObject.key.intValue == 1000) {
                            for (LxmShengjiModel *m in responseObject.result.list) {
                                
                                if (roletype + 1 == m.roleType.floatValue) {
                                    shengjiMoney = m.payMoney.floatValue;
                                    if (selfWeak.proxyPrice >= shengjiMoney) {
                                    _bottomView.jiesuanButton.userInteractionEnabled = YES;
                                        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"您已达到升级所满足的最低购物金额,进入升级通道,下单更便宜哦!" message:@"是否进入升级通道?" preferredStyle:UIAlertControllerStyleAlert];
                                        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                                        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                                LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                                                vc.hidesBottomBarWhenPushed = YES;
                                                [selfWeak.navigationController pushViewController:vc animated:YES];
                                        }]];
                                        [selfWeak presentViewController:alertView animated:YES completion:nil];
                                    } else {
                                        [selfWeak settleCarOrder:[ids componentsJoinedByString:@","] goods:tempArr];
                                    }
                                    break;
                                }
                            }
                        }
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        _bottomView.jiesuanButton.userInteractionEnabled = YES;
                    }];
                }
                
            } else {
                //减肥角色的话 可以升级正常的 也可以升级减肥的 只判断减肥上级的升级金额
                if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) {//减肥CEO 直接下单
                   [selfWeak settleCarOrder:[ids componentsJoinedByString:@","] goods:tempArr];
                } else {
                    static CGFloat shengjiMoney = 0;
                    [LxmNetworking networkingPOST:get_role_info parameters:@{@"token":SESSION_TOKEN} returnClass:LxmShengjiRootModel.class success:^(NSURLSessionDataTask *task, LxmShengjiRootModel *responseObject) {
                        if (responseObject.key.intValue == 1000) {
                            for (LxmShengjiModel *m in responseObject.result.list) {
                                if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"]) {
                                    if ([m.roleType isEqualToString:@"-0.4"]) {
                                        shengjiMoney = m.payMoney.floatValue;
                                        break;
                                    }
                                } else if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"]) {
                                    if ([m.roleType isEqualToString:@"-0.3"]) {
                                        shengjiMoney = m.payMoney.floatValue;
                                        break;
                                    }
                                } else if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"]) {
                                    if ([m.roleType isEqualToString:@"1.1"]) {
                                        shengjiMoney = m.payMoney.floatValue;
                                        break;
                                    }
                                } else if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"]) {
                                    if ([m.roleType isEqualToString:@"2.1"]) {
                                        shengjiMoney = m.payMoney.floatValue;
                                        break;
                                    }
                                } else if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"]) {
                                    if ([m.roleType isEqualToString:@"3.1"]) {
                                        shengjiMoney = m.payMoney.floatValue;
                                        break;
                                    }
                                }
                            }
                            if (selfWeak.proxyPrice >= shengjiMoney) {
                                 _bottomView.jiesuanButton.userInteractionEnabled = YES;
                                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"您已达到升级所满足的最低购物金额,进入升级通道,下单更便宜哦!" message:@"是否进入升级通道?" preferredStyle:UIAlertControllerStyleAlert];
                                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                        LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [selfWeak.navigationController pushViewController:vc animated:YES];
                                }]];
                                [selfWeak presentViewController:alertView animated:YES completion:nil];
                            } else {
                                [selfWeak settleCarOrder:[ids componentsJoinedByString:@","] goods:tempArr];
                            }
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        _bottomView.jiesuanButton.userInteractionEnabled = YES;
                    }];
                }
            }
            
        } else {
            _bottomView.jiesuanButton.userInteractionEnabled = YES;
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"您已达到升级所满足的最低购物金额,进入升级通道,下单更便宜哦!" message:@"是否进入升级通道?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [selfWeak.navigationController pushViewController:vc animated:YES];
            }]];
            [selfWeak presentViewController:alertView animated:YES completion:nil];
        }
    };
    
    void(^manZuLowMoneyBlock)(void) = ^(){
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        CGFloat f = LxmTool.ShareTool.userModel.lowMoney.doubleValue;
        NSInteger d = LxmTool.ShareTool.userModel.lowMoney.integerValue;
        NSString *tempStr = f == d ? [NSString stringWithFormat:@"您还没达到购物最低满足价格%ld元,请继续购物!",(long)d] : [NSString stringWithFormat:@"您还没达到购物最低满足价格%.2f元,请继续购物!",f];
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:tempStr preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    };
    
    void(^baoyouMoneyBlock)(void) = ^(){
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"满%.2f包邮,是否继续购物",LxmTool.ShareTool.userModel.postMoney.doubleValue] preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"结算" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            jiesuanBlock();
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"继续购物" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    };
    
    
    if (LxmTool.ShareTool.userModel.roleType.intValue == -1) {
        if (self.isDeep) {
            jiesuanBlock();
        } else {
            if (self.proxyPrice < LxmTool.ShareTool.userModel.postMoney.doubleValue) {
                baoyouMoneyBlock();
            } else {
                jiesuanBlock();
            }
        }
    } else {
        if (self.proxyPrice < LxmTool.ShareTool.userModel.lowMoney.doubleValue) {
            manZuLowMoneyBlock();
        } else {
            if (self.isDeep) {
                jiesuanBlock();
            } else {
                if (self.proxyPrice < LxmTool.ShareTool.userModel.postMoney.doubleValue) {
                    baoyouMoneyBlock();
                } else {
                    jiesuanBlock();
                }
            }
        }
    }
}

/**
 购物车结算下单
 */
- (void)settleCarOrder:(NSString *)ids goods:(NSArray *)goods {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:settle_cart_order parameters:@{@"token":SESSION_TOKEN,@"cartIds":ids} returnClass:LxmShopCarOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCarOrderRootModel *responseObject) {
        [SVProgressHUD dismiss];
        StrongObj(self);
        if (responseObject.key.integerValue == 1000) {
            _bottomView.jiesuanButton.userInteractionEnabled = YES;
            [self gotoPay:responseObject.result.map];
            [self.isSelectedDictionary removeAllObjects];
            self.dataArr = [NSMutableArray array];
            self.allPageNum = 1;
            self.page = 1;
            [self loadData];
        } else {
            _bottomView.jiesuanButton.userInteractionEnabled = YES;
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

/**
 修改购物车
 */
- (void)modifyCar:(NSString *)numStr model:(LxmShopCarModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"num"] = numStr;
    dict[@"id"] = model.id;
    dict[@"goodId"] = model.good_id;
    WeakObj(self);
    [LxmNetworking networkingPOST:up_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            NSInteger n = model.num.intValue - model.maxNum.intValue;
            selfWeak.allPrice -= model.good_price.doubleValue * n;
            selfWeak.proxyPrice -= model.proxy_price.doubleValue * n;
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"代理总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.proxyPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            
            self.bottomView.yuanPrice.attributedText = att;
            self.bottomView.vipPrice.text = [NSString stringWithFormat:@"零售总价: ¥%.2f",self.allPrice];
            model.num = model.maxNum;
            [selfWeak.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/**
 删除购物车
 */
- (void)deleteCar:(LxmShopCarModel *)carModel {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:del_cart parameters:@{@"token":SESSION_TOKEN,@"idStr":carModel.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        StrongObj(self);
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除!"];
            [self.dataArr removeObject:carModel];
            self.emptyView.hidden = self.dataArr.count > 0;
            self.bottomView.hidden = self.dataArr.count == 0;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


/**
 去支付
 */
- (void)gotoPay:(LxmShopCarOrderModel *)model {
    LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_gwcJieSuan];
    vc.orderModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
