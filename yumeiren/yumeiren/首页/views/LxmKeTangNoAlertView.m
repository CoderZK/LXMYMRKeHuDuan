//
//  LxmKeTangNoAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/29.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmKeTangNoAlertView.h"

@interface LxmKeTangNoAlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;/* 标题 */

@end


@implementation LxmKeTangNoAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 80)*0.5, ScreenW - 80, 80)];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
        [bgBtn addSubview:self.contentView];
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
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"暂未开放...";
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

-(void)show {
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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


@end
