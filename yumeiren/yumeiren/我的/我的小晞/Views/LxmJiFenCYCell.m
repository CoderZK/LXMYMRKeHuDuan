//
//  LxmJiFenCYCell.m
//  yumeiren
//
//  Created by zk on 2020/7/7.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenCYCell.h"

@implementation LxmJiFenCYCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.numLabel];
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.rankLabel];
    [self addSubview:self.codeLabel];
//    [self addSubview:self.recordButton];
//    [self addSubview:self.recordLabel];
    [self addSubview:self.accImgView];
    [self addSubview:self.memberNumLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@10);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(40);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.top.equalTo(self.headerImgView).offset(8);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(3);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@13);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.trailing.lessThanOrEqualTo(self).offset(-20);
        make.height.equalTo(@17);
    }];
    
//    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.height.equalTo(self.codeLabel);
//        make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
//    }];
    
//    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.nameLabel);
//        make.top.trailing.equalTo(self);
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
//    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
//        make.bottom.equalTo(self.recordButton);
//    }];
    
    [self.memberNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeLabel);
        make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.textColor = CharacterDarkColor;
        _numLabel.text = @"本月业绩: 99000";
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.userInteractionEnabled = YES;
        _headerImgView.image = [UIImage imageNamed:@"bg_hongbao3"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
        [_headerImgView addGestureRecognizer:tap];
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.text = @"果子";
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.font = [UIFont systemFontOfSize:10];
        _rankLabel.textColor = MainColor;
        _rankLabel.layer.cornerRadius = 3;
        _rankLabel.layer.borderWidth = 0.5;
        _rankLabel.text = @" 董事 ";
        _rankLabel.layer.borderColor = MainColor.CGColor;
    }
    return _rankLabel;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        [_recordButton addTarget:self action:@selector(seeKuCunClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.font = [UIFont systemFontOfSize:13];
        _recordLabel.textColor = CharacterGrayColor;
        _recordLabel.text = @"查看库存";
    }
    return _recordLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = [UIFont systemFontOfSize:13];
        _codeLabel.textColor = CharacterGrayColor;
    }
    return _codeLabel;
}

- (UILabel *)memberNumLabel {
    if (!_memberNumLabel) {
        _memberNumLabel = [[UILabel alloc] init];
        _memberNumLabel.font = [UIFont systemFontOfSize:12];
        _memberNumLabel.textColor = CharacterGrayColor;
    }
    return _memberNumLabel;
}

/**
 查看库存
 */
- (void)seeKuCunClick {
    
}

/**
 查看他人信息
 */
- (void)headerTap {
   
}

- (void)setIndex:(NSInteger)index {
    if (index == 0) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"1"];
        self.numLabel.hidden = YES;
    } else if (index == 1) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"2"];
        self.numLabel.hidden = YES;
    } else if (index == 2) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"3"];
        self.numLabel.hidden = YES;
    } else {
        self.iconImgView.hidden = YES;
        self.numLabel.hidden = NO;
        self.numLabel.text = @(index + 1).stringValue;
    }
}

- (void)setModel:(LxmMyTeamListModel *)model {
    _model = model;
    self.nameLabel.text = _model.username;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.user_head] placeholderImage:[UIImage imageNamed:@"moren"]];
    if ([_model.role_type isEqualToString:@"-0.5"]){
        self.rankLabel.text = @" 减肥单项-vip会员 ";
    } else if ([_model.role_type isEqualToString:@"-0.4"]) {
        self.rankLabel.text = @" 减肥单项-高级会员 ";
    } else if ([_model.role_type isEqualToString:@"-0.3"]) {
        self.rankLabel.text = @" 减肥单项-荣誉会员 ";
    } else if ([_model.role_type isEqualToString:@"1.1"]) {
        self.rankLabel.text = @" 减肥单项-总经理 ";
    } else if ([_model.role_type isEqualToString:@"2.1"]) {
        self.rankLabel.text = @" 减肥单项-董事 ";
    } else if ([_model.role_type isEqualToString:@"3.1"]) {
        self.rankLabel.text = @" 减肥单项-CEO ";
    }  else {
        switch (_model.role_type.intValue) {
            case -1:
                self.rankLabel.text = @" 无身份 ";
                break;
            case 0:
                self.rankLabel.text = @" 无身份 ";
                break;
            case 1:
                self.rankLabel.text = @" 经理 ";
                break;
            case 2:
                self.rankLabel.text = @" 总经理 ";
                break;
            case 3:
                self.rankLabel.text = @" 董事 ";
                break;
            case 4:
                self.rankLabel.text = @" CEO ";
                break;
                
            default:
                break;
        }
    }
    
    self.codeLabel.text = [NSString stringWithFormat:@"剩余小晞: %@",[_model.group_score getPriceStr]];
    self.memberNumLabel.text = [NSString stringWithFormat:@"本月业绩: ￥%@",_model.one_base_in_money];
}



@end
