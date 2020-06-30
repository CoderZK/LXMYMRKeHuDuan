//
//  LxmYiRenZhengVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmYiRenZhengVC.h"

@interface LxmYiRenZhengVC ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LxmYiRenZhengHeaderView *headerView;

@end

@implementation LxmYiRenZhengVC

- (LxmYiRenZhengHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmYiRenZhengHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"bg_jianbian11"];
    }
    return _bgImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    [self initSubViews];
}

/**
 添加视图
 */
- (void)initSubViews {
    self.tableView.tableHeaderView = self.headerView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.tableView];
}

@end

@interface LxmYiRenZhengHeaderView ()

@property (nonatomic, strong) UIView *shaowView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImgView;//角色图标

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *textLabel;

@end
@implementation LxmYiRenZhengHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.shaowView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.stateLabel];
    [self.bgView addSubview:self.textLabel];
}

/**
 
 */
- (void)setConstrains {
    [self.shaowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 105));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 100));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(25);
        make.centerX.equalTo(self.bgView);
        make.width.height.equalTo(@60);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
        make.centerX.equalTo(self.bgView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.bgView);
    }];
}

- (UIView *)shaowView {
    if (!_shaowView) {
        _shaowView = [UIView new];
        _shaowView.backgroundColor = [UIColor whiteColor];
        _shaowView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _shaowView.layer.shadowRadius = 5;
        _shaowView.layer.shadowOpacity = 0.5;
        _shaowView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _shaowView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"shimingrenzheng"];
    }
    return _iconImgView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textColor = CharacterDarkColor;
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.text = @"已认证";
    }
    return _stateLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"您已通过实名认证";
    }
    return _textLabel;
}

@end
