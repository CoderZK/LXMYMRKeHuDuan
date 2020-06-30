//
//  LxmGouJinGoodsVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmGouJinGoodsVC.h"

@interface LxmGouJinGoodsButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *textLabel;//文字

@end

@implementation LxmGouJinGoodsButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@80);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:16];
    }
    return _textLabel;
}

@end

#import "LxmShopVC.h"
#import "LxmBuHuoOrderVC.h"

@interface LxmGouJinGoodsVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmGouJinGoodsButton *goujinButton;//购进商品

@property (nonatomic, strong) LxmGouJinGoodsButton *buhuoOrderButton;//补货订单

@end

@implementation LxmGouJinGoodsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmGouJinGoodsButton *)goujinButton {
    if (!_goujinButton) {
        _goujinButton = [[LxmGouJinGoodsButton alloc] init];
        _goujinButton.iconImgView.image = [UIImage imageNamed:@"goujinshangpin_b"];
        _goujinButton.textLabel.text = @"购进商品";
        [_goujinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goujinButton;
}

- (LxmGouJinGoodsButton *)buhuoOrderButton {
    if (!_buhuoOrderButton) {
        _buhuoOrderButton = [[LxmGouJinGoodsButton alloc] init];
        _buhuoOrderButton.iconImgView.image = [UIImage imageNamed:@"bhdd"];
        _buhuoOrderButton.textLabel.text = @"补货订单";
        [_buhuoOrderButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buhuoOrderButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购进商品";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
}

- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.view addSubview:self.goujinButton];
    [self.view addSubview:self.buhuoOrderButton];
    [self.goujinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-10);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@130);
    }];
    [self.buhuoOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(10);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@130);

    }];
}

- (void)btnClick:(LxmGouJinGoodsButton *)btn {
    if (btn == _goujinButton) {//购进商品
        LxmShopVC *vc = [[LxmShopVC alloc] init];
        vc.isDeep = YES;
        vc.isGotoGouwuChe = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//补货订单
        LxmBuHuoOrderVC *vc = [[LxmBuHuoOrderVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
