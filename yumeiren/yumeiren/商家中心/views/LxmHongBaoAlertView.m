//
//  LxmHongBaoAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHongBaoAlertView.h"
#import "LxmMyHongBaoVC.h"

@interface LxmHongBaoAlertView ()

@property (nonatomic, strong) UIButton * bgBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *chaiButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIButton *gotoSeeButton;//领到红包 去看看

@end

@implementation LxmHongBaoAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self.bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.bgBtn];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self.bgBtn addSubview:self.contentView];
        
        [self initContentSubviews];
        [self setConstrains:NO money:@"0"];
    }
    return self;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.imgView];
    [self.imgView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.gotoSeeButton];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.chaiButton];
}

/**
 添加约束
 */
- (void)setConstrains:(BOOL)ischai money:(NSString *)money {
    CGFloat h = (ScreenW - 80)*735/569;
    if (ischai) {
        self.chaiButton.hidden = YES;
        self.moneyLabel.hidden = NO;
        self.gotoSeeButton.hidden = NO;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:money ? money : @"0" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35]}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:30]}];
        [att appendAttributedString:str];
        self.moneyLabel.attributedText = att;
        h = (ScreenW - 80)*370/301;
        _imgView.image = [UIImage imageNamed:@"bg_hongbao2"];
    } else {
        self.chaiButton.hidden = NO;
        self.moneyLabel.hidden = YES;
        self.gotoSeeButton.hidden = YES;
        h = (ScreenW - 80)*735/569;
        _imgView.image = [UIImage imageNamed:@"bg_hongbao3"];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgBtn);
        make.width.equalTo(@(ScreenW - 80));
        make.height.equalTo(@(h + 80));
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(ScreenW - 80));
        make.height.equalTo(@(h));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@40);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-20);
        make.centerX.equalTo(self.contentView);
    }];
    [self.gotoSeeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.imgView);
    }];
    [self.chaiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.imgView);
    }];
    [self.contentView layoutIfNeeded];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = UIColor.blackColor;
    }
    return _moneyLabel;
}

- (UIButton *)chaiButton {
    if (!_chaiButton) {
        _chaiButton = [UIButton new];
        [_chaiButton addTarget:self action:@selector(chaiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chaiButton;
}

- (UIButton *)gotoSeeButton {
    if (!_gotoSeeButton) {
        _gotoSeeButton = [UIButton new];
        [_gotoSeeButton addTarget:self action:@selector(seeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoSeeButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
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

- (void)chaiClick {
    if (self.chaiHongBaoBlock) {
        self.chaiHongBaoBlock(self);
    }
}

/**
 去红包看看
 */
- (void)seeButtonClick {
    [self dismiss];
    LxmMyHongBaoVC *vc = [[LxmMyHongBaoVC alloc] init];
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}

@end
