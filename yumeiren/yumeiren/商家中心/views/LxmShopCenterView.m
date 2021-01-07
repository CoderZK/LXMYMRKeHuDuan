//
//  LxmShopCenterView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCenterView.h"

@implementation LxmShopCenterView

@end

@interface LxmShopCenterTopView ()

@property (nonatomic, strong) UILabel *roleLabel;

@end

@implementation LxmShopCenterTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstarins];
    }
    return self;
}

/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.headerImgView];
    [self addSubview:self.sexImgView];
    [self addSubview:self.roleButton];
    [self.roleButton addSubview:self.roleLabel];
}

/**
 设置约束
 */
- (void)setConstarins {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self.headerImgView.mas_leading).offset(-5);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self.headerImgView.mas_leading).offset(-5);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-20);
       make.top.equalTo(self).offset(25);
        make.width.height.equalTo(@60);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-18);
        make.bottom.equalTo(self.headerImgView).offset(-10);
        make.width.height.equalTo(@15);
    }];
    [self.roleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(20);
//        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    [self.roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.roleButton);
        make.height.equalTo(@24);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = CharacterLightGrayColor;
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)roleLabel {
    if (!_roleLabel) {
        _roleLabel = [UILabel new];
        _roleLabel.font = [UIFont systemFontOfSize:14];
        _roleLabel.textColor = MainColor;
        _roleLabel.layer.cornerRadius = 12;
        _roleLabel.layer.borderColor = MainColor.CGColor;
        _roleLabel.layer.borderWidth = 0.5;
        _roleLabel.layer.masksToBounds = YES;
    }
    return _roleLabel;
}

- (UIImageView *)sexImgView {
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
    }
    return _sexImgView;
}

- (UIButton *)roleButton {
    if (!_roleButton) {
        _roleButton = [[UIButton alloc] init];
        [_roleButton setTitleColor:MainColor forState:UIControlStateNormal];
        _roleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_roleButton addTarget:self action:@selector(likeShengjiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roleButton;
}


/**
 赋值
 */
- (void)setInfoModel:(LxmUserInfoModel *)infoModel {
    _infoModel = infoModel;
    
    _nameLabel.text = _infoModel.username;
    if (_infoModel.recoCode.isValid) {
       _detailLabel.text = [NSString stringWithFormat:@"手机号: %@  授权码:%@",_infoModel.telephone,_infoModel.recoCode];
    } else {
        _detailLabel.text = [NSString stringWithFormat:@"手机号: %@",_infoModel.telephone];
    }
    
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_infoModel.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    switch (_infoModel.sex.intValue) {
        case 0:
            _sexImgView.image = [UIImage imageNamed:@"sex_unknow"];
            break;
        case 1:
            _sexImgView.image = [UIImage imageNamed:@"nan"];
            break;
        case 2:
            _sexImgView.image = [UIImage imageNamed:@"nv"];
            break;
            
        default:
            break;
    }
    if ([_infoModel.roleType isEqualToString:@"-0.5"]) {
        _roleLabel.text = @"   小红包系列-vip会员   ";
    } else if ([_infoModel.roleType isEqualToString:@"-0.4"]) {
        _roleLabel.text = @"   小红包系列-高级会员   ";
    } else if ([_infoModel.roleType isEqualToString:@"-0.3"]) {
        _roleLabel.text = @"   小红包系列-荣誉会员   ";
    } else if ([_infoModel.roleType isEqualToString:@"1.1"]) {
           _roleLabel.text = @"   小红包系列-市服务商   ";
    } else if ([_infoModel.roleType isEqualToString:@"2.1"]) {
           _roleLabel.text = @"   小红包系列-省服务商   ";
    } else if ([_infoModel.roleType isEqualToString:@"3.1"]) {
           _roleLabel.text = @"   小红包系列-CEO   ";
    }else if ([_infoModel.roleType isEqualToString:@"1.05"]) {
     
        
        NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
            
            //NSTextAttachment可以将要插入的图片作为特殊字符处理
            NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            messageAttach.image = [UIImage imageNamed:@"ss"];
            messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
            //创建带有图片的富文本
            NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
   //         [messageStr appendAttributedString:messageImageStr];
            
            //富文本中的文字
           NSString *messageText = @"   优秀门店   ";
        
        if (infoModel.suType.intValue == 1) {
            NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
            [messageStr appendAttributedString:messageTextStr];
        
            if (messageStr.length >= 2) {
                [messageStr insertAttributedString:messageImageStr atIndex:2];
            }else {
                [messageStr insertAttributedString:messageImageStr atIndex:0];
            }
            _roleLabel.attributedText = messageStr;
        }else {
            _roleLabel.text = messageText;
        }
        
 } else {
     
            
     NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
         
         //NSTextAttachment可以将要插入的图片作为特殊字符处理
         NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
         //定义图片内容及位置和大小
         messageAttach.image = [UIImage imageNamed:@"ss"];
         messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
         //创建带有图片的富文本
         NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
//         [messageStr appendAttributedString:messageImageStr];
         
         //富文本中的文字
        NSString *messageText = @"  ";
        switch (_infoModel.roleType.intValue) {
            case -1: {
                messageText = @"    立刻升级   ";
            }
                break;
            case 0: {
                messageText = @"   vip门店   ";
            }
                break;
            case 1: {
                messageText = @"   高级门店   ";
            }
                break;
            case 2: {
                messageText = @"   市服务商   ";
            }
                break;
            case 3: {
                if ([LxmTool ShareTool].userModel.topStatus.intValue == 1) {
                    messageText = @"   联合创始人   ";
                }else {
                    messageText = @"   省服务商   ";
                }

            }
                break;
            case 4: {
                messageText = @"   CEO   ";
            }
                break;
            
            case 5: {
                messageText = @"   总经销商   ";
            }
                break;

            default:
                break;
        }
    
     if (infoModel.suType.intValue == 1) {
         NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
         [messageStr appendAttributedString:messageTextStr];
     
         if (messageStr.length >= 2) {
             [messageStr insertAttributedString:messageImageStr atIndex:2];
         }else {
             [messageStr insertAttributedString:messageImageStr atIndex:0];
         }
         _roleLabel.attributedText = messageStr;
     }else {
         _roleLabel.text = messageText;
     }
     
    }
}

/**
 商家个人中心
 */
- (void)setShopInfoModel:(LxmShopCenterUserInfoModel *)shopInfoModel {
    _shopInfoModel = shopInfoModel;
    _roleButton.userInteractionEnabled = NO;
    _nameLabel.text = _shopInfoModel.username;
    if (_shopInfoModel.recoCode.isValid) {
       _detailLabel.text = [NSString stringWithFormat:@"手机号: %@  授权码:%@",_shopInfoModel.telephone,_shopInfoModel.recoCode];
    } else {
        _detailLabel.text = [NSString stringWithFormat:@"手机号: %@",_shopInfoModel.telephone];
    }
    
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_shopInfoModel.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    switch (_shopInfoModel.sex.intValue) {
        case 0:
            _sexImgView.image = [UIImage imageNamed:@"sex_unknow"];
            break;
        case 1:
            _sexImgView.image = [UIImage imageNamed:@"nan"];
            break;
        case 2:
            _sexImgView.image = [UIImage imageNamed:@"nv"];
            break;
            
        default:
            break;
    }
    
    if ([_shopInfoModel.roleType isEqualToString:@"-0.5"]) {
        _roleLabel.text = @"   小红包系列-vip会员   ";
    } else if ([_shopInfoModel.roleType isEqualToString:@"-0.4"]) {
        _roleLabel.text = @"   小红包系列-高级会员   ";
    } else if ([_shopInfoModel.roleType isEqualToString:@"-0.3"]) {
        _roleLabel.text = @"   小红包系列-荣誉会员   ";
    } else if ([_shopInfoModel.roleType isEqualToString:@"1.1"]) {
        _roleLabel.text = @"   小红包系列-市服务商   ";
    } else if ([_shopInfoModel.roleType isEqualToString:@"2.1"]) {
        _roleLabel.text = @"   小红包系列-省服务商   ";
    } else if ([_shopInfoModel.roleType isEqualToString:@"3.1"]) {
        _roleLabel.text = @"   小红包系列-CEO   ";
    }else if ([_shopInfoModel.roleType isEqualToString:@"1.05"]) {
//        _roleLabel.text = @"   优秀门店   ";
        
        NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
            
            //NSTextAttachment可以将要插入的图片作为特殊字符处理
            NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            messageAttach.image = [UIImage imageNamed:@"ss"];
            messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
            //创建带有图片的富文本
            NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
   //         [messageStr appendAttributedString:messageImageStr];
            
            //富文本中的文字
           NSString *messageText = @"   优秀门店   ";
        
        if (_shopInfoModel.suType.intValue == 1) {
            NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
            [messageStr appendAttributedString:messageTextStr];
            if (messageStr.length >= 2) {
                [messageStr insertAttributedString:messageImageStr atIndex:2];
            }else {
                [messageStr insertAttributedString:messageImageStr atIndex:0];
            }
            
            _roleLabel.attributedText = messageStr;
        }else {
            _roleLabel.text = messageText;
        }
        
    } else {
        
        NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
            
            //NSTextAttachment可以将要插入的图片作为特殊字符处理
            NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            messageAttach.image = [UIImage imageNamed:@"ss"];
            messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
            //创建带有图片的富文本
            NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
           
            
          
        
        //富文本中的文字
       NSString *messageText = @"";
       switch (shopInfoModel.roleType.intValue) {
           case -1: {
               messageText = @"    立刻升级   ";
           }
               break;
           case 0: {
               messageText = @"   vip门店   ";
           }
               break;
           case 1: {
               messageText = @"   高级门店   ";
           }
               break;
           case 2: {
               messageText = @"   市服务商   ";
           }
               break;
           case 3: {
               if ([LxmTool ShareTool].userModel.topStatus.intValue == 1) {
                   messageText = @"   联合创始人   ";
               }else {
                   messageText = @"   省服务商   ";
               }

           }
               break;
           case 4: {
               messageText = @"   CEO   ";
           }
               break;
           case 5: {
               messageText = @"   总经销商   ";
           }
               break;
           default:
               break;
       }
   
    if (shopInfoModel.suType.intValue == 1) {
        NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
        [messageStr appendAttributedString:messageTextStr];
    
        if (messageStr.length >= 2) {
            [messageStr insertAttributedString:messageImageStr atIndex:2];
        }else {
            [messageStr insertAttributedString:messageImageStr atIndex:0];
        }
        _roleLabel.attributedText = messageStr;
    }else {
        _roleLabel.text = messageText;
    }
    }
}

/**
 立刻升级
 */
- (void)likeShengjiClick {
    if (self.likeshengjiBlock) {
        self.likeshengjiBlock();
    }
}

@end

/**
 当前考核季度
 */
@interface LxmShopCenterMonthView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgView;//月季的背景

@property (nonatomic, strong) UIButton *yueButton;

@property (nonatomic, strong) UIButton *leftButton;//月

@property (nonatomic, strong) UIButton *rightButton;//季

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmShopCenterUserInfoModel *shopInfoModel;/* 商家个人中心 */

@property (nonatomic, strong) NSMutableArray <LxmShopCenterUserListModel *>*dataArr;

@property (nonatomic, copy) void(^yueAndMonthButtonClick)(NSInteger index);

@end

@implementation LxmShopCenterMonthView

- (instancetype)initWithFrame:(CGRect)frame {
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
    [self addSubview:self.titleLabel];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.leftButton];
    [self.bgView addSubview:self.rightButton];
    [self addSubview:self.yueButton];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@64);
        make.height.equalTo(@20);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.bgView);
        make.width.equalTo(@32);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.bgView);
        make.width.equalTo(@32);
    }];
    [self.yueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@32);
        make.height.equalTo(@20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"当前考核季度为04-06月";
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = [LineColor colorWithAlphaComponent:0.5].CGColor;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

-(UIButton *)yueButton {
    if (!_yueButton) {
        _yueButton = [[UIButton alloc] init];
        [_yueButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_yueButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateNormal];
        [_yueButton setTitle:@"月" forState:UIControlStateNormal];
        _yueButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _yueButton.layer.cornerRadius = 10;
        _yueButton.layer.borderWidth = 0.5;
        _yueButton.layer.borderColor = BGGrayColor.CGColor;
        _yueButton.layer.masksToBounds = YES;
    }
    return _yueButton;
}

-(UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_leftButton setTitle:@"月" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.selected = YES;
        _leftButton.tag = 443;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_rightButton setTitle:@"季" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 444;
    }
    return _rightButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
    }
    return _lineView;
}

- (void)buttonClick: (UIButton *)btn {
    btn.selected = YES;
    if (btn == _leftButton) {
        _rightButton.selected = !btn.selected;
        if (btn.selected) {
            for (LxmShopCenterUserListModel *model in _dataArr) {
                if (model.infoType.intValue == 1) {//月
                    _titleLabel.text = [NSString stringWithFormat:@"当前考核月为%@月",model.inMonth];
                }
            }
        }
    } else {
        _leftButton.selected = !btn.selected;
        if (btn.selected) {
            for (LxmShopCenterUserListModel *model in _dataArr) {
                if (model.infoType.intValue == 2) {//季
                    _titleLabel.text = [NSString stringWithFormat:@"当前考核季度为%@-%@月",model.fromMonth,model.endMonth];
                }
            }
        }
    }
    if (self.yueAndMonthButtonClick) {
        self.yueAndMonthButtonClick(btn.tag);
    }
}

- (void)setShopInfoModel:(LxmShopCenterUserInfoModel *)shopInfoModel {
    _shopInfoModel = shopInfoModel;
    //CEO、省代有月和季度考核；市代是月度考核
    if ([_shopInfoModel.roleType isEqualToString:@"3"] || [_shopInfoModel.roleType isEqualToString:@"4"]|| [_shopInfoModel.roleType isEqualToString:@"5"] || [_shopInfoModel.roleType isEqualToString:@"2.1"]  || [_shopInfoModel.roleType isEqualToString:@"3.1"] ) {
        _bgView.hidden = _leftButton.hidden = _rightButton.hidden = NO;
        _yueButton.hidden = YES;
    } else if ([_shopInfoModel.roleType isEqualToString:@"2"] || [_shopInfoModel.roleType isEqualToString:@"1.1"] ) {
        _bgView.hidden = _leftButton.hidden = _rightButton.hidden = YES;
        _yueButton.hidden = NO;
    }
}

- (void)setDataArr:(NSMutableArray<LxmShopCenterUserListModel *> *)dataArr {
    _dataArr = dataArr;
    for (LxmShopCenterUserListModel *model in _dataArr) {
        if (model.infoType.intValue == 1) {//月
            _titleLabel.text = [NSString stringWithFormat:@"当前考核月为%@月",model.inMonth];
        }
    }
}


@end

/**
 当季完成 当季目标
 */
@interface LxmShopCenterButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *numLabel;

@end
@implementation LxmShopCenterButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.numLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-3);
            make.centerX.equalTo(self);
        }];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(3);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = CharacterGrayColor;
    }
    return _textLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont boldSystemFontOfSize:20];
        _numLabel.textColor = MainColor;
    }
    return _numLabel;
}

@end


@interface LxmShopCenterKaoHeCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *shadowBgView;

@property (nonatomic, strong) LxmShopCenterMonthView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) LxmShopCenterButton *leftButton;//当季完成

@property (nonatomic, strong) LxmShopCenterButton *rightButton;//当季目标

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmShopCenterKaoHeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.shadowBgView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.bgView addSubview:self.bottomView];
    [self.bottomView addSubview:self.leftButton];
    [self.bottomView addSubview:self.rightButton];
    self.leftButton.userInteractionEnabled = self.rightButton.userInteractionEnabled = NO;
    [self.bottomView addSubview:self.lineView];
}

- (void)setConstrains {
    [self.shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(18);
        make.trailing.equalTo(self).offset(-18);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-2);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bgView);
        make.height.equalTo(@44);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.bgView);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.bottomView);
        make.trailing.equalTo(self.lineView.mas_leading);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(@0.5);
        make.top.equalTo(self.bottomView).offset(25);
        make.bottom.equalTo(self.bottomView).offset(-25);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.bottomView);
        make.leading.equalTo(self.lineView.mas_trailing);
    }];
}

- (UIView *)shadowBgView {
    if (!_shadowBgView) {
        _shadowBgView = [[UIView alloc] init];
        _shadowBgView.backgroundColor = [UIColor whiteColor];
        _shadowBgView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _shadowBgView.layer.shadowRadius = 5;
        _shadowBgView.layer.shadowOpacity = 0.5;
        _shadowBgView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _shadowBgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (LxmShopCenterMonthView *)topView {
    if (!_topView) {
        _topView = [[LxmShopCenterMonthView alloc] init];
        WeakObj(self);
        _topView.yueAndMonthButtonClick = ^(NSInteger index) {
            [selfWeak yueAndMonthButtonIndex:index];
        };
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (LxmShopCenterButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[LxmShopCenterButton alloc] init];
        _leftButton.textLabel.text = @"当季完成(元)";
        _leftButton.numLabel.text = @"0";
    }
    return _leftButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
    }
    return _lineView;
}

- (LxmShopCenterButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[LxmShopCenterButton alloc] init];
        _rightButton.textLabel.text = @"当季目标(元)";
        _rightButton.numLabel.text = @"0";
    }
    return _rightButton;
}

- (void)yueAndMonthButtonIndex:(NSInteger)index {
    if (index == 443) {//月
        for (LxmShopCenterUserListModel *model in _dataArr) {
            if (model.infoType.intValue == 1) {//月度
                _leftButton.textLabel.text = @"当月完成(元)";
                _leftButton.numLabel.text = model.finishMoney;
                _rightButton.textLabel.text = @"当月目标(元)";
                _rightButton.numLabel.text = model.targetMoney;
            }
        }
    } else {//季
        for (LxmShopCenterUserListModel *model in _dataArr) {
            if (model.infoType.intValue == 2) {//季度
                _leftButton.textLabel.text = @"当季完成(元)";
                _leftButton.numLabel.text = model.finishMoney;
                _rightButton.textLabel.text = @"当季目标(元)";
                _rightButton.numLabel.text = model.targetMoney;
            }
        }
    }
}

- (void)setShopInfoModel:(LxmShopCenterUserInfoModel *)shopInfoModel {
    _shopInfoModel = shopInfoModel;
    if ([self.shopInfoModel.roleType isEqualToString:@"-1"] || [self.shopInfoModel.roleType isEqualToString:@"0"] || [self.shopInfoModel.roleType isEqualToString:@"1"] || [self.shopInfoModel.roleType isEqualToString:@"-0.5"] || [self.shopInfoModel.roleType isEqualToString:@"-0.4"] || [self.shopInfoModel.roleType isEqualToString:@"-0.3"] || [self.shopInfoModel.roleType isEqualToString:@"1.05"]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        _topView.shopInfoModel = _shopInfoModel;
    }
}

- (void)setDataArr:(NSMutableArray<LxmShopCenterUserListModel *> *)dataArr {
    _dataArr = dataArr;
    _topView.dataArr = _dataArr;
    if (_dataArr.count == 1) {
        LxmShopCenterUserListModel *model = _dataArr.firstObject;
        _leftButton.textLabel.text = @"当月完成(元)";
        _leftButton.numLabel.text = model.finishMoney;
        _rightButton.textLabel.text = @"当月目标(元)";
        _rightButton.numLabel.text = model.targetMoney;
    } else if (_dataArr.count == 2) {
        for (LxmShopCenterUserListModel *model in _dataArr) {
            if (model.infoType.intValue == 1) {//月度
                _leftButton.textLabel.text = @"当月完成(元)";
                _leftButton.numLabel.text = model.finishMoney;
                _rightButton.textLabel.text = @"当月目标(元)";
                _rightButton.numLabel.text = model.targetMoney;
            }
        }
    }
}

@end

#import "LxmHomeView.h"
@interface LxmShopCenterItemCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *shadowBgView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *titleArr;//标题数组

@property (nonatomic, strong) NSArray <NSString *>*iconArr;




@end
@implementation LxmShopCenterItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
        self.titleArr = @[
                          @"我的店铺",
                          @"购进商品",
                          @"订单查询",
                          @"我的团队",
                          @"我的业绩",
                          @"我要升级",
                          @"消息通知"
                          ];
        self.iconArr = @[
                         @"wddp",
                         @"goujinshangpin",
                         @"dingdanchaxun",
                         @"wodetuandui",
                         @"wodeyeji",
                         @"woyaoshengji",
                         @"xiaoxitongzhi"
                         ];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.shadowBgView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake((ScreenW - 50)/3.0, 80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 80*ceil(7/3.0) + 30) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:LxmHomeButtonItem.class forCellWithReuseIdentifier:@"LxmHomeButtonItem"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeButtonItem *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeButtonItem" forIndexPath:indexPath];
    itemCell.itemImgView.image = [UIImage imageNamed:self.iconArr[indexPath.item]];
    itemCell.itemLabel.text = self.titleArr[indexPath.item];
    itemCell.redLabel.hidden = indexPath.item != self.iconArr.count - 1;
    if (indexPath.item == self.iconArr.count - 1) {
        itemCell.redNum = self.shopInfoModel.noReadNum;
    }
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.selectItemBlock) {
//        self.selectItemBlock(indexPath.item);
//    }
    
    if (self.selectItemSendStrBlock != nil) {
        self.selectItemSendStrBlock(self.titleArr[indexPath.row]);
    }
}


- (void)setConstrains {
    [self.shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(18);
        make.trailing.bottom.equalTo(self).offset(-18);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.bottom.equalTo(self).offset(-15);
    }];
}

- (UIView *)shadowBgView {
    if (!_shadowBgView) {
        _shadowBgView = [[UIView alloc] init];
        _shadowBgView.backgroundColor = [UIColor whiteColor];
        _shadowBgView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _shadowBgView.layer.shadowRadius = 5;
        _shadowBgView.layer.shadowOpacity = 0.5;
        _shadowBgView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _shadowBgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (void)setShopInfoModel:(LxmShopCenterUserInfoModel *)shopInfoModel {
    _shopInfoModel = shopInfoModel;
    if ([shopInfoModel.roleType isEqualToString:@"-1"] || [shopInfoModel.roleType isEqualToString:@"-0.5"] || [shopInfoModel.roleType isEqualToString:@"-0.4"] || [shopInfoModel.roleType isEqualToString:@"-0.3"] || [shopInfoModel.roleType isEqualToString:@"1.1"] || [shopInfoModel.roleType isEqualToString:@"2.1"] || [shopInfoModel.roleType isEqualToString:@"3.1"]) {
        
        if ([shopInfoModel.roleType isEqualToString:@"1.1"] || [shopInfoModel.roleType isEqualToString:@"2.1"] || [shopInfoModel.roleType isEqualToString:@"3.1"]) {
            
            self.titleArr = @[
                              @"我的店铺",
                              @"购进商品",
                              @"订单查询",
                              @"我的团队",
                              @"我的业绩",
                              @"我要升级",
                              @"积分兑换",
                              @"消息通知"
                              ];
            self.iconArr = @[
                             @"wddp",
                             @"goujinshangpin",
                             @"dingdanchaxun",
                             @"wodetuandui",
                             @"wodeyeji",
                             @"woyaoshengji",
                             @"kkjifen",
                             @"xiaoxitongzhi"
                             ];
            
        }else {
            self.titleArr = @[
                              @"我的店铺",
                              @"购进商品",
                              @"订单查询",
                              @"我要升级",
                              @"积分兑换",
                              @"消息通知"
                              ];
            self.iconArr = @[
                             @"wddp",
                             @"goujinshangpin",
                             @"dingdanchaxun",
                             @"woyaoshengji",
                             @"kkjifen",
                             @"xiaoxitongzhi"
                             ];
        }
    } else {
        if ([shopInfoModel.roleType isEqualToString:@"0"] || [shopInfoModel.roleType isEqualToString:@"1"] ||  [shopInfoModel.roleType isEqualToString:@"1.05"]) {
            self.titleArr = @[
                              @"我的店铺",
                              @"购进商品",
                              @"订单查询",
                              @"我要升级",
                              @"年度考核",
                              @"积分兑换",
                              @"消息通知"
                              ];
            self.iconArr = @[
                             @"wddp",
                             @"goujinshangpin",
                             @"dingdanchaxun",
                             @"woyaoshengji",
                             @"niandukaohe",
                             @"kkjifen",
                             @"xiaoxitongzhi"
                             ];
        }else if ([shopInfoModel.roleType isEqualToString:@"5"]){
            self.titleArr = @[
                              @"我的店铺",
                              @"购进商品",
                              @"订单查询",
                              @"我的团队",
                              @"我的业绩",
                              @"我要升级",
                              @"积分兑换",
                              @"消息通知"
                              ];
            self.iconArr = @[
                             @"wddp",
                             @"goujinshangpin",
                             @"dingdanchaxun",
                             @"wodetuandui",
                             @"wodeyeji",
                             @"woyaoshengji",
                             @"kkjifen",
                             @"xiaoxitongzhi"
                             ];
        }else {
            self.titleArr = @[
                              @"我的店铺",
                              @"购进商品",
                              @"订单查询",
                              @"我的团队",
                              @"我的业绩",
                              @"我要升级",
                              @"年度考核",
                              @"积分兑换",
                              @"消息通知"
                              ];
            self.iconArr = @[
                             @"wddp",
                             @"goujinshangpin",
                             @"dingdanchaxun",
                             @"wodetuandui",
                             @"wodeyeji",
                             @"woyaoshengji",
                             @"niandukaohe",
                             @"kkjifen",
                             @"xiaoxitongzhi"
                             ];
        }

       
    }
    self.collectionView.frame = CGRectMake(0, 0, ScreenW - 30, 80*ceil(self.titleArr.count/3.0) + 30);
    [self.collectionView reloadData];
    
}

@end

//年度考核view
@interface LxmNianDuKaoHeHeaderView ()

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *moneyLabel;//金额

@property (nonatomic, strong) UIImageView *sanjiaoImgView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIImageView *jinDuImgView;

@property (nonatomic, strong) UILabel *desLabel;//描述

@property (nonatomic, strong) UILabel *desLabel1;//描述

@property (nonatomic, strong) UIImageView *iconImgView;

@end
@implementation LxmNianDuKaoHeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.bgImgView];
    [self addSubview:self.jinDuImgView];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.sanjiaoImgView];
    [self addSubview:self.desLabel];
    [self addSubview:self.desLabel1];
    [self addSubview:self.iconImgView];
}

- (void)setConstrains {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@15);
        make.size.equalTo(@60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self.headerImgView);
    }];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(35);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-26);
        make.height.equalTo(@15);
    }];
    [self.jinDuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.bgImgView);
    }];
    [self.sanjiaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jinDuImgView.mas_leading);
        make.bottom.equalTo(self.jinDuImgView.mas_top).offset(-10);
        make.width.equalTo(@7);
        make.height.equalTo(@4);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sanjiaoImgView).offset(10);
        make.bottom.equalTo(self.sanjiaoImgView.mas_top);
        make.height.equalTo(@20);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jinDuImgView.mas_trailing);
        make.centerY.equalTo(self.jinDuImgView);
        make.size.equalTo(@22);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.desLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"progress"];
        _bgImgView.layer.cornerRadius = 7.5;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}


- (UIImageView *)jinDuImgView {
    if (!_jinDuImgView) {
        _jinDuImgView = [UIImageView new];
        _jinDuImgView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _jinDuImgView.layer.cornerRadius = 7.5;
        _jinDuImgView.layer.masksToBounds = YES;
    }
    return _jinDuImgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:81/255.0 alpha:1];
        _moneyLabel.textColor = UIColor.whiteColor;
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        _moneyLabel.layer.cornerRadius = 3;
        _moneyLabel.layer.masksToBounds = YES;
        
    }
    return _moneyLabel;
}

- (UIImageView *)sanjiaoImgView {
    if (!_sanjiaoImgView) {
        _sanjiaoImgView = [UIImageView new];
        _sanjiaoImgView.image = [UIImage imageNamed:@"sanjiaoxing"];
    }
    return _sanjiaoImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = CharacterGrayColor;
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UILabel *)desLabel1 {
    if (!_desLabel1) {
        _desLabel1 = [UILabel new];
        _desLabel1.font = [UIFont systemFontOfSize:14];
        _desLabel1.textColor = CharacterGrayColor;
        _desLabel1.numberOfLines = 0;
    }
    return _desLabel1;
}

- (void)setModel:(LxmNianDuKaoHeModel *)model {
    _model = model;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.userHead] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = _model.username;
    if (_model.yearMoney.doubleValue != 0) {
        if (_model.in_money.doubleValue > _model.yearMoney.doubleValue) {
            [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.sanjiaoImgView.mas_trailing).offset(10);
                make.bottom.equalTo(self.sanjiaoImgView.mas_top);
                make.height.equalTo(@20);
            }];
            [self.jinDuImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.trailing.top.bottom.equalTo(self.bgImgView);
               make.leading.equalTo(self.bgImgView.mas_trailing);
            }];
        } else {
            double bilv = 1 - _model.in_money.doubleValue / _model.yearMoney.doubleValue;
            if (bilv >= 0) {
                CGFloat w = (ScreenW - 30 - 11) * bilv;
                [self.jinDuImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.top.bottom.equalTo(self.bgImgView);
                    make.leading.equalTo(self.bgImgView.mas_trailing).offset(-w);
                }];
                if (bilv == 0) {
                    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.equalTo(self.sanjiaoImgView.mas_trailing).offset(10);
                        make.bottom.equalTo(self.sanjiaoImgView.mas_top);
                        make.height.equalTo(@20);
                    }];
                } else if (bilv == 1) {
                    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.sanjiaoImgView).offset(-10);
                        make.bottom.equalTo(self.sanjiaoImgView.mas_top);
                        make.height.equalTo(@20);
                    }];
                } else {
                    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.sanjiaoImgView).offset(10);
                        make.bottom.equalTo(self.sanjiaoImgView.mas_top);
                        make.height.equalTo(@20);
                    }];
                }
            }
        }
    }
    
    if (!_model.in_money) {
        _moneyLabel.text = @" 金额 0 ";
    } else {
        _moneyLabel.text = [NSString stringWithFormat:@" 金额 %@ ", _model.in_money];
    }
    
    
    _iconImgView.image = [UIImage imageNamed:_model.in_money.doubleValue >= _model.yearMoney.doubleValue ? @"jiesuo_y" : @"jiesuo_n"];
    
    NSDate * begin_date = [NSDate dateWithTimeIntervalSince1970:_model.begin_day.doubleValue/1000];
    NSDate * end_date = [NSDate dateWithTimeIntervalSince1970:_model.end_day.doubleValue/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日"];
    NSString * beginStr = [df stringFromDate:begin_date];
    NSString * endStr = [df stringFromDate:end_date];
    
    
    _desLabel.text = [NSString stringWithFormat:@"年度考核计算周期: %@-%@", beginStr, endStr];
    if ( [_model.roleType isEqualToString:@"2.1"] || [_model.roleType isEqualToString:@"3"] ) {
        _desLabel1.text = @"说明:年度业绩目标六十万元，业绩不达标系统将自动降级并扣除保证金！";
    } else {
        _desLabel1.text = @"";
    }
}

@end
