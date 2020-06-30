//
//  LxmBandPhoneVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmBandPhoneVC.h"
#import "LxmLoginView.h"
#import "LxmRegisterNextVC.h"
#import "LxmTabBarVC.h"

@interface LxmBandPhoneVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmTextAndPutinTFView *phoneView;//手机号

@property (nonatomic, strong) LxmTextAndPutinTFView *codeView;//验证码

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *sendCodeButton;//发送验证码

@property (nonatomic, strong) UIButton *agreeButton;//同意协议并注册

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@property (nonatomic, strong) NSString *data;

@end

@implementation LxmBandPhoneVC

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

- (LxmTextAndPutinTFView *)codeView {
    if (!_codeView) {
        _codeView = [[LxmTextAndPutinTFView alloc] init];
        _codeView.leftLabel.text = @"验证码";
        _codeView.rightTF.placeholder = @"请输入验证码";
        _codeView.lineView.hidden = YES;
    }
    return _codeView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:[UIColor colorWithRed:231/255.0 green:93/255.0 blue:108/255.0 alpha:1] forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _agreeButton.layer.cornerRadius = 25;
        _agreeButton.layer.masksToBounds = YES;
        [_agreeButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
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
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.codeView];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.sendCodeButton];
    [self.headerView addSubview:self.agreeButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.equalTo(self.headerView);
        make.trailing.equalTo(self.sendCodeButton.mas_leading);
        make.height.equalTo(@60);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@60);
        make.width.equalTo(@80);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendCodeButton.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@50);
    }];
}

/**
 下一步
 */
- (void)sureButtonClick {
    [self.headerView endEditing:YES];
    NSString *phone  = self.phoneView.rightTF.text;
    NSString *code = self.codeView.rightTF.text;
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
    if (![code isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码!"];
        return;
    }
    if ([phone isContrainsKong]) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的验证码!"];
        return;
    }
    
    if (self.data.intValue == 1) {//手机号已注册 但未绑定手机号
        
        NSDictionary *dict = @{
                               @"telephone" : phone,
                               @"code" : code,
                               @"openId" : self.openID
                               };
        [self bandPhone:dict];
    } else if (self.data.intValue == 2){
        [SVProgressHUD showErrorWithStatus:@"该手机号已绑定其他微信账号!"];
    } else {//未注册过
        LxmRegisterNextVC *vc = [[LxmRegisterNextVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmRegisterNextVC_type_nophone];
        vc.phone = phone;
        vc.code = code;
        vc.openID = self.openID;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

/**
 发送验证码
 */
- (void)sendCodeButtonClick {
    NSString *phone  = self.phoneView.rightTF.text;
    if (![phone isValid]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空!"];
        return;
    }
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号!"];
        return;
    }
    NSDictionary *dict = @{
                           @"type" : @10,
                           @"telephone" : phone,
                           @"chat" : @1
                           };
    [SVProgressHUD show];
    WeakObj(self);
    self.sendCodeButton.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:app_identify parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        selfWeak.sendCodeButton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] integerValue] == 1000) {
            self.data = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]];
            if (self.data.intValue == 1) {//手机号已注册但未绑定微信号
                [self.timer invalidate];
                self.timer = nil;
                self.time = 60;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer) userInfo:nil repeats:YES];
            } else if (self.data.intValue == 2){//手机号已注册 已绑定微信号
                [SVProgressHUD showErrorWithStatus:@"该手机号已注册，请填写其他手机号！"];
            }
            
        } else{
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        selfWeak.sendCodeButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.sendCodeButton.enabled = NO;
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.sendCodeButton.enabled = YES;
        [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)bandPhone:(NSDictionary *)dict {
    [SVProgressHUD show];
    self.agreeButton.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:first_submit parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        self.agreeButton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LxmTool ShareTool].userModel = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [LxmTool.ShareTool uploadDeviceToken];
            UIApplication.sharedApplication.delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.agreeButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}


@end
