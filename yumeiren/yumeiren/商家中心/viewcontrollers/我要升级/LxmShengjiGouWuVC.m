//
//  LxmShengjiGouWuVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShengjiGouWuVC.h"
#import "LxmShopCarView.h"
#import "LxmPanButton.h"
#import "LxmYiJianBuHuoVC.h"
#import "LxmYiJianBuHuoVC1.h"

#import "LxmShopVC.h"


#import "LxmPayVC.h"

@interface LxmShengjiGouWuVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@property (nonatomic, strong) LxmShopCarBottomView *bottomView;

@property (nonatomic, strong) LxmPanButton *addCarButton;//加入购物车的悬浮按钮

@property (nonatomic, assign) CGFloat allPrice;//总价

@property (nonatomic, assign) CGFloat proxyPrice;//代理总价

@end

@implementation LxmShengjiGouWuVC


- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您还没有添加呢!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


- (LxmPanButton *)addCarButton {
    if (!_addCarButton) {
        _addCarButton = [[LxmPanButton alloc] init];
        _addCarButton.marginInsets = UIEdgeInsetsMake(15, 15, 65, 15);
        WeakObj(self);
        _addCarButton.panBlock = ^{
            selfWeak.bottomView.allImgView.image = [UIImage imageNamed: @"xuanzhong_n"];
            LxmShopVC *vc = [[LxmShopVC alloc] init];
            vc.roleType = selfWeak.roleType;
            vc.isDeep = YES;
            vc.isAddLocolGoods = YES;
            vc.isGotoGouwuChe = NO;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _addCarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    for (LxmHomeGoodsModel *m in LxmTool.ShareTool.shengjiGoodsList) {
        NSLog(@"%@",m);
    }
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
    self.navigationItem.title = @"升级购物";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initSubviews];
    WeakObj(self);
    [LxmEventBus registerEvent:@"localListUpdate1" block:^(id data) {
        selfWeak.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
        [selfWeak.tableView reloadData];
    }];
    [self setBottomSelectStatus];
    self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.emptyView];
    [self.view addSubview:self.addCarButton];

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
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LxmTool ShareTool].shengjiGoodsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmLocalGoodsCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmLocalGoodsCell1"];
    if (!cell) {
        cell = [[LxmLocalGoodsCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmLocalGoodsCell1"];
    }
    cell.goodsModel = [LxmTool ShareTool].shengjiGoodsList[indexPath.row];
    WeakObj(self);
    cell.modifySuccessBlock = ^(LxmHomeGoodsModel *goodsModel) {
        StrongObj(self);
        self.allPrice = 0;
        self.proxyPrice = 0;
        for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].shengjiGoodsList) {
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
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeGoodsModel *model = [LxmTool ShareTool].shengjiGoodsList[indexPath.row];
    [[LxmTool ShareTool] delShengJiSubGoods:model];
    self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeGoodsModel *model = [LxmTool ShareTool].shengjiGoodsList[indexPath.row];
    CGFloat h = [model.good_name getSizeWithMaxSize:CGSizeMake(ScreenW - 155, 9999) withBoldFontSize:15].height;
//    NSString *maxNum = model.up_num.integerValue > model.up_num.integerValue ? model.up_num : model.com_num;
    CGFloat kucunH = 0;
//    if (model.num.integerValue > maxNum.integerValue) {
//        kucunH = 10 + 20;
//    } else {
//        kucunH = 0;
//    }
    CGFloat cellH  = 15 + h + kucunH + 10 + 26 + 15;
    return cellH > 120 ? cellH : 120;
}

- (void)allSelectClick:(BOOL)isSelect {
    NSInteger count1 = 0;
    self.allPrice = 0;
    self.proxyPrice = 0;
    for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].shengjiGoodsList) {
        m1.isSelected = isSelect;
        if (m1.isSelected) {
            self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
            self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
        }
        [[LxmTool ShareTool] saveShengJiSubGoods:m1];
        count1++;
    }
    self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
    [self.tableView reloadData];
    self.bottomView.allImgView.image = [UIImage imageNamed:isSelect ? @"xuanzhong_y" : @"xuanzhong_n"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.bottomView.vipPrice.attributedText = att;
    self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
    self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //单选
    LxmHomeGoodsModel *model = [LxmTool ShareTool].shengjiGoodsList[indexPath.row];
    model.isSelected = !model.isSelected;
    [[LxmTool ShareTool] saveShengJiSubGoods:model];
    self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
    [self.tableView reloadData];
    [self setBottomSelectStatus];
}

/**
 设置底部选中状态
 */
- (void)setBottomSelectStatus {
    if ([LxmTool ShareTool].shengjiGoodsList.count > 0) {
        NSInteger count1 = 0;
        self.allPrice = 0;
        self.proxyPrice = 0;
        for (LxmHomeGoodsModel *m1 in [LxmTool ShareTool].shengjiGoodsList) {
            if (m1.isSelected) {
                self.allPrice += m1.good_price.doubleValue * m1.num.intValue;
                self.proxyPrice += m1.proxy_price.doubleValue * m1.num.intValue;
                count1++;
            }
        }
        
        self.bottomView.allImgView.image = [UIImage imageNamed:[LxmTool ShareTool].shengjiGoodsList.count == count1 ? @"xuanzhong_y" : @"xuanzhong_n"];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", self.allPrice] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        self.bottomView.vipPrice.attributedText = att;
        self.bottomView.yuanPrice.text = [NSString stringWithFormat:@"代理总价: ¥%.2f",self.proxyPrice];
    } else {
        self.bottomView.allImgView.image = [UIImage imageNamed: @"xuanzhong_n"];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"零售总价: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"0" attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        self.bottomView.vipPrice.attributedText = att;
        self.bottomView.yuanPrice.text = @"代理总价: 0";
    }
   
}


/**
 结算
 */
- (void)jiesuanClick {
    _bottomView.jiesuanButton.userInteractionEnabled = NO;
    WeakObj(self);
    void(^jiesuanBlock)(void) = ^(){
        [selfWeak jiesuan];
    };
    void(^manzuUpMoneyBlock)(void) = ^(){
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        CGFloat f = self.shengjiModel.payMoney.doubleValue;
        NSInteger d = self.shengjiModel.payMoney.integerValue;
        NSString *tempStr = f == d ? [NSString stringWithFormat:@"您还没达到购物升级满足最低价格%ld元,请继续购物!",d] : [NSString stringWithFormat:@"您还没达到购物升级满足最低价格%.2f元,请继续购物!",f];
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:tempStr preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"继续购物" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertView animated:YES completion:nil];
    };
    
    void(^manZuLowMoneyBlock)(void) = ^(){
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        CGFloat f = self.shengjiModel.lowMoney.doubleValue;
        NSInteger d = self.shengjiModel.lowMoney.integerValue;
        NSString *tempStr = f == d ? [NSString stringWithFormat:@"您还没达到购物最低满足价格%ld元,请继续购物!",d] : [NSString stringWithFormat:@"您还没达到购物最低满足价格%.2f元,请继续购物!",f];
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:tempStr preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    };
    
    if (LxmTool.ShareTool.userModel.roleType.intValue == -1) {
        if (self.shengjiModel.payMoney.doubleValue > 0) {//有升级中的状态 提示要满足升级金额吗
            if (self.proxyPrice < self.shengjiModel.payMoney.doubleValue) {
                manzuUpMoneyBlock();
            } else {
                jiesuanBlock();
            }
        } else {
            jiesuanBlock();
        }
    } else {
        if (self.proxyPrice < self.shengjiModel.lowMoney.doubleValue) {
            manZuLowMoneyBlock();
        } else {
            if (self.shengjiModel.payMoney.doubleValue > 0) {//有升级中的状态 提示要满足升级金额吗
                if (self.proxyPrice < self.shengjiModel.payMoney.doubleValue) {
                    _bottomView.jiesuanButton.userInteractionEnabled = YES;
                    CGFloat f = self.shengjiModel.payMoney.doubleValue;
                    NSInteger d = self.shengjiModel.payMoney.integerValue;
                    NSString *tempStr = f == d ? [NSString stringWithFormat:@"您还没达到升级最低满足的购物价格%ld元,是否继续购物!",(long)d] : [NSString stringWithFormat:@"您还没达到升级最低满足的购物价格%.2f元,是否继续购物!",f];
                    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:tempStr preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"结算" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        jiesuanBlock();
                    }]];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"继续购物" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                } else{
                    jiesuanBlock();
                }
                
            } else {
                jiesuanBlock();
            }
        }
    }
}
//结算
- (void)jiesuan {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (LxmHomeGoodsModel *m2 in [LxmTool ShareTool].shengjiGoodsList) {
        if (m2.isSelected) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:m2.num forKey:@"num"];
            [dic setValue:m2.id forKey:@"goodId"];
            [dic setValue:m2.proxy_price forKey:@"proxyPrice"];
            [tempArr addObject:dic];
            if (dic.count != 3) {
                NSLog(@"66");
            }
        }
    }
    if (tempArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选中任何商品,请选择后下单!"];
        return;
    }
    NSString *goods = [NSString convertToJsonData:tempArr];
    
    ///app/user/up_buy_good 升级购物下单
    //参数 token,goods（和补货接口传的格式一样）
    //返回：
    //9100 库存不足  返回  list[goodName,goodId,comNum(公司库存),goodNum(上级库存)]
    //1000 成功   map[orderId,price,balance]
    ///app/user/role_ceo 升级ceo
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"goods" : goods
                           };
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:up_buy_good parameters:dict returnClass:LxmBuHuoRootModel.class success:^(NSURLSessionDataTask *task, LxmBuHuoRootModel *responseObject) {
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [[LxmTool ShareTool] delShengJiAllGoods];
            [selfWeak setBottomSelectStatus];
            self.emptyView.hidden = LxmTool.ShareTool.shengjiGoodsList.count > 0;
            [selfWeak.tableView reloadData];
            LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_shengjigouwu];
            vc.shengjiGouwuModel = responseObject.result.map;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        } else if (responseObject.key.integerValue == 2981) {
            CGFloat price = responseObject.result.map.price.doubleValue;
            CGFloat lowMoney = responseObject.result.map.lowMoney.doubleValue;
            if (price < lowMoney) {
                [UIAlertController showAlertWithmessage:[NSString stringWithFormat:@"请满足最低下单金额%@元",responseObject.result.map.lowMoney]];
            } else {
                [[LxmTool ShareTool] delShengJiAllGoods];
                LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_shengjigouwu];
                vc.shengjiGouwuModel = responseObject.result.map;
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }
        }
        else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _bottomView.jiesuanButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}



@end
