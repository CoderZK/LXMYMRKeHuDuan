//
//  LxmLoginVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmLoginVC.h"
#import "LxmLoginView.h"
#import "LxmTabBarVC.h"
#import "LxmForgetPasswordVC.h"
#import "LxmRegistVC.h"
#import "LxmBandPhoneVC.h"
#import <UMShare/UMShare.h>
#import "WXApi.h"

#import "LxmReadProtocolVC.h"

@interface LxmLoginVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIButton *leftButton;//导航栏左侧按钮

@property (nonatomic, strong) LxmTextAndPutinTFView *phoneView;//手机号

@property (nonatomic, strong) LxmTextAndPutinTFView *passwordView;//密码

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *forgetButton;//忘记密码

@property (nonatomic, strong) UIButton *loginButton;//登录按钮

@property (nonatomic, strong) UIView *leftLineView;//左侧线

@property (nonatomic, strong) UILabel *textLabel;//社交账号登录

@property (nonatomic, strong) UIView *rightLineView;//右侧线

@property (nonatomic, strong) UIButton *weichatButton;//微信登录

@end

@implementation LxmLoginVC

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [_leftButton setTitle:@"注册" forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - 1)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (LxmTextAndPutinTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmTextAndPutinTFView alloc] init];
        _phoneView.leftLabel.text = @"手机号码";
        _phoneView.rightTF.placeholder = @"请输入手机号";
        _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}

- (LxmTextAndPutinTFView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LxmTextAndPutinTFView alloc] init];
        _passwordView.leftLabel.text = @"密码";
        _passwordView.rightTF.placeholder = @"请输入密码";
        _passwordView.lineView.hidden = YES;
        _passwordView.rightTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] init];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 25;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = LineColor;
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = LineColor;
    }
    return _rightLineView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.text = @"社交账号登录";
    }
    return _textLabel;
}

- (UIButton *)weichatButton {
    if (!_weichatButton) {
        _weichatButton = [[UIButton alloc] init];
        [_weichatButton setBackgroundImage:[UIImage imageNamed:@"pic_weixin"] forState:UIControlStateNormal];
        [_weichatButton addTarget:self action:@selector(weixinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weichatButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self initHeaderView];
    [self setConstrains];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([WXApi isWXAppInstalled]) {
        _weichatButton.hidden = NO;
        _textLabel.hidden = NO;
        _leftLineView.hidden = NO;
        _rightLineView.hidden = NO;
    } else {
        _weichatButton.hidden = YES;
        _textLabel.hidden = YES;
        _leftLineView.hidden = YES;
        _rightLineView.hidden = YES;
    }
}

/**
 添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.passwordView];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.forgetButton];
    [self.headerView addSubview:self.loginButton];
    [self.headerView addSubview:self.leftLineView];
    [self.headerView addSubview:self.textLabel];
    [self.headerView addSubview:self.rightLineView];
    [self.headerView addSubview:self.weichatButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.equalTo(self.headerView);
        make.trailing.equalTo(self.forgetButton.mas_leading);
        make.height.equalTo(@60);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@60);
        make.width.equalTo(@80);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetButton.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@50);
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.textLabel.mas_leading).offset(-5);
        make.centerY.equalTo(self.textLabel);
        make.width.equalTo(@40);
        make.height.equalTo(@1);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(100);
        make.centerX.equalTo(self.headerView);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.textLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.textLabel);
        make.width.equalTo(@40);
        make.height.equalTo(@1);
    }];
    [self.weichatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(40);
        make.centerX.equalTo(self.headerView);
        make.width.height.equalTo(@40);
    }];
}

/**
 登录
 */
- (void)loginButtonClick {
    [self.headerView endEditing:YES];
    NSString *phone = self.phoneView.rightTF.text;
    NSString *password = self.passwordView.rightTF.text;
    if (![phone isValid]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空!"];
        return;
    }
    if ([phone isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的手机号!"];
        return;
    }
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号!"];
        return;
    }
    if (![password isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        return;
    }
    if ([password isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的密码!"];
        return;
    }
    NSDictionary *dict = @{
                           @"telephone" : phone,
                           @"password" : password,
                           };
    [SVProgressHUD show];
    self.loginButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LxmNetworking networkingPOST:app_login parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"key"] integerValue] == 1000) {
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"agreeStatus"]];
            if (str.intValue == 1) {//已读
                [LxmTool ShareTool].isLogin = YES;
                [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
                [LxmTool.ShareTool uploadDeviceToken];
                [selfWeak loadMyUserInfoWithOkBlock:^{
                    selfWeak.loginButton.userInteractionEnabled = YES;
                    UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
                }];
            } else if (str.intValue == 2){//未读
                [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
                NSArray *urls = responseObject[@"result"][@"map"][@"agreeList"];
                if ([urls isKindOfClass:NSArray.class]) {
                    if (urls.count >= 1) {
                        [selfWeak loadMyUserInfoWithOkBlock:^{
                            LxmReadProtocolVC *vc = [[LxmReadProtocolVC alloc] init];
                            vc.token = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"token"]];
                            vc.urls = urls;
                            vc.yiduXiyiBlock = ^{
                                [LxmTool ShareTool].isLogin = YES;
                                [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
                                [LxmTool.ShareTool uploadDeviceToken];
                                [selfWeak loadMyUserInfoWithOkBlock:^{
                                   selfWeak.loginButton.userInteractionEnabled = YES; UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
                                }];
                            };
                            [selfWeak.navigationController pushViewController:vc animated:YES];
                        }];
                    } else {
                        [LxmTool ShareTool].isLogin = YES;
                        [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
                        [LxmTool.ShareTool uploadDeviceToken];
                        [selfWeak loadMyUserInfoWithOkBlock:^{
                            selfWeak.loginButton.userInteractionEnabled = YES;
                            UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
                        }];
                    }
                }
            }
        } else {
            selfWeak.loginButton.userInteractionEnabled = YES;
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        selfWeak.loginButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

- (void)regist {
    LxmRegistVC *vc = [[LxmRegistVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 忘记密码
 */
- (void)forgetButtonClick {
    LxmForgetPasswordVC *vc = [[LxmForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 微信登录 没有注册 进入微信注册页
 */
- (void)weixinClick {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        if (!error) {
            [self bandWiexin:resp];
        }
    }];
}

- (void)bandWiexin:(UMSocialUserInfoResponse *)resp {
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"openId"] = resp.openid;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:app_login parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [LxmTool.ShareTool uploadDeviceToken];
            [selfWeak loadMyUserInfoWithOkBlock:^{
                UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
            }];
        } else if ([responseObject[@"key"] integerValue] == 1007) {//"该微信号未注册过
            LxmBandPhoneVC *vc = [[LxmBandPhoneVC alloc] init];
            vc.openID = resp.openid;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
