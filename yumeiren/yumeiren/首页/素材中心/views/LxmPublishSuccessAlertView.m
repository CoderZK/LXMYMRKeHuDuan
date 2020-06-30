
//
//  LxmPublishSuccessAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPublishSuccessAlertView.h"

@interface LxmPublishSuccessAlertView ()

@property (nonatomic, strong) UIButton * bgBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong)  UIImageView *publishSuccessImgView;

@property (nonatomic, strong) UILabel *publishSuccessLabel;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LxmPublishSuccessAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self.bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
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
    [self.contentView addSubview:self.publishSuccessImgView];
    [self.contentView addSubview:self.publishSuccessLabel];
    [self.contentView addSubview:self.textLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgBtn);
        make.width.equalTo(@(ScreenW - 120));
        make.height.equalTo(@195);
    }];
    [self.publishSuccessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@80);
    }];
    [self.publishSuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishSuccessImgView.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishSuccessLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
}

- (UIImageView *)publishSuccessImgView {
    if (!_publishSuccessImgView) {
        _publishSuccessImgView = [UIImageView new];
        _publishSuccessImgView.image = [UIImage imageNamed:@"weikong"];
    }
    return _publishSuccessImgView;
}

- (UILabel *)publishSuccessLabel {
    if (!_publishSuccessLabel) {
        _publishSuccessLabel = [UILabel new];
        _publishSuccessLabel.font = [UIFont boldSystemFontOfSize:15];
        _publishSuccessLabel.text = @"发布成功";
    }
    return _publishSuccessLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.font = [UIFont systemFontOfSize:12];
    }
    return _textLabel;
}

- (void)setRoleType:(NSString *)roleType {
    _roleType = roleType;
    if (_roleType.intValue == -1 || _roleType.intValue == 0 || _roleType.intValue == 1) {
        _textLabel.text = @"审核中~请耐心等待审核哦";
    } else {
        _textLabel.text = @"审核中~审核成功即可获得红包";
    }
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

- (void)btnClick:(UIButton *)btn {
    [self dismiss];
}

@end
