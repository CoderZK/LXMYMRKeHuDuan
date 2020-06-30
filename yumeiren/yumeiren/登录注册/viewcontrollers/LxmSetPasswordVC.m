//
//  LxmSetPasswordVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSetPasswordVC.h"
#import "LxmLoginView.h"

@interface LxmSetPasswordVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmTextAndPutinTFView *passwordView;//密码

@property (nonatomic, strong) LxmTextAndPutinTFView *surePasswordView;//确认密码

@property (nonatomic, strong) UIButton *sureButton;//确认按钮

@end

@implementation LxmSetPasswordVC
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
        _passwordView.rightTF.placeholder = @"请设置新密码";
        _passwordView.rightTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (LxmTextAndPutinTFView *)surePasswordView {
    if (!_surePasswordView) {
        _surePasswordView = [[LxmTextAndPutinTFView alloc] init];
        _surePasswordView.leftLabel.text = @"确认密码";
        _surePasswordView.rightTF.placeholder = @"请确认新密码";
        _surePasswordView.lineView.hidden = YES;
        _surePasswordView.rightTF.secureTextEntry = YES;
    }
    return _surePasswordView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置新密码";
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
    [self.headerView addSubview:self.surePasswordView];
    [self.headerView addSubview:self.sureButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surePasswordView.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@50);
    }];
}

/**
 确认
 */
- (void)sureButtonClick {
    [self.headerView endEditing:YES];
    NSString *password = self.passwordView.rightTF.text;
    NSString *surepassword = self.surePasswordView.rightTF.text;
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"telephone"] = self.phone;
    dict[@"modifyId"] = self.code;
    dict[@"newPass"] = password;
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:back_pass parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"密码已重置!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end
