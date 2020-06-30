//
//  LxmJiaoNaBaoZhengJinVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//
#import "LxmShengJiTiaoJianVC.h"
#import "LxmMyTeamVC.h"
#import "LxmJiaoNaBaoZhengJinVC.h"
#import "LxmWanShanInfoVC.h"
#import "LxmPayVC.h"

#import "LxmShengJiProtocolAlertView.h"

@interface LxmJiaoNaBaoZhengJinVC ()

@property (nonatomic, strong) LxmMyTeamNavView *navView;//导航栏

@property (nonatomic, strong) UIImageView *topView;//顶部背景

@property (nonatomic, strong) LxmJiaoNaBaoZhengJinHeaderView *headerView;

@end

@implementation LxmJiaoNaBaoZhengJinVC


- (UIImageView *)topView {
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        _topView.image = [UIImage imageNamed:@"bg_jianbian11"];
    }
    return _topView;
}

- (LxmJiaoNaBaoZhengJinHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmJiaoNaBaoZhengJinHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView.shengjiButton addTarget:self action:@selector(jiaoNaClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (LxmMyTeamNavView *)navView {
    if (!_navView) {
        _navView = [[LxmMyTeamNavView alloc] init];
        [_navView.leftButton setBackgroundImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
        [_navView.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_navView).offset(15);
            make.bottom.equalTo(_navView).offset(-8);
            make.width.equalTo(@40);
            make.height.equalTo(@30);
        }];
        _navView.backgroundColor = [UIColor whiteColor];
        _navView.titleLabel.textColor = CharacterDarkColor;
        _navView.titleLabel.text = @"缴纳保证金";
        [_navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _navView.rightButton.hidden = YES ;
    }
    return _navView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.topView];
    [self.view bringSubviewToFront:self.tableView];
    [self.view addSubview:self.navView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 165));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    self.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.model.deposit];
    self.headerView.detailTextView.text = self.model.depositMsg;
}

/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 缴纳保证金
 */
- (void)jiaoNaClick {
    
    LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_jiaobaozhengjin];
    vc.isBuJiao = self.isBuJiao;
    vc.recommend_code = self.recommend_code;
    vc.shengjiModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
//    if (self.model.depositUrl.isValid) {
//        LxmShengJiProtocolAlertView *alertView = [[LxmShengJiProtocolAlertView alloc] initWithFrame: UIScreen.mainScreen.bounds];
//        alertView.url = self.model.depositUrl;
//        alertView.titleLabel.text = @"保证金协议";
//        alertView.bottomButtonClickBlock = ^(NSInteger index) {
//            if (index == 300) {//取消
//
//            } else {//确定
//                LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_jiaobaozhengjin];
//                vc.isBuJiao = self.isBuJiao;
//                vc.shengjiModel = self.model;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        };
//        [alertView show];
//    } else {
//
//    }
}

@end

@implementation LxmJiaoNaBaoZhengJinHeaderView

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
    [self.bgView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.leftLineView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.rightLineView];
    [self.bgView addSubview:self.detailTextView];
    [self.bgView addSubview:self.shengjiButton];
}

/**
 
 */
- (void)setConstrains {
    [self.shaowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NavigationSpace + 25);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 55));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NavigationSpace + 20);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(TableViewBottomSpace + 50));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(25);
        make.centerX.equalTo(self.bgView);
        make.width.height.equalTo(@60);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
        make.centerX.equalTo(self.bgView);
        make.width.height.equalTo(@60);
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.titleLabel.mas_leading).offset(-5);
        make.centerY.equalTo(self.titleLabel);
        make.leading.equalTo(self.bgView).offset(30);
        make.height.equalTo(@1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self.bgView);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.bgView).offset(-30);
        make.height.equalTo(@1);
    }];
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.bgView).offset(15);
        make.trailing.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.shengjiButton.mas_top);
    }];
    [self.shengjiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(35);
        make.trailing.equalTo(self.bgView).offset(-35);
        make.bottom.equalTo(self.bgView).offset(-20);
        make.centerX.equalTo(self.bgView);
        make.height.equalTo(@44);
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
        _iconImgView.image = [UIImage imageNamed:@"jnbzj"];
    }
    return _iconImgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = MainColor;
        _moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _moneyLabel;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = BGGrayColor;
    }
    return _leftLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [UIView new];
        _rightLineView.backgroundColor = BGGrayColor;
    }
    return _rightLineView;
}

- (IQTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[IQTextView alloc] init];
        _detailTextView.textColor = CharacterDarkColor;
        _detailTextView.font = [UIFont systemFontOfSize:12];
        _detailTextView.userInteractionEnabled = NO;
    }
    return _detailTextView;
}

- (UIButton *)shengjiButton {
    if (!_shengjiButton) {
        _shengjiButton = [[UIButton alloc] init];
        [_shengjiButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_shengjiButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_shengjiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _shengjiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _shengjiButton.layer.cornerRadius = 22;
        _shengjiButton.layer.masksToBounds = YES;
    }
    return _shengjiButton;
}




@end
