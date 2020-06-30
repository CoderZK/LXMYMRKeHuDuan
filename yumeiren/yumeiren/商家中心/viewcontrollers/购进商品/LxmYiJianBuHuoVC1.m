//
//  LxmYiJianBuHuoVC1.m
//  yumeiren
//
//  Created by 李晓满 on 2019/10/31.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmYiJianBuHuoVC1.h"
#import "LxmPayVC.h"

@interface LxmYiJianBuHuoVC1 ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmYiJianBuHuoBottom1 *bottomView;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderGoodsModel *>*dataArr;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*tempDataArr;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterModel *> *myKuCunDataArr;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmYiJianBuHuoVC1

//good_stock_list
//参数：token
//返回
//list
// id, good_num, good_name, list_pic, good_price,proxy_price

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您还没有补货单呢!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmYiJianBuHuoBottom1 *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmYiJianBuHuoBottom1 alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        WeakObj(self);
        _bottomView.bottomBuhuoClickBlock = ^{
            [selfWeak jiesuanClick];
        };
    }
    return _bottomView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"一键补货";
    [self initSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myKuCunDataArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.tempDataArr = [NSMutableArray array];
    [self loadData1];
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
                [selfWeak.tempDataArr removeAllObjects];
                for (LxmShopCenterOrderModel *m in tempArr) {
                    if (m.id && m.id == selfWeak.model.id) {
                        [selfWeak.tempDataArr addObject:m];
                        [selfWeak.dataArr addObjectsFromArray:m.sub];
                        break;
                    }
                }
                for (LxmShopCenterModel *kuncunModel in selfWeak.myKuCunDataArr) {
                    for (LxmShopCenterOrderGoodsModel *buhuoGoods in selfWeak.dataArr) {
                        if (buhuoGoods.good_id.intValue == kuncunModel.good_id.intValue) {
                            if (kuncunModel.good_num.intValue < buhuoGoods.num.intValue) {
                                kuncunModel.buhuoNum = @(buhuoGoods.num.intValue - kuncunModel.good_num.intValue).stringValue;
                                kuncunModel.tempbuhuoNum = kuncunModel.buhuoNum;
                                kuncunModel.isBuhuo = YES;
                            } else {
                                kuncunModel.buhuoNum = @"0";
                                kuncunModel.tempbuhuoNum = @"0";
                                kuncunModel.isBuhuo = NO;
                            }
                            break;
                        }
                    }
                }
            } else {
                NSArray *tempArr = responseObject.result.list;
                [selfWeak.dataArr removeAllObjects];
                [selfWeak.tempDataArr removeAllObjects];
                [selfWeak.tempDataArr addObjectsFromArray:tempArr];
                for (LxmShopCenterOrderModel *m in tempArr) {
                    for (LxmShopCenterOrderGoodsModel *good in m.sub) {
                        if (selfWeak.dataArr.count == 0) {
                            [selfWeak.dataArr addObject:good];
                        } else {
                            BOOL isHave = NO;
                            LxmShopCenterOrderGoodsModel *te;
                            for (LxmShopCenterOrderGoodsModel *tempgood in selfWeak.dataArr) {
                                if (tempgood.good_id.intValue == good.good_id.intValue) {
                                    isHave = YES;
                                    te = tempgood;
                                    break;
                                }
                            }
                            if (isHave) {
                                te.num = @(te.num.intValue + good.num.intValue).stringValue;
                            } else {
                                [selfWeak.dataArr addObject:good];
                            }
                        }
                    }
                }
            }
            
            for (LxmShopCenterModel *kuncunModel in selfWeak.myKuCunDataArr) {
                LxmShopCenterOrderGoodsModel *te;
                for (LxmShopCenterOrderGoodsModel *buhuoGoods in selfWeak.dataArr) {
                    if (buhuoGoods.good_id.intValue == kuncunModel.id.intValue) {
                        te = buhuoGoods;
                        break;
                    }
                }
                if (kuncunModel.good_num.intValue < te.num.intValue) {
                    kuncunModel.buhuoNum = @(te.num.intValue - kuncunModel.good_num.intValue).stringValue;
                    kuncunModel.tempbuhuoNum = kuncunModel.buhuoNum;
                    kuncunModel.isBuhuo = YES;
                } else {
                    kuncunModel.buhuoNum = @"0";
                    kuncunModel.tempbuhuoNum = @"0";
                    kuncunModel.isBuhuo = NO;
                }
            }
            
            CGFloat shifuMoney = 0;
            NSMutableArray *copyArr1 = [NSMutableArray array];
            NSMutableArray *copyArr2 = [NSMutableArray array];
            NSMutableArray *resultArr = [NSMutableArray array];
            for (LxmShopCenterModel *kuncunModel in selfWeak.myKuCunDataArr) {
                shifuMoney += kuncunModel.proxy_price.doubleValue * kuncunModel.buhuoNum.integerValue;
                if (kuncunModel.isBuhuo) {
                    [copyArr1 addObject:kuncunModel];
                } else {
                    [copyArr2 addObject:kuncunModel];
                }
            }
            
            [resultArr addObjectsFromArray:copyArr1];
            [resultArr addObjectsFromArray:copyArr2];
            [selfWeak.myKuCunDataArr removeAllObjects];
            selfWeak.myKuCunDataArr = resultArr;
            
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"实付金额  "];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",shifuMoney] attributes:@{NSForegroundColorAttributeName:MainColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
            [att appendAttributedString:str];
            selfWeak.bottomView.shifuLabel.attributedText = att;
            
            NSInteger count = selfWeak.dataArr.count;
            selfWeak.emptyView.hidden = count > 0;
            selfWeak.bottomView.hidden = count == 0;
            [selfWeak.tableView reloadData];
            
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}


- (void)loadData1 {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:good_stock_list parameters:@{@"token":SESSION_TOKEN} returnClass:LxmShopCenterRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterRootModel *responseObject) {
        
        if (responseObject.key.intValue == 1000) {
            if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"])) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (LxmShopCenterModel *m in responseObject.result.list) {
                    if (m.special_type.intValue == 2) {
                        [tempArr addObject:m];
                    }
                }
                [self.myKuCunDataArr addObjectsFromArray:tempArr];
                [self loadData];
            } else {
                [self.myKuCunDataArr addObjectsFromArray:responseObject.result.list];
                [self loadData];
            }
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
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myKuCunDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmYiJianBuHuoCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiJianBuHuoCell1"];
    if (!cell) {
        cell = [[LxmYiJianBuHuoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiJianBuHuoCell1"];
    }
    cell.buhuoModel = self.myKuCunDataArr[indexPath.row];
    WeakObj(self);
    cell.incOrDecClickBlock = ^{
        CGFloat shifuMoney = 0;
        for (LxmShopCenterModel *kuncunModel in selfWeak.myKuCunDataArr) {
            shifuMoney += kuncunModel.proxy_price.doubleValue * kuncunModel.buhuoNum.integerValue;
        }
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"实付金额  "];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",shifuMoney] attributes:@{NSForegroundColorAttributeName:MainColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
        [att appendAttributedString:str];
        selfWeak.bottomView.shifuLabel.attributedText = att;
        
        NSInteger count = selfWeak.dataArr.count;
        selfWeak.emptyView.hidden = count > 0;
        selfWeak.bottomView.hidden = count == 0;
        [selfWeak.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)jiesuanClick {
    NSMutableArray *idArr = [NSMutableArray array];
    for (LxmShopCenterOrderModel *m1 in self.tempDataArr) {
        [idArr addObject:m1.id];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    CGFloat shifuMoney = 0;
    
    CGFloat buhuoFUMoney = 0;
    for (LxmShopCenterModel *kuncunModel in self.myKuCunDataArr) {
        if (kuncunModel.isBuhuo) {
            buhuoFUMoney += kuncunModel.proxy_price.doubleValue *kuncunModel.tempbuhuoNum.integerValue;
        }
        shifuMoney += kuncunModel.proxy_price.doubleValue * kuncunModel.buhuoNum.integerValue;
        if ( kuncunModel.buhuoNum.integerValue != 0) {
            NSInteger num = kuncunModel.buhuoNum.integerValue - kuncunModel.tempbuhuoNum.integerValue;
            if (num > 0) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@(num) forKey:@"num"];
                [dic setValue:kuncunModel.id forKey:@"goodId"];
                [dic setValue:kuncunModel.proxy_price forKey:@"proxyPrice"];
                [dic setValue:kuncunModel.special_type forKey:@"specialType"];
                [tempArr addObject:dic];
            }
        }
    }
    
    
    if (shifuMoney < LxmTool.ShareTool.userModel.lowMoney.floatValue) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"请满足最低下单金额%@元",LxmTool.ShareTool.userModel.lowMoney] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
        return;
    }
    
    
    NSString *ids = [idArr componentsJoinedByString:@","];
    NSString *goods = [NSString convertToJsonData:tempArr];
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"ids" : ids,
                           @"goods" : goods,
                           @"totalM" : @(shifuMoney)
                           };
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:do_back_order parameters:dict returnClass:LxmBuHuoRootModel.class success:^(NSURLSessionDataTask *task, LxmBuHuoRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [LxmEventBus sendEvent:@"yijianjiesuan" data:nil];
            selfWeak.emptyView.hidden = NO;
            selfWeak.bottomView.hidden = YES;
            [selfWeak.myKuCunDataArr removeAllObjects];
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
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"金额不一致" message:responseObject.message preferredStyle:UIAlertControllerStyleAlert];
            WeakObj(self);
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }]];
            [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
        } else if (responseObject.key.integerValue == 3986) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"订单已过期或者已经被补货" message:responseObject.message preferredStyle:UIAlertControllerStyleAlert];
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


/// cell
@interface LxmYiJianBuHuoCell1 ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *kucunLabel;//库存

@property (nonatomic, strong) UILabel *daibuhuoLabel;//待补货

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@end

@implementation LxmYiJianBuHuoCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
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
    [self addSubview:self.kucunLabel];
    [self addSubview:self.daibuhuoLabel];
    [self addSubview:self.numView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.kucunLabel.mas_leading).offset(-15);
    }];
    [self.kucunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImgView).offset(-10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.daibuhuoLabel.mas_leading).offset(-5);
    }];
    [self.daibuhuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self.numView.mas_leading).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
        make.height.equalTo(@26);
    }];
    [self.kucunLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
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

- (UILabel *)kucunLabel {
    if (!_kucunLabel) {
        _kucunLabel = [[UILabel alloc] init];
        _kucunLabel.font = [UIFont systemFontOfSize:13];
        _kucunLabel.textColor = CharacterGrayColor;
    }
    return _kucunLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (UILabel *)daibuhuoLabel {
    if (!_daibuhuoLabel) {
        _daibuhuoLabel = [[UILabel alloc] init];
        _daibuhuoLabel.font = [UIFont systemFontOfSize:10];
        _daibuhuoLabel.textColor = MainColor;
        _daibuhuoLabel.text = @"待补货";
        _daibuhuoLabel.layer.borderColor = MainColor.CGColor;
        _daibuhuoLabel.layer.cornerRadius = 5;
        _daibuhuoLabel.layer.borderWidth = 0.5;
        _daibuhuoLabel.layer.masksToBounds = YES;
        _daibuhuoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _daibuhuoLabel;
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
        if (_numView.numTF.text.integerValue > self.buhuoModel.tempbuhuoNum.integerValue) {
            num --;
            _numView.numTF.text = @(num).stringValue;
            self.buhuoModel.buhuoNum = @(num).stringValue;
            if (self.incOrDecClickBlock) {
                self.incOrDecClickBlock();
            }
        } else {
            if (_numView.numTF.text.integerValue == 0) {
                [SVProgressHUD showErrorWithStatus:@"受不了了,不能再少了!"];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最低补货数量为%ld",self.buhuoModel.tempbuhuoNum.integerValue]];
            }
            return;
        }
    } else {
        num ++;
        _numView.numTF.text = @(num).stringValue;
        self.buhuoModel.buhuoNum = @(num).stringValue;
        if (self.incOrDecClickBlock) {
            self.incOrDecClickBlock();
        }
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    NSInteger num =  textField.text.intValue;
    if (num < self.buhuoModel.tempbuhuoNum.integerValue) {
        _numView.numTF.text = @(self.buhuoModel.tempbuhuoNum.integerValue).stringValue;
        num = self.buhuoModel.tempbuhuoNum.integerValue;
        if (num == 0) {
            
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最低补货数量为%ld",self.buhuoModel.tempbuhuoNum.integerValue]];
        }
    }
    self.buhuoModel.buhuoNum = @(num).stringValue;
    if (self.incOrDecClickBlock) {
        self.incOrDecClickBlock();
    }
}

- (void)setBuhuoModel:(LxmShopCenterModel *)buhuoModel {
    _buhuoModel = buhuoModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_buhuoModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _buhuoModel.good_name;
    CGFloat f = _buhuoModel.good_price.doubleValue;
    NSInteger d = _buhuoModel.good_price.integerValue;
    
    CGFloat f1 = _buhuoModel.proxy_price.doubleValue;
    NSInteger d1 = _buhuoModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:f1==d1 ? [NSString stringWithFormat:@"¥%ld ",d1] : [NSString stringWithFormat:@"¥%.2f ",f1] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:f==d ? [NSString stringWithFormat:@"¥%ld ",d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
  
    _numView.numTF.text = _buhuoModel.buhuoNum;
    _daibuhuoLabel.hidden = !_buhuoModel.isBuhuo;
    _kucunLabel.text = [NSString stringWithFormat:@"当前库存: %ld",_buhuoModel.good_num.integerValue];
}

@end


/// 底部按钮
@interface LxmYiJianBuHuoBottom1()

@property (nonatomic, strong) UIButton *qubuhuoButton;/* 去补货 */

@end

@implementation LxmYiJianBuHuoBottom1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shifuLabel];
        [self addSubview:self.qubuhuoButton];
        [self.shifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.trailing.lessThanOrEqualTo(self.qubuhuoButton.mas_leading);
        }];
        [self.qubuhuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self);
            make.width.equalTo(@120);
        }];
    }
    return self;
}

- (UILabel *)shifuLabel {
    if (!_shifuLabel) {
        _shifuLabel = [UILabel new];
        _shifuLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _shifuLabel;
}

- (UIButton *)qubuhuoButton {
    if (!_qubuhuoButton) {
        _qubuhuoButton = [UIButton new];
        [_qubuhuoButton setTitle:@"去补货" forState:UIControlStateNormal];
        [_qubuhuoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_qubuhuoButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_qubuhuoButton addTarget:self action:@selector(buhuoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qubuhuoButton;
}

/// 去补货
- (void)buhuoButtonClick {
    if (self.bottomBuhuoClickBlock) {
        self.bottomBuhuoClickBlock();
    }
}

@end
