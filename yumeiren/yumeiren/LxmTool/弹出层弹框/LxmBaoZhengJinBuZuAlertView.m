//
//  LxmBaoZhengJinBuZuAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmBaoZhengJinBuZuAlertView.h"
#import "LxmPayVC.h"

@interface LxmBaoZhengJinBuZuAlertView()

@property (nonatomic, strong) UIButton * bgBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *textLabel1;

@property (nonatomic, strong) UILabel *textLabel2;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *jiaoButton;

@end

@implementation LxmBaoZhengJinBuZuAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview: self.bgBtn];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.bgBtn addSubview:self.contentView];
        
        [self initContentSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textLabel1];
    [self.contentView addSubview:self.textLabel2];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.jiaoButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgBtn);
        make.width.equalTo(@(ScreenW - 120));
//        make.height.equalTo(@(260));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView);
    }];
    [self.textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel1.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel2.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@80);
    }];
    [self.jiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(15);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.text = @"保证金不足";
    }
    return _titleLabel;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont systemFontOfSize:13];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = [NSString stringWithFormat:@"因违规操作罚款%@元,保证金不足",[LxmTool ShareTool].userModel.depositMoney];
    }
    return _textLabel1;
}

- (UILabel *)textLabel2 {
    if (!_textLabel2) {
        _textLabel2 = [UILabel new];
        _textLabel2.font = [UIFont systemFontOfSize:13];
        _textLabel2.textColor = CharacterDarkColor;
        _textLabel2.text = @"无法登录";
    }
    return _textLabel2;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"weikong"];
    }
    return _imgView;
}

- (UIButton *)jiaoButton {
    if (!_jiaoButton) {
        _jiaoButton = [[UIButton alloc] init];
        [_jiaoButton setTitle:[NSString stringWithFormat:@"交%@元保证金",[LxmTool ShareTool].userModel.depositMoney] forState:UIControlStateNormal];
        [_jiaoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_jiaoButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _jiaoButton.layer.cornerRadius = 5;
        _jiaoButton.layer.masksToBounds = YES;
        [_jiaoButton addTarget:self action:@selector(jiaoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiaoButton;
}


-(void)show {
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
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/**
 缴纳保证金
 */
- (void)jiaoButtonClick {
    [self dismiss];
    LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_bujiaobaozhengjin];
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}


@end
