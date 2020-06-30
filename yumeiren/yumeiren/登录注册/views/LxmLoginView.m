//
//  LxmLoginView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmLoginView.h"

@implementation LxmLoginView

@end

@implementation LxmTextAndPutinTFView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@80);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing);
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:15];
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmAgreeButton()

@property (nonatomic, strong) UILabel *textLabel;

@end
@implementation LxmAgreeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.selectButton];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.bottom.top.equalTo(self);
            make.centerY.equalTo(self);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton new];
        _selectButton.hidden = YES;
    }
    return _selectButton;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意" attributes:@{NSForegroundColorAttributeName: CharacterGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《协议》" attributes:@{NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        _textLabel.attributedText = att;
    }
    return _textLabel;
}

@end
