//
//  LxmMyKefuAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyKefuAlertView.h"

@interface LxmMyKefuWechatButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//微信图标

@property (nonatomic, strong) UILabel *wechatLabel;//微信号

@end

@implementation LxmMyKefuWechatButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.wechatLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.wechatLabel.mas_leading).offset(-10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.trailing.lessThanOrEqualTo(self).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"kefuzhongxin"];
    }
    return _iconImgView;
}

- (UILabel *)wechatLabel {
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc] init];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"shilijjiiioikjkju" attributes:@{NSForegroundColorAttributeName: CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"     复制" attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
        [att appendAttributedString:str];
        _wechatLabel.font = [UIFont systemFontOfSize:15];
        _wechatLabel.attributedText = att;
    }
    return _wechatLabel;
}

@end



@interface LxmMyKefuAlertView ()

@property (nonatomic , strong) UIView * contentView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) LxmMyKefuWechatButton *fuzhiButton;//

@property (nonatomic, strong) UIButton *sureButton;//确定

@end

@implementation LxmMyKefuAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        //        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.bounds.size.height - 200) * 0.5, ScreenW - 60, 200)];
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
        _titleLabel.text = @"客服微信";
    }
    return _titleLabel;
}

- (LxmMyKefuWechatButton *)fuzhiButton {
    if (!_fuzhiButton) {
        _fuzhiButton = [[LxmMyKefuWechatButton alloc] init];
        [_fuzhiButton addTarget:self action:@selector(fuzhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fuzhiButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fuzhiButton];
    [self.contentView addSubview:self.sureButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    [self.fuzhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}

-(void)show {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.code ? self.code : @"" attributes:@{NSForegroundColorAttributeName: CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"     复制" attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [att appendAttributedString:str];
    _fuzhiButton.wechatLabel.attributedText = att;
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.transform = CGAffineTransformIdentity;
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

/**
 客服微信复制
 */
- (void)fuzhiButtonClick {
    [UIPasteboard.generalPasteboard setString:self.code];
    [SVProgressHUD showSuccessWithStatus:@"已复制到粘贴板"];
}

/**
 确定
 */
- (void)sureClick {
    [self dismiss];
}

@end
