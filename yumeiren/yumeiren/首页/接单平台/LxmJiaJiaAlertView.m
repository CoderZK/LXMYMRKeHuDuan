

//
//  LxmJiaJiaAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/2.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJiaJiaAlertView.h"

@interface LxmJiaJiaAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titlelabel;//加价

@property (nonatomic, strong) UITextField *textTF;//输入的加价金额

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIView *lineView1;//线

@property (nonatomic, assign) LxmJiaJiaAlertView_type type;

@end

@implementation LxmJiaJiaAlertView

- (instancetype)initWithFrame:(CGRect)frame type:(LxmJiaJiaAlertView_type)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titlelabel];
        [self.contentView addSubview:self.textTF];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.sureButton];
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(40, ScreenH*0.5-105, ScreenW - 80, 160)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenW-80)*0.5 - 40, 20, 80, 20)];
        _titlelabel.font = [UIFont boldSystemFontOfSize:15];
        _titlelabel.textColor = CharacterDarkColor;
        _titlelabel.text = self.type == LxmJiaJiaAlertView_type_jiajia ? @"加价" : self.type == LxmJiaJiaAlertView_type_dafen ? @"打分" : @"转余额";
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}


- (UITextField *)textTF {
    if (!_textTF) {
        _textTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 60, ScreenW - 80 - 30, 44)];
        _textTF.delegate = self;
        _textTF.backgroundColor = BGGrayColor;
        _textTF.textAlignment = NSTextAlignmentCenter;
        _textTF.layer.cornerRadius = 3;
        _textTF.layer.masksToBounds = YES;
        if (self.type == LxmJiaJiaAlertView_type_jiajia) {
            _textTF.placeholder = @"请输入加价金额";
        } else if (self.type == LxmJiaJiaAlertView_type_dafen) {
            _textTF.placeholder = @"请输入分数";
        } else if (self.type == LxmJiaJiaAlertView_type_zye) {
            _textTF.placeholder = @"请输入转余额金额";
        }
        
        _textTF.font = [UIFont systemFontOfSize:14];
        _textTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _textTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, ScreenW - 80, 0.5)];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake((ScreenW - 80)*0.5 - 0.25, 115.5, 0.5, 44.5)];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 116, (ScreenW - 80)*0.5 - 0.25, 44)];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW - 80)*0.5 + 0.25, 116, (ScreenW - 80)*0.5 - 0.25, 44)];
        _sureButton.backgroundColor = [UIColor whiteColor];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
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
    _contentView.frame =  CGRectMake(40, height-space-160, ScreenW-80, 160);
}

- (void)keyboardWillHide:(NSNotification *)noti {
    _contentView.frame = CGRectMake(40,  ScreenH*0.5-80, ScreenW-80, 160);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)sureClick {
    [self.contentView endEditing:YES];
    if (![self.textTF.text isValid]) {
        [SVProgressHUD showErrorWithStatus:self.type == LxmJiaJiaAlertView_type_jiajia ? @"请输入加价金额!" : self.type == LxmJiaJiaAlertView_type_dafen ? @"请输入分数!" : @"请输入转余额金额"];
        return;
    }
    if (self.textTF.text.floatValue == 0) {
        [SVProgressHUD showErrorWithStatus:self.type == LxmJiaJiaAlertView_type_jiajia ? @"加价金额不能为0!" : self.type == LxmJiaJiaAlertView_type_dafen ? @"打分分数不能为0!" : @"转余额金额不能为0"];
        return;
    }
    if (self.type == LxmJiaJiaAlertView_type_dafen) {
        if (self.textTF.text.floatValue > 100) {
            [SVProgressHUD showErrorWithStatus:@"打分分数在0~100之间!"];
            return;
        }
    }
    if (self.jiajiaBlock) {
        self.jiajiaBlock(self.textTF.text);
    }
    [self dismiss];
}

@end
