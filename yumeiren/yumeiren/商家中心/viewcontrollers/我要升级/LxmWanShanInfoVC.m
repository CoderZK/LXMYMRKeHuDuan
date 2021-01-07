//
//  LxmWanShanInfoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmWanShanInfoVC.h"
#import "LxmAddAddressVC.h"
#import "LxmAddressPickerView.h"
#import "LxmJieDanPublishVC.h"
#import "LxmDetailAddressVC.h"
#import "LxmShopVC.h"
#import "LxmMineVC.h"
#import "LxmShopCenterVC.h"
#import "LxmPublishTouSuVC.h"
#import "LxmTianXieRecommendCodeVC.h"

@interface LxmWanShanInfoVC ()<LxmAddressPickerViewDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *shopNameCell;//店铺名称

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *phoneCell;//联系电话

@property (nonatomic, strong) LxmAddAddressSelectCell *shengCell;//省

@property (nonatomic, strong) LxmAddAddressSelectCell *shiCell;//市

@property (nonatomic, strong) LxmAddAddressSelectCell *quCell;//区

@property (nonatomic, strong) LxmAddAddressSelectCell *detailCell;//详细地址

@property (nonatomic, strong) UIButton *quGouwuButton;//去购物

@property (nonatomic, strong) LxmAddressPickerView * pickerView;

@property (nonatomic, strong) AMapPOI *poi;

@property(nonatomic,assign)BOOL isSuXuan;
@property(nonatomic,strong)NSString *miYaoStr;

@end

@implementation LxmWanShanInfoVC

- (LxmAddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[LxmAddressPickerView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (LxmJieDanPublishTextFieldCell *)shopNameCell {
    if (!_shopNameCell) {
        _shopNameCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _shopNameCell.titleLabel.text = @"店铺名称";
        _shopNameCell.textField.placeholder = @"请输入";
        if (LxmTool.ShareTool.userModel.shopInfo.id.isValid) {
            _shopNameCell.textField.textColor = CharacterDarkColor;
            _shopNameCell.textField.text = LxmTool.ShareTool.userModel.shopInfo.showName;
            _shopNameCell.textField.userInteractionEnabled = NO;
        }
        
        
    }
    return _shopNameCell;
}

- (LxmJieDanPublishTextFieldCell *)phoneCell { 
    if (!_phoneCell) {
        _phoneCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _phoneCell.titleLabel.text = @"联系电话";
        _phoneCell.textField.placeholder = @"请输入";
        if (LxmTool.ShareTool.userModel.shopInfo.id.isValid) {
            _phoneCell.textField.textColor = CharacterDarkColor;
            _phoneCell.textField.text = LxmTool.ShareTool.userModel.shopInfo.telephone;
            _phoneCell.textField.userInteractionEnabled = NO;
        }
    }
    return _phoneCell;
    
    
}

- (LxmAddAddressSelectCell *)detailCell {
    if (!_detailCell) {
        _detailCell = [[LxmAddAddressSelectCell alloc] init];
        _detailCell = [[LxmAddAddressSelectCell alloc] init];
        _detailCell.titleLabel.text = @"详细地址";
        if (!LxmTool.ShareTool.userModel.shopInfo.addressDetail.isValid) {
            [_detailCell addTarget:self action:@selector(detailAddressClick) forControlEvents:UIControlEventTouchUpInside];
            _detailCell.detailLabel.text = @"请选择详细地址";
        } else {
            _detailCell.detailLabel.text = LxmTool.ShareTool.userModel.shopInfo.addressDetail;
        }
    }
    return _detailCell;
}

- (UIButton *)quGouwuButton {
    if (!_quGouwuButton) {
        _quGouwuButton = [[UIButton alloc] init];
        [_quGouwuButton setTitle:@"去购货" forState:UIControlStateNormal];
        [_quGouwuButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_quGouwuButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _quGouwuButton.layer.cornerRadius = 5;
        _quGouwuButton.layer.masksToBounds = YES;
        [_quGouwuButton addTarget:self action:@selector(gotoGouWuButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quGouwuButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 6*50 + 65)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善个人信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.tableView.tableHeaderView = self.headerView;
    [self initHeaderView];
    [self setHeaderViewConstrains];
    
    //    self.poi = [[AMapPOI alloc] init];
    //
    //    LxmUserShopInfoModel * model =[LxmTool ShareTool].userModel.shopInfo;
    //    NSString * str = model.latitude;
    //    NSString * str2 = model.longitude;
    //    NSLog(@"%@",@"123456");
    //
    //
    //    AMapGeoPoint * location = [[AMapGeoPoint alloc] init];
    //    location.latitude = model.latitude.floatValue;
    //    location.longitude = model.longitude.floatValue;
    //    self.poi.location = location;
    //
    //    CGFloat f = self.poi.location.latitude;
    //    CGFloat ff = self.poi.location.longitude;
    
    
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

/**
 头视图添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.shopNameCell];
    [self.headerView addSubview:self.phoneCell];
    [self.headerView addSubview:self.shengCell];
    [self.headerView addSubview:self.shiCell];
    [self.headerView addSubview:self.quCell];
    [self.headerView addSubview:self.quGouwuButton];
    [self.headerView addSubview:self.detailCell];
}

/**
 设置头视图子视图约束
 */
- (void)setHeaderViewConstrains {
    [self.shopNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.phoneCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.shengCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.shiCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shengCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.quCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shiCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.detailCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.quGouwuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailCell.mas_bottom).offset(20);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@44);
    }];
    if (![self.model.roleType isEqualToString:@"-0.5"] && ![self.model.roleType isEqualToString:@"-0.4"] && ![self.model.roleType isEqualToString:@"-0.3"] && ![self.model.roleType isEqualToString:@"1.1"] && ![self.model.roleType isEqualToString:@"2.1"] && ![self.model.roleType isEqualToString:@"3.1"]) {
        [self.detailCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quCell.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
    } else {
        [self.detailCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quCell.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@0);
        }];
    }
    [self.headerView layoutIfNeeded];
    
}

- (LxmAddAddressSelectCell *)shengCell {
    if (!_shengCell) {
        _shengCell = [[LxmAddAddressSelectCell alloc] init];
        _shengCell.titleLabel.text = @"选择省";
        if (LxmTool.ShareTool.userModel.province.isValid) {
            _shengCell.detailLabel.text = LxmTool.ShareTool.userModel.province;
        } else {
            _shengCell.detailLabel.text = @"请选择";
            [_shengCell addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _shengCell;
}

- (LxmAddAddressSelectCell *)shiCell {
    if (!_shiCell) {
        _shiCell = [[LxmAddAddressSelectCell alloc] init];
        _shiCell.titleLabel.text = @"选择市";
        if (LxmTool.ShareTool.userModel.city.isValid) {
            _shiCell.detailLabel.text = LxmTool.ShareTool.userModel.city;
        } else {
            _shiCell.detailLabel.text = @"请选择";
            [_shiCell addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _shiCell;
}

- (LxmAddAddressSelectCell *)quCell {
    if (!_quCell) {
        _quCell = [[LxmAddAddressSelectCell alloc] init];
        _quCell.titleLabel.text = @"选择区";
        if (LxmTool.ShareTool.userModel.province.isValid) {
            _quCell.detailLabel.tag = 1111;
            _quCell.detailLabel.text = LxmTool.ShareTool.userModel.district;
        } else {
            _quCell.detailLabel.tag = 1110;
            _quCell.detailLabel.text = @"请选择";
            [_quCell addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return _quCell;
}

/**
 去购物
 */
- (void)gotoGouWuButtonClick {
    [self.headerView endEditing:YES];
    
    void(^gotoGouwu)(void) = ^{
        LxmShopVC *vc = [[LxmShopVC alloc] init];
        vc.roleType = [NSString stringWithFormat:@"%@",self.model.roleType];
        self.model.suType = self.isSuXuan ? @"1":@"2";
        if ([LxmTool ShareTool].userModel.suType.intValue == 1) {
            self.model.suType = @"1";
        }
        
        if (self.model.roleType.doubleValue == 2 || self.model.roleType.doubleValue == 3 || self.model.roleType.doubleValue == 4) {
            self.model.suType = @"3";
        }
        
        vc.shengjiModel = self.model;
        
        vc.isDeep = YES;
        vc.isAddLocolGoods = YES;
        vc.isGotoGouwuChe = YES;
        UINavigationController *navi = self.navigationController;
        [navi popToRootViewControllerAnimated:NO];
        [navi pushViewController:vc animated:YES];
    };
    
    if (!self.shopNameCell.textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺名称!"];
        return;
    }
    if (self.shopNameCell.textField.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"店铺名称在1~20个字符!"];
        return;
    }
    if (!self.phoneCell.textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话!"];
        return;
    }
    if (self.phoneCell.textField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的联系电话!"];
        return;
    }
    if ([self.shengCell.detailLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区!"];
        return;
    }
    if (![self.model.roleType isEqualToString:@"-0.5"] && ![self.model.roleType isEqualToString:@"-0.4"] && ![self.model.roleType isEqualToString:@"-0.3"] && ![self.model.roleType isEqualToString:@"1.1"] && ![self.model.roleType isEqualToString:@"2.1"] && ![self.model.roleType isEqualToString:@"3.1"]) {
        if ([self.detailCell.detailLabel.text isEqualToString:@"请选择详细地址"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择详细地址!"];
            return;
        }
    }
    
    NSMutableDictionary *panduanDict = [NSMutableDictionary dictionary];
    panduanDict[@"token"] = SESSION_TOKEN;
    panduanDict[@"city"] = self.shiCell.detailLabel.text;
    panduanDict[@"shop_name"] = self.shopNameCell.textField.text;
    
    if ([self.model.roleType isEqualToString:@"-0.5"] || [self.model.roleType isEqualToString:@"-0.4"] || [self.model.roleType isEqualToString:@"-0.3"] || [self.model.roleType isEqualToString:@"1.1"] || [self.model.roleType isEqualToString:@"2.1"] || [self.model.roleType isEqualToString:@"3.1"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"showName"] = self.shopNameCell.textField.text;
        dict[@"telephone"] = self.phoneCell.textField.text;
        dict[@"token"] = SESSION_TOKEN;
        dict[@"province"] = self.shengCell.detailLabel.text;
        dict[@"city"] = self.shiCell.detailLabel.text;
        dict[@"district"] = self.quCell.detailLabel.text;
        dict[@"roleType"] = self.model.roleType;
        if (self.isSuXuan) {
            dict[@"su_type"] = @"1";
            dict[@"su_code"] = self.miYaoStr;
        }else {
            
            if (self.model.roleType.doubleValue == 2 || self.model.roleType.doubleValue == 3 || self.model.roleType.doubleValue == 4) {
                dict[@"su_type"] = @"3";
            }else {
                dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
            }
        }
        if (self.recommend_code.isValid) {
            dict[@"recommend_code"] = self.recommend_code;
        }
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:role_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [self loadMyUserInfoWithOkBlock:nil];
                [SVProgressHUD showSuccessWithStatus:@"信息已完善!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    gotoGouwu();
                });
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        //判断附近1.5公里有没有地址，有的话不可以提交，
        panduanDict[@"longitude"] = @(self.poi.location.longitude);
        panduanDict[@"latitude"] = @(self.poi.location.latitude);
        panduanDict[@"address_detail"] = self.detailCell.detailLabel.text;
        if (self.isSuXuan) {
            panduanDict[@"su_type"] = @"1";
      
        }else {
            panduanDict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
        }
        [SVProgressHUD show];
        WeakObj(self);
        [LxmNetworking networkingPOST:select_store parameters:panduanDict returnClass:LxmMenDianChaXunRootModel.class success:^(NSURLSessionDataTask *task, LxmMenDianChaXunRootModel *responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject.key.integerValue == 1000) {
                NSArray *arr = responseObject.result.list;
                if (arr.count > 0) {
                    
                    //                   selfWeak.isQuYuBaoHu = YES;
                    [selfWeak showTiShi];
                    
                    //                   UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您好，由于区域保护内有其它合作店家，系统无法录入，敬请谅解；是否继续申请代理 ?" preferredStyle:UIAlertControllerStyleAlert];
                    //                   [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                    //                   [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //                       LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPublishTouSuVC_type_shenqingdaili];
                    //                       vc.shenqingDailiBlock = ^(NSString *reason, NSString *ids) {
                    //                           NSLog(@"%@---%@",reason,ids);
                    //                           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    //                           dict[@"reason"] = reason;
                    //                           dict[@"pics"] = ids;
                    //                           dict[@"showName"] = self.shopNameCell.textField.text;
                    //                           dict[@"telephone"] = self.phoneCell.textField.text;
                    //                           dict[@"token"] = SESSION_TOKEN;
                    //                           dict[@"province"] = self.shengCell.detailLabel.text;
                    //                           dict[@"city"] = self.shiCell.detailLabel.text;
                    //                           dict[@"district"] = self.quCell.detailLabel.text;
                    //                           dict[@"roleType"] = self.model.roleType;
                    //                           dict[@"longitude"] = @(self.poi.location.longitude);
                    //                           dict[@"latitude"] = @(self.poi.location.latitude);
                    //                           dict[@"addressDetail"] = self.detailCell.detailLabel.text;
                    //                           dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
                    //                           if (self.recommend_code.isValid) {
                    //                               dict[@"recommend_code"] = self.recommend_code;
                    //                           }
                    //                           [SVProgressHUD show];
                    //                           [LxmNetworking networkingPOST:role_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    //                               [SVProgressHUD dismiss];
                    //                               if ([responseObject[@"key"] integerValue] == 1000) {
                    //                                   [selfWeak loadMyUserInfoWithOkBlock:nil];
                    //                                   [SVProgressHUD showSuccessWithStatus:@"申请中.."];
                    //                                   int index = (int)[[self.navigationController viewControllers] indexOfObject:self];
                    //                                   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
                    //                               } else {
                    //                                   [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                    //                               }
                    //                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    //                               [SVProgressHUD dismiss];
                    //                           }];
                    //                       };
                    //                       [selfWeak.navigationController pushViewController:vc animated:YES];
                    //                   }]];
                    //                   [self presentViewController:alertView animated:YES completion:nil];
                } else {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"showName"] = self.shopNameCell.textField.text;
                    dict[@"telephone"] = self.phoneCell.textField.text;
                    dict[@"token"] = SESSION_TOKEN;
                    dict[@"province"] = self.shengCell.detailLabel.text;
                    dict[@"city"] = self.shiCell.detailLabel.text;
                    dict[@"district"] = self.quCell.detailLabel.text;
                    dict[@"roleType"] = self.model.roleType;
                    dict[@"longitude"] = @(self.poi.location.longitude);
                    dict[@"latitude"] = @(self.poi.location.latitude);
                    dict[@"addressDetail"] = self.detailCell.detailLabel.text;
                    if (selfWeak.isSuXuan) {
                        dict[@"su_type"] = @"1";
                        dict[@"su_code"] = self.miYaoStr;
                    }else {
                        
                        if (self.model.roleType.doubleValue == 2 || self.model.roleType.doubleValue == 3 || self.model.roleType.doubleValue == 4) {
                            dict[@"su_type"] = @"3";
                        }else {
                            dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
                        }
                        
                        
                    }
                    if (self.recommend_code.isValid) {
                        dict[@"recommend_code"] = self.recommend_code;
                    }
                    [SVProgressHUD show];
                    [LxmNetworking networkingPOST:role_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        [SVProgressHUD dismiss];
                        if ([responseObject[@"key"] integerValue] == 1000) {
                            [self loadMyUserInfoWithOkBlock:nil];
                            [SVProgressHUD showSuccessWithStatus:@"信息已完善!"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                gotoGouwu();
                            });
                        } else {
                            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [SVProgressHUD dismiss];
                    }];
                }
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)showTiShi {
    
    WeakObj(self);
    NSString * str = @"您好，由于区域保护内有其它合作店家，系统无法录入，敬请谅解；是否继续申请代理 ?";
    if (([LxmTool ShareTool].userModel.suType.intValue == 1 || self.isSuXuan) && self.model.roleType.intValue < 2) {
        //其它代理
        str = @"您好，由于区域保护内有\"其它系列\"，系统无法录入，敬请谅解；是否继续申请代理 ?";
        
    }
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"继续申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPublishTouSuVC_type_shenqingdaili];
        
        vc.backBlock = ^{
            selfWeak.isSuXuan = NO;
        };
        
        vc.shenqingDailiBlock = ^(NSString *reason, NSString *ids) {
            NSLog(@"%@---%@",reason,ids);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"reason"] = reason;
            dict[@"pics"] = ids;
            dict[@"showName"] = self.shopNameCell.textField.text;
            dict[@"telephone"] = self.phoneCell.textField.text;
            dict[@"token"] = SESSION_TOKEN;
            dict[@"province"] = self.shengCell.detailLabel.text;
            dict[@"city"] = self.shiCell.detailLabel.text;
            dict[@"district"] = self.quCell.detailLabel.text;
            dict[@"roleType"] = self.model.roleType;
            dict[@"longitude"] = @(self.poi.location.longitude);
            dict[@"latitude"] = @(self.poi.location.latitude);
            dict[@"addressDetail"] = self.detailCell.detailLabel.text;
            if (selfWeak.isSuXuan) {
                dict[@"su_type"] = @"1";
                dict[@"su_code"] = self.miYaoStr;
           
            }else {
                
                if (self.model.roleType.doubleValue == 2 || self.model.roleType.doubleValue == 3 || self.model.roleType.doubleValue == 4) {
                    dict[@"su_type"] = @"3";
                }else {
                    dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
                }
            }
            
            if (self.recommend_code.isValid) {
                dict[@"recommend_code"] = self.recommend_code;
            }
            [SVProgressHUD show];
            [LxmNetworking networkingPOST:role_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"key"] integerValue] == 1000) {
                    [selfWeak loadMyUserInfoWithOkBlock:nil];
                    [SVProgressHUD showSuccessWithStatus:@"申请中.."];
                    int index = (int)[[self.navigationController viewControllers] indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
                } else {
                    [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        };
        
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }]];
    if ([LxmTool ShareTool].userModel.suType.intValue == 2 && self.isSuXuan == NO && self.model.roleType.intValue < 2) {
        [alertView addAction:[UIAlertAction actionWithTitle:@"申请其它系列" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isSuXuan = YES;
            [self showMiYaoTX];
            //
        }]];
    }
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
    
    
}

// 弹出输入
-(void)showMiYaoTX {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"秘钥" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*userNameTextField = alertController.textFields.firstObject;
        NSLog(@"支付密码：%@",userNameTextField.text);
        if (userNameTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入秘钥"];
            return;
        }
        self.miYaoStr = userNameTextField.text;

        [self gotoGouWuButtonClick];
    
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入秘钥";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


/**
 地址选择
 */
- (void)addressClick {
    [self.headerView endEditing:YES];
    [self.pickerView show];
}

/** 取消按钮点击事件*/
- (void)cancelBtnClick {
    [self.pickerView hide];
}
/**
 *  完成按钮点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area {
    [self.pickerView hide];
    self.shengCell.detailLabel.text = province;
    self.shiCell.detailLabel.text = city;
    self.quCell.detailLabel.text = area;
}

- (void)detailAddressClick {
    [self.headerView endEditing:YES];
    if (!self.shopNameCell.textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺名称!"];
        return;
    }
    if (self.shopNameCell.textField.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"店铺名称在1~20个字符!"];
        return;
    }
    if (!self.phoneCell.textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话!"];
        return;
    }
    if (self.phoneCell.textField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的联系电话!"];
        return;
    }
    if ([self.shengCell.detailLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区!"];
        return;
    }
    LxmDetailAddressVC *vc = [[LxmDetailAddressVC alloc] init];
    vc.city = self.shiCell.detailLabel.text;
    vc.poi = self.poi;
    WeakObj(self);
    vc.didselectPoi = ^(AMapPOI *poi) {
        selfWeak.poi = poi;
        selfWeak.detailCell.detailLabel.text = poi.address;
        [selfWeak loadFujinData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/// 加载附近店铺查询
- (void)loadFujinData {
    //判断附近1.5公里有没有地址，有的话不可以提交，
    NSMutableDictionary *panduanDict = [NSMutableDictionary dictionary];
    panduanDict[@"token"] = SESSION_TOKEN;
    panduanDict[@"city"] = self.shiCell.detailLabel.text;
    panduanDict[@"longitude"] = @(self.poi.location.longitude);
    panduanDict[@"latitude"] = @(self.poi.location.latitude);
    panduanDict[@"shop_name"] = self.shopNameCell.textField.text;
    panduanDict[@"address_detail"] = self.detailCell.detailLabel.text;
    
    if (self.isSuXuan) {
        panduanDict[@"su_type"] = @"1";
        
    }else {
        panduanDict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
    }
    
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:select_store parameters:panduanDict returnClass:LxmMenDianChaXunRootModel.class success:^(NSURLSessionDataTask *task, LxmMenDianChaXunRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            NSArray *arr = responseObject.result.list;
            if (arr.count > 0) {
                
                
                
                //                selfWeak.isQuYuBaoHu = YES;
                [selfWeak showTiShi];
                
                //                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您好，由于区域保护内有其它合作店家，系统无法录入，敬请谅解；是否继续申请代理 ?" preferredStyle:UIAlertControllerStyleAlert];
                //                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                //                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //                    LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPublishTouSuVC_type_shenqingdaili];
                //                    vc.shenqingDailiBlock = ^(NSString *reason, NSString *ids) {
                //                        NSLog(@"%@---%@",reason,ids);
                //                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                //                        dict[@"reason"] = reason;
                //                        dict[@"pics"] = ids;
                //                        dict[@"showName"] = self.shopNameCell.textField.text;
                //                        dict[@"telephone"] = self.phoneCell.textField.text;
                //                        dict[@"token"] = SESSION_TOKEN;
                //                        dict[@"province"] = self.shengCell.detailLabel.text;
                //                        dict[@"city"] = self.shiCell.detailLabel.text;
                //                        dict[@"district"] = self.quCell.detailLabel.text;
                //                        dict[@"roleType"] = self.model.roleType;
                //                        dict[@"longitude"] = @(self.poi.location.longitude);
                //                        dict[@"latitude"] = @(self.poi.location.latitude);
                //                        dict[@"addressDetail"] = self.detailCell.detailLabel.text;
                //                        dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
                //                        if (self.recommend_code.isValid) {
                //                            dict[@"recommend_code"] = self.recommend_code;
                //                        }
                //                        [SVProgressHUD show];
                //                        [LxmNetworking networkingPOST:role_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                //                            [SVProgressHUD dismiss];
                //                            if ([responseObject[@"key"] integerValue] == 1000) {
                //                                [selfWeak loadMyUserInfoWithOkBlock:nil];
                //                                [SVProgressHUD showSuccessWithStatus:@"申请中.."];
                //                                int index = (int)[[self.navigationController viewControllers] indexOfObject:self];
                //                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
                //                            } else {
                //                                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
                //                            }
                //                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                //                            [SVProgressHUD dismiss];
                //                        }];
                //                    };
                //                    [selfWeak.navigationController pushViewController:vc animated:YES];
                //                }]];
                //                [self presentViewController:alertView animated:YES completion:nil];
            }
            
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
