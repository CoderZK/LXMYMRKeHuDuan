//
//  LxmSearchView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSearchView.h"
/**
 导航栏部分的搜索栏
 */
@interface LxmSearchView()

@property (nonatomic, strong) UIImageView *iconImgView;//搜索图标

@end
@implementation LxmSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgButton];
        [self.bgButton addSubview:self.iconImgView];
        [self.bgButton addSubview:self.searchTF];
        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgButton).offset(15);
            make.trailing.equalTo(self.iconImgView.mas_leading).offset(-5);
            make.top.bottom.equalTo(self.bgButton);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bgButton).offset(-15);
            make.centerY.equalTo(self.bgButton);
            make.width.height.equalTo(@14);
        }];
    }
    return self;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        _bgButton.backgroundColor = [UIColor whiteColor];
        _bgButton.layer.cornerRadius = 15;
        _bgButton.layer.masksToBounds = YES;
    }
    return _bgButton;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"ico_sousuo"];
    }
    return _iconImgView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.placeholder = @"搜索商品";
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.textColor = CharacterDarkColor;
        _searchTF.returnKeyType = UIReturnKeySearch;
    }
    return _searchTF;
}

@end


/**
 搜索页面搜索栏
 */
@interface LxmSearchPageView ()

@property (nonatomic, strong) UIImageView *iconImgView;//搜索图标

@end

@implementation LxmSearchPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.iconImgView];
        [self.bgView addSubview:self.searchTF];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView).offset(15);
            make.centerY.equalTo(self.bgView);
            make.width.height.equalTo(@14);
        }];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.trailing.equalTo(self.bgView).offset(-5);
            make.top.bottom.equalTo(self.bgView);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIButton alloc] init];
        _bgView.backgroundColor = BGGrayColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"ico_sousuo"];
    }
    return _iconImgView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.placeholder = @"请输入搜索内容";
        _searchTF.font = [UIFont systemFontOfSize:13];
        _searchTF.textColor = CharacterDarkColor;
        _searchTF.returnKeyType = UIReturnKeySearch;
    }
    return _searchTF;
}

@end

@implementation LxmTitleView

- (LxmSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LxmSearchView alloc] init];
        [_searchView.bgButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _searchView.searchTF.userInteractionEnabled = NO;
    }
    return _searchView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.leading.bottom.equalTo(self);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(ScreenW - 30, 30);
}

- (void)searchButtonClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

@end
