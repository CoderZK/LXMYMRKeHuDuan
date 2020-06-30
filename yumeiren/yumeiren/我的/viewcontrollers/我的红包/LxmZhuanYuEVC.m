//
//  LxmZhuanYuEVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/29.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmZhuanYuEVC.h"

@interface LxmZhuanYuEHeaderView : UIView

@property (nonatomic, strong) UILabel *textLabel;//充值金额

@property (nonatomic, strong) UILabel *yuanlabel;//元

@property (nonatomic, strong) UITextField *moneyTF;//输入的钱数

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIButton *allTiXianButton;//全部提现

@property (nonatomic, strong) UILabel *allLabel;//全部提现文字描述

@end

@implementation LxmZhuanYuEHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}


/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.textLabel];
    [self addSubview:self.yuanlabel];
    [self addSubview:self.moneyTF];
    [self addSubview:self.lineView];
    [self addSubview:self.allTiXianButton];
    [self.allTiXianButton addSubview:self.allLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
    [self.yuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yuanlabel.mas_trailing);
        make.centerY.equalTo(self.yuanlabel);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.moneyTF.mas_bottom);
        make.height.equalTo(@1);
    }];
    [self.allTiXianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allTiXianButton).offset(5);
        make.leading.equalTo(self.allTiXianButton).offset(15);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"转账金额";
    }
    return _textLabel;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UITextField *)moneyTF {
    if (!_moneyTF) {
        _moneyTF = [UITextField new];
        _moneyTF.textColor = UIColor.blackColor;
        _moneyTF.font = [UIFont boldSystemFontOfSize:25];
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _moneyTF;
}

- (UIButton *)allTiXianButton {
    if (!_allTiXianButton) {
        _allTiXianButton = [[UIButton alloc] init];
    }
    return _allTiXianButton;
}

- (UILabel *)allLabel {
    if (!_allLabel) {
        _allLabel = [[UILabel alloc] init];
        _allLabel.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次可提现¥%.2f， ",[LxmTool ShareTool].userModel.redBalance.doubleValue] attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"全部转账" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:125/255.0 green:191/255.0 blue:255/255.0 alpha:1]}];
        [att appendAttributedString:str];
        _allLabel.attributedText = att;
    }
    return _allLabel;
}

@end



@interface LxmZhuanYuEVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmZhuanYuEHeaderView *headerView;

@property (nonatomic, strong) UIButton *tixainButton;//提现

@end

@implementation LxmZhuanYuEVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)tixainButton {
    if (!_tixainButton) {
        _tixainButton = [[UIButton alloc] init];
        [_tixainButton setTitle:@"转账" forState:UIControlStateNormal];
        [_tixainButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tixainButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _tixainButton.layer.cornerRadius = 5;
        _tixainButton.layer.masksToBounds = YES;
        _tixainButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tixainButton addTarget:self action:@selector(tixianButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixainButton;
}
- (LxmZhuanYuEHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmZhuanYuEHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转余额";
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self.headerView.allTiXianButton addTarget:self action:@selector(allTiXinClick) forControlEvents:UIControlEventTouchUpInside];
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
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.tableView.tableFooterView = footView;
    
    [footView addSubview:self.tixainButton];
    [self.tixainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.bottom.equalTo(footView);
        make.height.equalTo(@44);
    }];
}

/**
 转账
 */
- (void)textFieldDidChanged {
    if (self.headerView.moneyTF.text.doubleValue > [LxmTool ShareTool].userModel.redBalance.doubleValue) {
        self.headerView.moneyTF.text = [LxmTool ShareTool].userModel.redBalance;
    }
}

- (void)tixianButtonClick {
    [self.headerView endEditing:YES];
    if (!self.headerView.moneyTF.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额!"];
        return;
    }
    if (self.headerView.moneyTF.text.doubleValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能为0!"];
        return;
    }
    if (self.headerView.moneyTF.text.doubleValue > [LxmTool ShareTool].userModel.redBalance.doubleValue) {
        [SVProgressHUD showErrorWithStatus:@"红包余额不足!"];
        return;
    }
    [self zyeWithPrice:self.headerView.moneyTF.text];
}


- (void)zyeWithPrice:(NSString *)price {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:change_red parameters:@{@"token":SESSION_TOKEN,@"balance" : price} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        StrongObj(self);
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已转至余额!"];
            [self loadMyUserInfoWithOkBlock:^{
                [LxmEventBus sendEvent:@"hongbaozhuanru" data:nil];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)allTiXinClick {
    self.headerView.moneyTF.text = [NSString stringWithFormat:@"%.2f",[LxmTool ShareTool].userModel.redBalance.doubleValue];
}

@end
