//
//  LxmPublishAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPublishAlertView.h"

@implementation LxmPublishAlertButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [self addSubview:self.textLabel];
        [self addSubview:self.imgView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self);
            make.height.equalTo(@1);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(20);
            make.centerY.equalTo(self);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterDarkColor;
    }
    return _textLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end



@interface LxmPublishAlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UIButton *finishButton;//完成

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) LxmPublishAlertButton *tuwenButton;//图文

@property (nonatomic, strong) LxmPublishAlertButton *shipinButton;//视频

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, assign) NSInteger index;//110图文 111视频

@end

@implementation LxmPublishAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.finishButton];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tuwenButton];
        [self.contentView addSubview:self.shipinButton];
        [self setCornerRadius];
        [self setConstrains];
        [self.btnArr addObject:self.tuwenButton];
        [self.btnArr addObject:self.shipinButton];
        self.index = 110;
    }
    return self;
}
/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"发布类型";
    }
    return _titleLabel;
}

- (LxmPublishAlertButton *)tuwenButton {
    if (!_tuwenButton) {
        _tuwenButton = [[LxmPublishAlertButton alloc] init];
        _tuwenButton.textLabel.text = @"图文";
        _tuwenButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        [_tuwenButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _tuwenButton.selected = YES;
    }
    return _tuwenButton;
}

- (LxmPublishAlertButton *)shipinButton {
    if (!_shipinButton) {
        _shipinButton = [[LxmPublishAlertButton alloc] init];
        _shipinButton.textLabel.text = @"视频";
        _shipinButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        [_shipinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shipinButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, TableViewBottomSpace)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.layer.cornerRadius = 5;
        _finishButton.layer.masksToBounds = YES;
    }
    return _finishButton;
}

/**
 设置圆角
 */
- (void)setCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.centerX.equalTo(self.contentView);
    }];
    [self.tuwenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(70);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    [self.shipinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tuwenButton.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@(TableViewBottomSpace));
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-TableViewBottomSpace-20);
        make.height.equalTo(@50);
    }];
}

- (void)show {
    self.backgroundColor = UIColor.clearColor;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace);
    [_contentView layoutIfNeeded];
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - (270 + TableViewBottomSpace), ScreenW, 270 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    WeakObj(self);
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

- (void)bgButtonClick {
    WeakObj(self);
    if (self.publishTypeBlock) {
        self.publishTypeBlock(selfWeak.index);
    }
    [self dismiss];
}

- (void)btnClick:(LxmPublishAlertButton *)btn {
    for (LxmPublishAlertButton *btnn in self.btnArr) {
        btnn.selected = btnn == btn;
    }
    if (self.shipinButton.selected) {
        self.index = 111;
        self.shipinButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        self.tuwenButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    } else if (self.tuwenButton.selected) {
        self.index = 110;
        self.shipinButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        self.tuwenButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
    } 
}

@end
