//
//  LxmShenQingReasonAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShenQingReasonAlertView.h"



@interface LxmShenQingReasonAlertView ()

@property (nonatomic , strong) UIView * contentView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIButton *sureButton;//确定

@property (nonatomic, strong) IQTextView *textView;//申请理由输入框

@end

@implementation LxmShenQingReasonAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, ScreenH*0.5-105, ScreenW - 60, 200)];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        [self initContentSubviews];
        [self setConstrains];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.text = @"申请理由";
    }
    return _titleLabel;
}

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.placeholder = @"请输入申请理由!";
        _textView.backgroundColor = BGGrayColor;
        _textView.font = [UIFont systemFontOfSize:14];
        
    }
    return _textView;
}


- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.sureButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.sureButton.mas_top);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        selfWeak.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat space = 20;
    _contentView.frame =  CGRectMake(30, height-space-200, ScreenW-60, 200);
}

- (void)keyboardWillHide:(NSNotification *)noti {
    _contentView.frame = CGRectMake(30,  ScreenH*0.5-100, ScreenW-60, 200);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


/// 确定
- (void)sureClick {
    [self.contentView endEditing:YES];
    NSString *text = self.textView.text;
    if (!text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入申请理由!"];
        return;
    }
    if (text.length < 50 || text.length > 250) {
        [SVProgressHUD showErrorWithStatus:@"申请理由在50~250字!"];
        return;
    }
    if (self.shenqingReasonBlock) {
        self.shenqingReasonBlock(text);
    }
    [self dismiss];
}


@end
