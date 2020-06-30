//
//  LxmRegisterNextVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/28.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmRegisterNextVC.h"
#import "LxmLoginView.h"
#import "LxmTabBarVC.h"
#import "LxmRegistXieYiAlertView.h"
#import "LxmWebViewController.h"

@interface LxmRegisterNextVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmTextAndPutinTFView *passwordView;//密码

@property (nonatomic, strong) LxmTextAndPutinTFView *surepasswordView;//确认密码

@property (nonatomic, strong) LxmTextAndPutinTFView *tuijianCodeView;//授权码

@property (nonatomic, strong) UIButton *sureButton;//确认

@property (nonatomic, strong) LxmAgreeButton *agreeXieYiButton;//同意协议

@property (nonatomic, assign) LxmRegisterNextVC_type type;

@end

@implementation LxmRegisterNextVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmRegisterNextVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - 1)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (LxmTextAndPutinTFView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LxmTextAndPutinTFView alloc] init];
        _passwordView.leftLabel.text = @"密码";
        _passwordView.rightTF.placeholder = @"请输入密码";
        _passwordView.rightTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (LxmTextAndPutinTFView *)surepasswordView {
    if (!_surepasswordView) {
        _surepasswordView = [[LxmTextAndPutinTFView alloc] init];
        _surepasswordView.leftLabel.text = @"确认密码";
        _surepasswordView.rightTF.placeholder = @"请再次输入密码";
        _surepasswordView.rightTF.secureTextEntry = YES;
    }
    return _surepasswordView;
}

- (LxmTextAndPutinTFView *)tuijianCodeView {
    if (!_tuijianCodeView) {
        _tuijianCodeView = [[LxmTextAndPutinTFView alloc] init];
        _tuijianCodeView.leftLabel.text = @"注册码";
        _tuijianCodeView.rightTF.placeholder = @"请输入注册码";
    }
    return _tuijianCodeView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 25;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (LxmAgreeButton *)agreeXieYiButton {
    if (!_agreeXieYiButton) {
        _agreeXieYiButton = [[LxmAgreeButton alloc] init];
        [_agreeXieYiButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _agreeXieYiButton.selectButton.hidden = NO;
        [_agreeXieYiButton.selectButton addTarget:self action:@selector(seeProtoclClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _agreeXieYiButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.type == LxmRegisterNextVC_type_zczh ? @"注册" : @"设置密码";
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self initHeaderView];
    [self setConstrains];
}

/**
 添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.passwordView];
    [self.headerView addSubview:self.surepasswordView];
    [self.headerView addSubview:self.tuijianCodeView];
    [self.headerView addSubview:self.sureButton];
    [self.headerView addSubview:self.agreeXieYiButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.surepasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.tuijianCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surepasswordView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tuijianCodeView.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@50);
    }];
    [self.agreeXieYiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureButton.mas_bottom).offset(15);
        make.leading.equalTo(self.headerView).offset(5);
        make.trailing.equalTo(self.headerView).offset(-5);
        make.height.equalTo(@50);
    }];
}


- (void)sureButtonClick {
    [self.headerView endEditing:YES];
    NSString *password = self.passwordView.rightTF.text;
    NSString *surepassword = self.surepasswordView.rightTF.text;
    NSString *tuijiancode = self.tuijianCodeView.rightTF.text;
    if (![password isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        return;
    }
    if ([password isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的密码!"];
        return;
    }
    if (![surepassword isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码!"];
        return;
    }
    if ([surepassword isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的确认密码!"];
        return;
    }
    if (![password isEqualToString:surepassword]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致!"];
        return;
    }
    if (![tuijiancode isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入授权码!"];
        return;
    }
    if ([tuijiancode isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的授权码!"];
        return;
    }
    if (tuijiancode.length != 6 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位的授权码!"];
        return;
    }
    if (!self.agreeXieYiButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"请先同意协议!"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"telephone"] = self.phone;
    dict[@"code"] = self.code;
    dict[@"password"] = password;
    dict[@"recommendCode"] = tuijiancode;
    if (self.type == LxmRegisterNextVC_type_nophone) {
        dict[@"openId"] = self.openID;
    }
    [SVProgressHUD show];
    _sureButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LxmNetworking networkingPOST:user_submit parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        _sureButton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [LxmTool.ShareTool uploadDeviceToken];
            [selfWeak loadMyUserInfoWithOkBlock:^{
                UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
            }];
        } else {
             [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _sureButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
    
}

- (void)agreeButtonClick:(LxmAgreeButton *)btn {
    btn.selected = !btn.selected;
    btn.iconImgView.image = [UIImage imageNamed: btn.selected ? @"xuanzhong_y" : @"xuanzhong_n"];
}

- (void)seeProtoclClick:(UIButton *)btn {
    LxmWebViewController *vc = [[LxmWebViewController alloc] init];
    vc.navigationItem.title = @"注册协议";
    vc.loadUrl = [NSURL URLWithString:@"https://app.hkymr.com/submitRule.html"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    LxmRegistXieYiAlertView *alertView = [[LxmRegistXieYiAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    WeakObj(self);
//    alertView.sureBlock = ^{
//        selfWeak.agreeXieYiButton.selected = YES;
//        selfWeak.agreeXieYiButton.iconImgView.image = [UIImage imageNamed: @"xuanzhong_y"];
//    };
//    [alertView show];
}

@end
