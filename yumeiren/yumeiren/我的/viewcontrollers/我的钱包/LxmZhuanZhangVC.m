//
//  LxmZhuanZhangVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmZhuanZhangVC.h"

@interface LxmZhuanZhangHeaderView : UIView

@property (nonatomic, strong) UILabel *textLabel;//转账账户

@property (nonatomic, strong) UITextField *accountTF;//账户

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *textLabel1;//转账账户的授权码

@property (nonatomic, strong) UITextField *tuijianmaTF;//授权码

@property (nonatomic, strong) UIView *lineView1;//线

@property (nonatomic, strong) UILabel *textLabel2;//充值金额

@property (nonatomic, strong) UILabel *yuanlabel;//元

@property (nonatomic, strong) UITextField *moneyTF;//输入的钱数

@property (nonatomic, strong) UIView *lineView2;//线

@property (nonatomic, strong) UILabel *textLabel3;//手机验证码

@property (nonatomic, strong) UITextField *codeTF;//验证码

@property (nonatomic, strong) UIButton *sendCodeButton;//发送验证码

@property (nonatomic, strong) UIView *lineView3;//线

@end


@implementation LxmZhuanZhangHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.textLabel];
    [self addSubview:self.accountTF];
    [self addSubview:self.lineView];
    [self addSubview:self.textLabel1];
    [self addSubview:self.tuijianmaTF];
    [self addSubview:self.lineView1];
    [self addSubview:self.textLabel2];
    [self addSubview:self.yuanlabel];
    [self addSubview:self.lineView2];
    [self addSubview:self.moneyTF];
    [self addSubview:self.textLabel3];
    [self addSubview:self.codeTF];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.lineView3];
    
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTF.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
    [self.tuijianmaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel1.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tuijianmaTF.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
    [self.yuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel2.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yuanlabel.mas_trailing);
        make.centerY.equalTo(self.yuanlabel);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.moneyTF.mas_bottom);
        make.height.equalTo(@1);
    }];
    [self.textLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel3.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-95);
        make.height.equalTo(@50);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.codeTF);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"转账账户";
    }
    return _textLabel;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [UITextField new];
        _accountTF.textColor = UIColor.blackColor;
        _accountTF.font = [UIFont boldSystemFontOfSize:14];
        NSString *holderText1 = @"请填写转账账户的手机号";
        NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
        [placeholder1 addAttribute:NSForegroundColorAttributeName
                             value:CharacterLightGrayColor
                             range:NSMakeRange(0, holderText1.length)];
        [placeholder1 addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14]
                             range:NSMakeRange(0, holderText1.length)];
        _accountTF.attributedPlaceholder = placeholder1;
    }
    return _accountTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont boldSystemFontOfSize:14];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = @"转账账户的授权码";
    }
    return _textLabel1;
}

- (UITextField *)tuijianmaTF {
    if (!_tuijianmaTF) {
        _tuijianmaTF = [UITextField new];
        _tuijianmaTF.textColor = UIColor.blackColor;
        _tuijianmaTF.font = [UIFont boldSystemFontOfSize:14];
        NSString *holderText1 = @"请填写转账账户的授权码";
        NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
        [placeholder1 addAttribute:NSForegroundColorAttributeName
                             value:CharacterLightGrayColor
                             range:NSMakeRange(0, holderText1.length)];
        [placeholder1 addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14]
                             range:NSMakeRange(0, holderText1.length)];
        _tuijianmaTF.attributedPlaceholder = placeholder1;
    }
    return _tuijianmaTF;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UILabel *)textLabel2 {
    if (!_textLabel2) {
        _textLabel2 = [UILabel new];
        _textLabel2.font = [UIFont boldSystemFontOfSize:14];
        _textLabel2.textColor = CharacterDarkColor;
        _textLabel2.text = @"转账金额";
    }
    return _textLabel2;
}

- (UILabel *)yuanlabel {
    if (!_yuanlabel) {
        _yuanlabel = [UILabel new];
        _yuanlabel.font = [UIFont boldSystemFontOfSize:25];
        _yuanlabel.textColor = UIColor.blackColor;
        _yuanlabel.text = @"¥";
    }
    return _yuanlabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = BGGrayColor;
    }
    return _lineView2;
}

- (UITextField *)moneyTF {
    if (!_moneyTF) {
        _moneyTF = [UITextField new];
        _moneyTF.textColor = UIColor.blackColor;
        _moneyTF.font = [UIFont boldSystemFontOfSize:25];
    }
    return _moneyTF;
}

- (UILabel *)textLabel3 {
    if (!_textLabel3) {
        _textLabel3 = [UILabel new];
        _textLabel3.font = [UIFont boldSystemFontOfSize:14];
        _textLabel3.textColor = CharacterDarkColor;
        _textLabel3.text = @"手机验证码";
    }
    return _textLabel3;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [UITextField new];
        _codeTF.textColor = UIColor.blackColor;
        _codeTF.font = [UIFont boldSystemFontOfSize:14];
        NSString *holderText1 = @"填写手机验证码";
        NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
        [placeholder1 addAttribute:NSForegroundColorAttributeName
                             value:CharacterLightGrayColor
                             range:NSMakeRange(0, holderText1.length)];
        [placeholder1 addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14]
                             range:NSMakeRange(0, holderText1.length)];
        _codeTF.attributedPlaceholder = placeholder1;
    }
    return _codeTF;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:MainColor forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sendCodeButton;
}

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [UIView new];
        _lineView3.backgroundColor = BGGrayColor;
    }
    return _lineView3;
}

@end



@interface LxmZhuanZhangVC ()

@property (nonatomic, strong) LxmZhuanZhangHeaderView *headerView;

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIButton *sureButton;//确认

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmZhuanZhangVC
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (LxmZhuanZhangHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmZhuanZhangHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 450)];
    }
    return _headerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确认转账" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转账";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self.headerView.sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.accountTF.keyboardType = UIKeyboardTypeNumberPad;
    self.headerView.moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
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
    self.tableView.tableHeaderView = self.headerView;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.tableView.tableFooterView = footView;
    
    [footView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.bottom.equalTo(footView);
        make.height.equalTo(@44);
    }];
}

/**
 发送验证码
 */
- (void)sendCodeButtonClick {
    NSDictionary *dict = @{
                           @"type" : @50,
                           @"token":SESSION_TOKEN,
                           @"telephone" : [LxmTool ShareTool].userModel.telephone,
                           @"chat" : @2
                           };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_identify parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self.timer invalidate];
            self.timer = nil;
            self.time = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer) userInfo:nil repeats:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.headerView.sendCodeButton.enabled = NO;
    [self.headerView.sendCodeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.headerView.sendCodeButton.enabled = YES;
        [self.headerView.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/**
 确认转账
 */
- (void)sureButtonClick {
    [self.headerView endEditing:YES];
    NSString *account = self.headerView.accountTF.text;
    NSString *tuijiancode = self.headerView.tuijianmaTF.text;
    NSString *moeny = self.headerView.moneyTF.text;
    NSString *code = self.headerView.codeTF.text;
    if (!account.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账账户的手机号!"];
        return;
    }
    if (!tuijiancode.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账账户的授权码!"];
        return;
    }
    if (!moeny.isValid || moeny.intValue <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额!"];
        return;
    }
    if (!code.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机验证码!"];
        return;
    }
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"telephone" : account,
                           @"recommend" : tuijiancode,
                           @"code" : code,
                           @"payMoney" : moeny
                           };
    [SVProgressHUD show];
    self.sureButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LxmNetworking networkingPOST:give_money parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        selfWeak.sureButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"转账申请已提交!"];
            [LxmEventBus sendEvent:@"zhuanzhangSuccess" data:nil];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        selfWeak.sureButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

@end
