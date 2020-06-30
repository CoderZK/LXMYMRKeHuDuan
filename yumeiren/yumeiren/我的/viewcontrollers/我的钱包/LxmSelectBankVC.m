//
//  LxmSelectBankVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSelectBankVC.h"
#import "LxmXuanZeBankVC.h"

@interface LxmSelectBankCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) UIImageView *accImgView;

@property (nonatomic, strong) UIView *lineView;


@end
@implementation LxmSelectBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.accImgView];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@55);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
        }];
        [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"银行";
    }
    return _titleLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.placeholder = @"请选择银行卡";
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:14];
        _rightTF.userInteractionEnabled = NO;
    }
    return _rightTF;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end

//开户行信息
@interface LxmSelectOpenBankCardCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) IQTextView *rightTV;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmSelectOpenBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightTV];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
        [self.rightTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.top.equalTo(self.titleLabel).offset(-7);
            make.bottom.equalTo(self).offset(-15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"开户行";
    }
    return _titleLabel;
}

- (IQTextView *)rightTV {
    if (!_rightTV) {
        _rightTV = [[IQTextView alloc] init];
        _rightTV.placeholder = @"请输入银行开户行";
        _rightTV.textColor = CharacterDarkColor;
        _rightTV.font = [UIFont systemFontOfSize:14];
    }
    return _rightTV;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}



@end



@interface LxmSelectBankCardCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmSelectBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@55);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"卡号";
    }
    return _titleLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.placeholder = @"请输入卡号";
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:14];
        _rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmSelectBankVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIButton *sureButton;//确认

@property (nonatomic, strong) LxmBankModel *currentModel;

@property (nonatomic, strong) LxmSelectBankCardCell *cardNoCell;

@property (nonatomic, strong) IQTextView *rightTV;

@end

@implementation LxmSelectBankVC

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
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
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
    
    [footView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.bottom.equalTo(footView);
        make.height.equalTo(@44);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmSelectBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectBankCell"];
        if (!cell) {
            cell = [[LxmSelectBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectBankCell"];
        }
        if (self.currentModel) {
            cell.rightTF.textColor = CharacterDarkColor;
            cell.rightTF.text = self.currentModel.bankName;
        } else {
            cell.rightTF.textColor = CharacterLightGrayColor;
        }
        return cell;
    } else if (indexPath.row == 1) {
        LxmSelectOpenBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectOpenBankCardCell"];
        if (!cell) {
            cell = [[LxmSelectOpenBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectOpenBankCardCell"];
        }
        self.rightTV = cell.rightTV;
        return cell;
    } else {
        LxmSelectBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectBankCardCell"];
        if (!cell) {
           cell = [[LxmSelectBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectBankCardCell"];
        }
        self.cardNoCell = cell;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 65;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//银行
        LxmXuanZeBankVC *vc = [[LxmXuanZeBankVC alloc] init];
        WeakObj(self);
        vc.selectBankModelBlock = ^(LxmBankModel *model) {
            NSLog(@"%@", model.bankName);
            selfWeak.currentModel = model;
            [selfWeak.tableView reloadData];
        };
        if (self.currentModel) {
            vc.currentModel = self.currentModel;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 确认
 */
- (void)sureButtonClick {
    if (!self.currentModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择银行!"];
        return;
    }
    if (!self.rightTV.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行开户行信息!"];
        return;
    }
    if (!self.cardNoCell.rightTF.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入卡号!"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"openBank" : self.rightTV.text,
                           @"username" : [LxmTool ShareTool].userModel.username,
                           @"bankName" : self.currentModel.bankName,
                           @"bankCode" : self.cardNoCell.rightTF.text
                           };
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:add_bank parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已添加!"];
            [LxmEventBus sendEvent:@"addBankSuccess" data:nil];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
