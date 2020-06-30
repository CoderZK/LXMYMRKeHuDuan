//
//  LxmKuCunBuZuAletView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmKuCunBuZuAletView.h"

@interface LxmKuCunBuZuAletView()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;/* 标题 */

@property (nonatomic, strong) LxmKuCunBuZuBottomView *bottomView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *iconImgView;

@end

@implementation LxmKuCunBuZuAletView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.bounds.size.height - 350)*0.5, ScreenW - 60, 350)];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        [self initContentSubviews];
        [self setConstrains];
        [self.bottomView.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView.sureButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomView.cancelButton.tag = 601;
        self.bottomView.sureButton.tag = 600;
    }
    return self;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.centerView];
    [self.contentView addSubview:self.bottomView];
    [self.centerView addSubview:self.textLabel];
    [self.centerView addSubview:self.iconImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.centerX.equalTo(self.contentView);
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-120);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView);
        make.leading.equalTo(self.centerView).offset(15);
        make.trailing.equalTo(self.centerView).offset(-15);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerView).offset(-10);
        make.centerX.equalTo(self.centerView);
        make.width.height.equalTo(@80);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.centerView.mas_bottom);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.text = @"库存不足";
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"weikong"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"购物车中的商品a,商品b数量不足";
    }
    return _textLabel;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (LxmKuCunBuZuBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [LxmKuCunBuZuBottomView new];
    }
    return _bottomView;
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
    NSLog(@"%ld",btn.tag);
    if (self.bottomClickBlock) {
        self.bottomClickBlock(btn.tag);
    }
    [self dismiss];
}

@end


@implementation LxmKuCunBuZuBottomView
- (instancetype)initWithFrame:(CGRect)frame {
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
    [self addSubview:self.cancelButton];
    [self addSubview:self.sureButton];
}

/**
 添加约束
 */
- (void)setConstrains {
   
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-30);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"等待库存" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:MainColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.layer.borderColor = MainColor.CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton new];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"重新选货" forState:UIControlStateNormal];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}

@end
