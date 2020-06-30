//
//  LxmUserInfoView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmUserInfoView.h"
#import "LxmUserInfoView.h"

@implementation LxmUserInfoView



@end

/**
 头像
 */
@implementation LxmUserHeaderImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImgView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.width.height.equalTo(@80);
        }];
        [self addLine];
    }
    return self;
}

- (void)addLine {
    UIView *line = [UIView new];
    line.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.text = @"头像";
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutPriorityRequired];
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.layer.cornerRadius = 40;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

@end


/**
 微信号 手机号 复制
 */
@implementation LxmUserCodeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.titleLabel];
//        [self addSubview:self.pasteButton];
        [self addSubview:self.detailLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
        }];
//        [self.pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self.detailLabel.mas_leading).offset(-15);
//            make.centerY.equalTo(self);
//            make.height.equalTo(@25);
//        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self addLine];
    }
    return self;
}

- (void)addLine {
    UIView *line = [UIView new];
    line.backgroundColor = BGGrayColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterGrayColor;
    }
    return _titleLabel;
}


//- (UIButton *)pasteButton {
//    if (!_pasteButton) {
//        _pasteButton = [[UIButton alloc] init];
//        [_pasteButton setTitle:@"  复制  " forState:UIControlStateNormal];
//        _pasteButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_pasteButton setTitleColor:LineColor forState:UIControlStateNormal];
//        _pasteButton.layer.cornerRadius = 2;
//        _pasteButton.layer.borderColor = [LineColor colorWithAlphaComponent:0.3].CGColor;
//        _pasteButton.layer.masksToBounds = YES;
//        _pasteButton.layer.borderWidth = 0.5;
//    }
//    return _pasteButton;
//}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

@end
