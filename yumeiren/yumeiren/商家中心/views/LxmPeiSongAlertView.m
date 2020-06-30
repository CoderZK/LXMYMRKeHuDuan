//
//  LxmPeiSongAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPeiSongAlertView.h"
#import "LxmPublishAlertView.h"

@interface LxmPeiSongAlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) LxmPublishAlertButton *kuaidiButton;//快递

@property (nonatomic, strong) LxmPublishAlertButton *zitiButton;//自提

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, assign) NSInteger index;

@end

@implementation LxmPeiSongAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.kuaidiButton];
        [self.contentView addSubview:self.zitiButton];
        [self setCornerRadius];
        [self setConstrains];
        [self.btnArr addObject:self.kuaidiButton];
        [self.btnArr addObject:self.zitiButton];
        self.index = 102;
    }
    return self;
}

/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 200 + TableViewBottomSpace)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"配送方式";
    }
    return _titleLabel;
}

- (LxmPublishAlertButton *)kuaidiButton {
    if (!_kuaidiButton) {
        _kuaidiButton = [[LxmPublishAlertButton alloc] init];
        if (LxmTool.ShareTool.userModel.postMoney.integerValue > 0) {
            _kuaidiButton.textLabel.text = [NSString stringWithFormat:@"快递(满%@元包邮或到付)",LxmTool.ShareTool.userModel.lowMoney];
        } else {
            _kuaidiButton.textLabel.text = @"物流发货";
        }
        _kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        [_kuaidiButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kuaidiButton;
}

- (LxmPublishAlertButton *)zitiButton {
    if (!_zitiButton) {
        _zitiButton = [[LxmPublishAlertButton alloc] init];
        _zitiButton.textLabel.text = @"自提";
        _zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        [_zitiButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zitiButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, TableViewBottomSpace)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
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
    [self.kuaidiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(70);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    [self.zitiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kuaidiButton.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@(TableViewBottomSpace));
    }];
}

- (void)show {
    self.backgroundColor = UIColor.clearColor;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, 200 + TableViewBottomSpace);
    [_contentView layoutIfNeeded];
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - (200 + TableViewBottomSpace), ScreenW, 200 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    WeakObj(self);
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, 200 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

- (void)bgButtonClick {
    [self dismiss];
}

- (void)btnClick:(LxmPublishAlertButton *)btn {
    for (LxmPublishAlertButton *btnn in self.btnArr) {
        btnn.selected = btnn == btn;
    }
    if (self.kuaidiButton.selected) {
        self.index = 100;
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    } else if (self.zitiButton.selected){
        self.index = 101;
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    } else {
        self.index = 102;
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
    if (self.selectTypeBlock) {
        self.selectTypeBlock(self.index);
    }
    [self dismiss];
}

- (void)setIndex1:(NSInteger)index1 {
    _index1 = index1;
    if (_index1 == 100) {
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    } else if (_index1 == 101) {
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_y"];
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    } else {
        self.zitiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        self.kuaidiButton.imgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
}

@end
