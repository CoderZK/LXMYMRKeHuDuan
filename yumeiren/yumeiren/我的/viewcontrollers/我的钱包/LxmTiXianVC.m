//
//  LxmTiXianVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTiXianVC.h"
#import "LxmBankListVC.h"
#import "LxmTiXianZhongVC.h"


@interface LxmTiXianButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel1;//标题

@property (nonatomic, strong) UIImageView *selectImgView;//选择

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmTiXianButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel1];
        [self addSubview:self.selectImgView];
        [self addSubview:self.lineView ];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.font = [UIFont systemFontOfSize:14];
        _titleLabel1.textColor = CharacterDarkColor;
    }
    return _titleLabel1;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
    }
    return _selectImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmZhifuBaoTextAndPutinTFView : UIView

@property (nonatomic, strong) UILabel *leftLabel;//左侧标签

@property (nonatomic, strong) UITextField *rightTF;//右侧输入

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmZhifuBaoTextAndPutinTFView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@80);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing);
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

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:14];
    }
    return _leftLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:14];
        _rightTF.textAlignment = NSTextAlignmentRight;
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}


@end

@interface LxmZhifuBaoView : UIView

@property (nonatomic, strong) LxmZhifuBaoTextAndPutinTFView *nameView;//姓名

@property (nonatomic, strong) LxmZhifuBaoTextAndPutinTFView *accountView;//账号

@end
@implementation LxmZhifuBaoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameView];
        [self addSubview:self.accountView];
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(self.accountView);
        }];
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameView.mas_bottom);
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(self.nameView);
        }];
    }
    return self;
}

- (LxmZhifuBaoTextAndPutinTFView *)nameView {
    if (!_nameView) {
        _nameView = [LxmZhifuBaoTextAndPutinTFView new];
        _nameView.leftLabel.text = @"姓名";
        _nameView.rightTF.placeholder = @"请输入姓名";
    }
    return _nameView;
}

- (LxmZhifuBaoTextAndPutinTFView *)accountView {
    if (!_accountView) {
        _accountView = [LxmZhifuBaoTextAndPutinTFView new];
        _accountView.leftLabel.text = @"账号";
        _accountView.rightTF.placeholder = @"请输入账号";
    }
    return _accountView;
}

@end



@interface LxmTiXianHeaderView : UIView

@property (nonatomic, strong) UILabel *textLabel;//充值金额

@property (nonatomic, strong) UILabel *yuanlabel;//元

@property (nonatomic, strong) UITextField *moneyTF;//输入的钱数

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *allLabel;//全部提现文字描述

@property (nonatomic, strong) LxmTiXianButton *zhifubaoBtn;//支付宝按钮

@property (nonatomic, strong) LxmTiXianButton *yinhangkaBtn;//银行卡按钮

@property (nonatomic, strong) UILabel *detailInfoLabel;//详细信息

@property (nonatomic, strong) UILabel *textLabel1;//银行卡

@property (nonatomic, strong) UIImageView *accImgVIew;//箭头


@property (nonatomic, strong) UIButton *selectButton;//银行卡


@property (nonatomic, strong) UIImageView *addImgView;//添加银行卡

@property (nonatomic, strong) LxmZhifuBaoView *zhifubaoView;

@property (nonatomic, strong) UILabel *bankCardNo;//银行 + 银行卡号

@property (nonatomic, strong) UILabel *textLabel2;//手机验证码

@property (nonatomic, strong) UITextField *codeTF;//验证码

@property (nonatomic, strong) UIButton *sendCodeButton;//发送验证码

@property (nonatomic, strong) UIView *lineView1;//线

@property (nonatomic, strong) UILabel *shuomingLabel;

@property (nonatomic, copy) void(^tixianStyleClikBlock)(NSInteger index);

@property (nonatomic, copy) void(^addImgClikBlock)(NSInteger index);

@property (nonatomic, strong) LxmMyBankModel *bankModel;

@end

@implementation LxmTiXianHeaderView

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
    [self addSubview:self.allLabel];
    [self addSubview:self.selectButton];
    [self.selectButton addSubview:self.textLabel1];
    [self.selectButton addSubview:self.accImgVIew];
    
    [self addSubview:self.zhifubaoBtn];
    [self addSubview:self.yinhangkaBtn];
    [self addSubview:self.detailInfoLabel];
    
    [self addSubview:self.addImgView];
    [self.addImgView addSubview:self.bankCardNo];
    [self addSubview:self.zhifubaoView];

    [self addSubview:self.textLabel2];
    [self addSubview:self.codeTF];
    [self addSubview:self.shuomingLabel];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.lineView1];
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
        make.leading.equalTo(self).offset(18);
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
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allLabel.mas_bottom).offset(20);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton).offset(15);
        make.centerY.equalTo(self.selectButton);
    }];
    [self.accImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectButton).offset(-15);
        make.centerY.equalTo(self.selectButton);
        make.width.height.equalTo(@15);
    }];
    
    [self.zhifubaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectButton.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.yinhangkaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhifubaoBtn.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yinhangkaBtn.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.height.equalTo(@40);
    }];
    [self.zhifubaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailInfoLabel.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@100);
    }];
    [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailInfoLabel.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@((ScreenW - 30) * 150/690));
    }];
    [self.bankCardNo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.addImgView).offset(15);
        make.centerY.equalTo(self.addImgView);
    }];
    [self.textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhifubaoView.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel2.mas_bottom).offset(10);
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
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.shuomingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"提现金额";
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
        _moneyTF.font = [UIFont boldSystemFontOfSize:20];
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTF.placeholder = [NSString stringWithFormat:@"单笔提现最低%@元",LxmTool.ShareTool.userModel.cashMoney];
    }
    return _moneyTF;
}



- (UILabel *)shuomingLabel {
    if (!_shuomingLabel) {
        _shuomingLabel = [UILabel new];
        _shuomingLabel.textColor = CharacterLightGrayColor;
        _shuomingLabel.font = [UIFont systemFontOfSize:13];
        _shuomingLabel.numberOfLines = 0;
        _shuomingLabel.text = @"提现说明：提现后将于T+2确认到账结果。其中T日指提现日当天（下午5点以前，下午5点以后为下一交易日），T+2日指T日的第二天，例如T日为周一则T+2为周三，遇周末或法定节假日顺延。";
    }
    return _shuomingLabel;
}


- (UILabel *)allLabel {
    if (!_allLabel) {
        _allLabel = [[UILabel alloc] init];
        _allLabel.font = [UIFont systemFontOfSize:14];
        _allLabel.numberOfLines = 0;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"本次提现需手续费" attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",0] attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        _allLabel.attributedText = att;
    }
    return _allLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
    }
    return _selectButton;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont boldSystemFontOfSize:14];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = @"选择提现方式";
    }
    return _textLabel1;
}

- (UIImageView *)accImgVIew {
    if (!_accImgVIew) {
        _accImgVIew = [UIImageView new];
        _accImgVIew.image = [UIImage imageNamed:@"next"];
    }
    return _accImgVIew;
}


- (LxmTiXianButton *)zhifubaoBtn {
    if (!_zhifubaoBtn) {
        _zhifubaoBtn = [LxmTiXianButton new];
        _zhifubaoBtn.iconImgView.image = [UIImage imageNamed:@"alipay_pay"];
        _zhifubaoBtn.titleLabel1.text = @"支付宝";
        _zhifubaoBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        [_zhifubaoBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhifubaoBtn;
}

- (LxmTiXianButton *)yinhangkaBtn {
    if (!_yinhangkaBtn) {
        _yinhangkaBtn = [LxmTiXianButton new];
        _yinhangkaBtn.iconImgView.image = [UIImage imageNamed:@"yinhangka"];
        _yinhangkaBtn.titleLabel1.text = @"银行卡";
        _yinhangkaBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        [_yinhangkaBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yinhangkaBtn;
}

- (UILabel *)detailInfoLabel {
    if (!_detailInfoLabel) {
        _detailInfoLabel = [UILabel new];
        _detailInfoLabel.text = @"详情信息";
        _detailInfoLabel.textColor = CharacterGrayColor;
        _detailInfoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailInfoLabel;
}

- (UIImageView *)addImgView {
    if (!_addImgView) {
        _addImgView = [UIImageView new];
        _addImgView.image = [UIImage imageNamed:@"tianjia"];
        _addImgView.userInteractionEnabled = YES;
        _addImgView.layer.cornerRadius = 3;
        _addImgView.layer.masksToBounds = YES;
        _addImgView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddImgView)];
        [_addImgView addGestureRecognizer:tap];
    }
    return _addImgView;
}

- (LxmZhifuBaoView *)zhifubaoView {
    if (!_zhifubaoView) {
        _zhifubaoView = [LxmZhifuBaoView new];
    }
    return _zhifubaoView;
}


- (UILabel *)textLabel2 {
    if (!_textLabel2) {
        _textLabel2 = [UILabel new];
        _textLabel2.font = [UIFont boldSystemFontOfSize:14];
        _textLabel2.textColor = CharacterDarkColor;
        _textLabel2.text = @"手机验证码";
    }
    return _textLabel2;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [UITextField new];
        _codeTF.textColor = UIColor.blackColor;
        _codeTF.font = [UIFont boldSystemFontOfSize:14];
        _codeTF.placeholder = @"填写手机验证码";
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

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UILabel *)bankCardNo {
    if (!_bankCardNo) {
        _bankCardNo = [UILabel new];
        _bankCardNo.textColor = UIColor.whiteColor;
        _bankCardNo.font = [UIFont systemFontOfSize:14];
        _bankCardNo.text = @"华夏银行 1531535678905677888";
        _bankCardNo.hidden = YES;
    }
    return _bankCardNo;
}

- (void)tapAddImgView {
    if (self.addImgClikBlock) {
        self.addImgClikBlock(222);
    }
}

- (void)setBankModel:(LxmMyBankModel *)bankModel {
    _zhifubaoBtn.selected = NO;
    _zhifubaoBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    _yinhangkaBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
    _zhifubaoView.hidden = YES;
    _addImgView.hidden = NO;
    [self bringSubviewToFront:_addImgView];
    [self.textLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImgView.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
    }];
    [self layoutIfNeeded];
}

- (void)selectedClick:(UIButton *)btn {
    btn.selected = YES;
    NSInteger index = 111;
    if (btn == _zhifubaoBtn) {
        _yinhangkaBtn.selected = NO;
        _yinhangkaBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        _zhifubaoBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        _addImgView.hidden = YES;
        _zhifubaoView.hidden = NO;
        [self bringSubviewToFront:_zhifubaoView];
        [self.textLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhifubaoView.mas_bottom).offset(20);
            make.leading.equalTo(self).offset(15);
        }];
        index = 111;
        
    } else {
        _zhifubaoBtn.selected = NO;
        _zhifubaoBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        _yinhangkaBtn.selectImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        _zhifubaoView.hidden = YES;
        _addImgView.hidden = NO;
        [self bringSubviewToFront:_addImgView];
        [self.textLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addImgView.mas_bottom).offset(20);
            make.leading.equalTo(self).offset(15);
        }];
        index = 222;
    }
    [self layoutIfNeeded];
    if (self.tixianStyleClikBlock) {
        self.tixianStyleClikBlock(index);
    }
}

@end


@interface LxmTiXianVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmTiXianHeaderView *headerView;

@property (nonatomic, strong) UIButton *tixainButton;//提现

@property (nonatomic, strong) LxmMyBankModel *bankModel;//提现到此银行卡

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@property (nonatomic, assign) NSInteger selectIndex;//选择的支付方式

@end

@implementation LxmTiXianVC


- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

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
        [_tixainButton setTitle:@"提现" forState:UIControlStateNormal];
        [_tixainButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tixainButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _tixainButton.layer.cornerRadius = 5;
        _tixainButton.layer.masksToBounds = YES;
        _tixainButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tixainButton addTarget:self action:@selector(tixianButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixainButton;
}

- (LxmTiXianHeaderView *)headerView {
    if (!_headerView) {
        NSString *str = @"提现说明：提现后将于T+2确认到账结果。其中T日指提现日当天（下午5点以前，下午5点以后为下一交易日），T+2日指T日的第二天，例如T日为周一则T+2为周三，遇周末或法定节假日顺延。";
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 999) withFontSize:13].height;
        
        _headerView = [[LxmTiXianHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 330 + 140 + 100 + h + 10 - 40)];
        WeakObj(self);
        _headerView.tixianStyleClikBlock = ^(NSInteger index) {
            [selfWeak tixianFangshiClick:index height:h];
        };
        _headerView.addImgClikBlock = ^(NSInteger index) {
            LxmBankListVC *vc = [[LxmBankListVC alloc] init];
            vc.selectBankModelBlock = ^(LxmMyBankModel *model) {
                selfWeak.bankModel = model;
                [selfWeak setHeaderViewModel:model];
            };
            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (void)tixianFangshiClick:(NSInteger)index height:(NSInteger)height {
    self.selectIndex = index;
    if (index == 111) {
        _headerView.frame = CGRectMake(0, 0, ScreenW, 330 + 140 + 100 + height + 10 - 40);
    } else {
        _headerView.frame = CGRectMake(0, 0, ScreenW, 330 + 140 + (ScreenW - 30) * 150/690 + height + 10 - 40);
    }
    [_headerView layoutIfNeeded];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.headerView.moneyTF.delegate = self;
    [self.headerView.sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.selectIndex = 111;//默认支付宝方式
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
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    self.tableView.tableFooterView = footView;
    
    [footView addSubview:self.tixainButton];
    [self.tixainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.center.equalTo(footView);
        make.height.equalTo(@44);
    }];
}

/**
 发送验证码
 */
- (void)sendCodeButtonClick {
    NSDictionary *dict = @{
                           @"type" : @40,
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
 提现
 */
- (void)textFieldDidChanged {
    if (self.headerView.moneyTF.text.doubleValue > [LxmTool ShareTool].userModel.balance.doubleValue) {
        self.headerView.moneyTF.text = [LxmTool ShareTool].userModel.balance;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByAppendingString:string];
    CGFloat money = str.integerValue * LxmTool.ShareTool.userModel.cashRate.doubleValue;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"本次提现需手续费" attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",money] attributes:@{NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str1];
    self.headerView.allLabel.attributedText = att;
    return YES;
}


- (void)tixianButtonClick {
    [self.headerView endEditing:YES];
    NSString *code  = self.headerView.codeTF.text;
    if (self.headerView.moneyTF.text.doubleValue <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额!"];
        return;
    }
    if (self.headerView.moneyTF.text.doubleValue > [LxmTool ShareTool].userModel.balance.doubleValue) {
        [SVProgressHUD showErrorWithStatus:@"余额不足!"];
        return;
    }
    if (self.headerView.moneyTF.text.doubleValue < LxmTool.ShareTool.userModel.cashMoney.doubleValue) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"提现最低金额为%@元",LxmTool.ShareTool.userModel.cashMoney]];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.selectIndex == 111) {//支付宝方式
        NSString *name = self.headerView.zhifubaoView.nameView.rightTF.text;
        NSString *acconut = self.headerView.zhifubaoView.accountView.rightTF.text;
        if (!name.isValid) {
            [SVProgressHUD showErrorWithStatus:@"请输入支付宝姓名!"];
            return;
        }
        if (!acconut.isValid) {
            [SVProgressHUD showErrorWithStatus:@"请输入支付宝账号!"];
            return;
        }
        bool isPhone = [NSString checkPhone:acconut];
        bool isEmail = [NSString checkEmail:acconut];
        if (!isEmail && !isPhone) {
            [SVProgressHUD showErrorWithStatus:@"支付宝账号必须是手机号或邮箱!"];
            return;
        }
        dic[@"zhi_name"] = name;
        dic[@"zhi_account"] = acconut;
    } else {//银行卡方式
        if (!self.bankModel) {
            [SVProgressHUD showErrorWithStatus:@"请选择提现银行卡!"];
            return;
        }
        dic[@"bankId"] = self.bankModel.id;
    }
    dic[@"info_type"] = (self.selectIndex == 111 ? @2 : @1);
    dic[@"token"] = SESSION_TOKEN;
    dic[@"payMoney"] = self.headerView.moneyTF.text;
    dic[@"code"] = code;
    if (![code isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机验证码"];
        return;
    }
    self.tixainButton.userInteractionEnabled = NO;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:up_cash_out parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        selfWeak.tixainButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LxmEventBus sendEvent:@"tixianSuccess" data:nil];
            LxmTiXianZhongVC *vc = [[LxmTiXianZhongVC alloc] init];
            [selfWeak.navigationController pushViewController:vc animated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        selfWeak.tixainButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
    
}

- (void)allTiXinClick {
    self.headerView.moneyTF.text = [NSString stringWithFormat:@"%.2f",[LxmTool ShareTool].userModel.balance.doubleValue];
}

- (void)setHeaderViewModel:(LxmMyBankModel *)model {
    self.headerView.addImgView.backgroundColor = [UIColor redColor];
    self.headerView.addImgView.image = [UIImage imageNamed:@"blue"];
    self.headerView.bankCardNo.hidden = NO;
    NSString *str = model.bankCode;
    if (str.length >= 4) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < str.length - 4; i++) {
            [arr addObject:@"*"];
        }
        str = [str substringWithRange:NSMakeRange(str.length - 4, 4)];
        self.headerView.bankCardNo.text = [NSString stringWithFormat:@"%@  %@", model.bankName,  [[arr componentsJoinedByString:@""] stringByAppendingString:str]];
    } else {
        self.headerView.bankCardNo.text = [NSString stringWithFormat:@"%@  %@", model.bankName,  model.bankCode];
    }
}

@end
