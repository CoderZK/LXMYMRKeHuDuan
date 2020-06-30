//
//  LxmShopCarView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCarView.h"

@implementation LxmShopCarView

@end

@implementation LxmNumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubviews {
    [self addSubview:self.incButton];
    [self addSubview:self.numTF];
    [self addSubview:self.decButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.decButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@26);
    }];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.decButton.mas_trailing);
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.incButton.mas_leading);
    }];
    [self.incButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.equalTo(@26);
    }];
}

- (UIButton *)incButton {
    if (!_incButton) {
        _incButton = [[UIButton alloc] init];
        [_incButton setTitle:@"+" forState:UIControlStateNormal];
        [_incButton setTitleColor:CharacterLightGrayColor forState:UIControlStateNormal];
        _incButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _incButton.layer.borderWidth = 0.5;
        _incButton.layer.borderColor = CharacterLightGrayColor.CGColor;
    }
    return _incButton;
}

- (UITextField *)numTF {
    if (!_numTF) {
        _numTF = [[UITextField alloc] init];
        _numTF.font = [UIFont systemFontOfSize:14];
        _numTF.textColor = CharacterDarkColor;
        _numTF.textAlignment = NSTextAlignmentCenter;
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numTF;
}

- (UIButton *)decButton {
    if (!_decButton) {
        _decButton = [[UIButton alloc] init];
        [_decButton setTitle:@"-" forState:UIControlStateNormal];
        [_decButton setTitleColor:CharacterLightGrayColor forState:UIControlStateNormal];
        _decButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _decButton.layer.borderWidth = 0.5;
        _decButton.layer.borderColor = CharacterLightGrayColor.CGColor;

    }
    return _decButton;
}

@end

@interface LxmShopCarCell()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *selectButton;//选择按钮

@property (nonatomic, strong) UIImageView *selectImgView;//选择背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@property (nonatomic, strong) UILabel *kucunJinZhangLabel;//库存紧张

@end

@implementation LxmShopCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    UIControl *view = [UIControl new];
    view.userInteractionEnabled = YES;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self);
        make.width.equalTo(self.mas_height);
    }];

    [self addSubview:self.selectButton];
    [self.selectButton addSubview:self.selectImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numView];
    [self addSubview:self.kucunJinZhangLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@50);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.selectButton);
        make.width.height.equalTo(@20);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing);
        make.top.equalTo(self).offset(15);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.kucunJinZhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kucunJinZhangLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
        make.height.equalTo(@26);
    }];
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton addTarget:self action:@selector(selectBottonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
    }
    return _selectImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)kucunJinZhangLabel {
    if (!_kucunJinZhangLabel) {
        _kucunJinZhangLabel = [[UILabel alloc] init];
        _kucunJinZhangLabel.font = [UIFont systemFontOfSize:12];
        _kucunJinZhangLabel.textColor = MainColor;
        _kucunJinZhangLabel.text = @"库存紧张";
        _kucunJinZhangLabel.hidden = YES;
    }
    return _kucunJinZhangLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}

- (LxmNumView *)numView {
    if (!_numView) {
        _numView = [[LxmNumView alloc] init];
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _numView.numTF.delegate = self;
    }
    return _numView;
}

- (void)btnClick:(UIButton *)btn {
    [_numView endEditing:YES];
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
        }else {
            [SVProgressHUD showErrorWithStatus:@"受不了了,不能再少了!"];
            return;
        }
    } else {
        num ++;
    }
    _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    NSString *maxNum = self.carModel.good_num.integerValue > self.carModel.com_num.integerValue ? self.carModel.good_num : self.carModel.com_num;
//    if (_numView.numTF.text.integerValue > maxNum.integerValue) {
//        //库存不足
//        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"库存不足!" message:[NSString stringWithFormat:@"%@的库存量:%ld",self.carModel.good_name,maxNum.integerValue] preferredStyle:UIAlertControllerStyleAlert];
//        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)maxNum.integerValue];
//            self.carModel.num = _numView.numTF.text;
//            [self modifyCar:_numView.numTF.text];
//        }]];
//        [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
//    } else {
        self.carModel.num = _numView.numTF.text;
        [self modifyCar:_numView.numTF.text];
//    }
}

/**
 选中不选中
 */
- (void)selectBottonClick {
    if (self.selectClick) {
        self.selectClick(self.carModel);
    }
}


- (void)setData {
    self.titleLabel.text = @"高端魅力修护套装";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"¥0 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = @"1";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    if (textField.text.intValue < 1) {
        _numView.numTF.text = @"1";
        [SVProgressHUD showErrorWithStatus:@"至少购买一件商品!"];
        return;
    }
//    NSString *maxNum = self.carModel.good_num.integerValue > self.carModel.com_num.integerValue ? self.carModel.good_num : self.carModel.com_num;
//    if (_numView.numTF.text.floatValue > maxNum.floatValue) {
//        //库存不足
//        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"库存不足!" message:[NSString stringWithFormat:@"%@的库存量:%ld",self.carModel.good_name,maxNum.integerValue] preferredStyle:UIAlertControllerStyleAlert];
//        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            textField.text = maxNum;
//            [self modifyCar:textField.text];
//            self.carModel.num = _numView.numTF.text;
//        }]];
//        [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
//
//    } else {
        [self modifyCar:textField.text];
        self.carModel.num = _numView.numTF.text;
//    }
}

/**
 购物车列表
 */
- (void)setCarModel:(LxmShopCarModel *)carModel {
    _carModel = carModel;
    
//    NSString *maxNum = _carModel.good_num.integerValue > _carModel.com_num.integerValue ? _carModel.good_num : _carModel.com_num;
//    if (_carModel.num.floatValue > maxNum.floatValue) {
//        _kucunJinZhangLabel.hidden = NO;
//        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.kucunJinZhangLabel.mas_bottom).offset(10);
//            make.leading.equalTo(self.iconImgView.mas_tiling).offset(15);
//            make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
//        }];
//    } else {
        _kucunJinZhangLabel.hidden = YES;
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
        }];
//    }
    
    _selectImgView.image = [UIImage imageNamed:_carModel.isSelected ? @"xuanzhong_y" : @"xuanzhong_n"];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_carModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.titleLabel.text = _carModel.good_name;
    
    CGFloat f1 = _carModel.good_price.floatValue;
    NSInteger d1 = _carModel.good_price.integerValue;
    
    CGFloat f = _carModel.proxy_price.floatValue;
    NSInteger d = _carModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:d == f ? [NSString stringWithFormat:@"¥%ld ",(long)d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:d1 == f1 ? [NSString stringWithFormat:@"¥%ld ",(long)d1] : [NSString stringWithFormat:@"¥%.2f ",f1]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = _carModel.num;
}

/**
 修改购物车
 */
- (void)modifyCar:(NSString *)numStr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"num"] = numStr;
    dict[@"id"] = self.carModel.id;
    dict[@"goodId"] = self.carModel.good_id;
    WeakObj(self);
    [LxmNetworking networkingPOST:up_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.carModel.num  = selfWeak.numView.numTF.text;
            if (selfWeak.modifyCarSuccess) {
                selfWeak.modifyCarSuccess(selfWeak.carModel);
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



@end

//购物车底部view
@interface LxmShopCarBottomView ()

@property (nonatomic, strong) UILabel *allLabel;//

@end
@implementation LxmShopCarBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)setIsYIjianbuhuo:(bool)isYIjianbuhuo {
    _isYIjianbuhuo = isYIjianbuhuo;
    if (_isYIjianbuhuo) {
        [self.allSelectButton addTarget:self action:@selector(allClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setConstrains1];
    }
}

- (void)allClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.allSelectBlock) {
        self.allSelectBlock(btn.selected);
    }
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.allSelectButton];
    [self.allSelectButton addSubview:self.allImgView];
    [self.allSelectButton addSubview:self.allLabel];
    [self addSubview:self.yuanPrice];
    [self addSubview:self.vipPrice];
    [self addSubview:self.jiesuanButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    [self.allImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allSelectButton).offset(15);
        make.centerY.equalTo(self.allSelectButton);
        make.width.height.equalTo(@20);
    }];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self.allSelectButton);
    }];
    [self.yuanPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.jiesuanButton.mas_leading).offset(-10);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        make.leading.greaterThanOrEqualTo(self.allSelectButton.mas_trailing);
    }];
    [self.vipPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.jiesuanButton.mas_leading).offset(-10);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.leading.greaterThanOrEqualTo(self.allSelectButton.mas_trailing);
    }];
    [self.jiesuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@90);
        make.height.equalTo(@40);
    }];
}

- (void)setConstrains1 {
    [self.allSelectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    [self.allImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allSelectButton).offset(15);
        make.top.equalTo(self.allSelectButton).offset(20);
        make.width.height.equalTo(@20);
    }];
    [self.allLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self.allImgView);
    }];
    [self.jiesuanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@90);
        make.height.equalTo(@40);
    }];
}

- (UIButton *)allSelectButton {
    if (!_allSelectButton) {
        _allSelectButton = [[UIButton alloc] init];
    }
    return _allSelectButton;
}

- (UIImageView *)allImgView {
    if (!_allImgView) {
        _allImgView = [[UIImageView alloc] init];
        _allImgView.image = [UIImage imageNamed:@"xuanze_n"];
    }
    return _allImgView;
}

- (UILabel *)allLabel {
    if (!_allLabel) {
        _allLabel = [[UILabel alloc] init];
        _allLabel.text = @"全选";
        _allLabel.textColor = CharacterDarkColor;
        _allLabel.font = [UIFont systemFontOfSize:14];
    }
    return _allLabel;
}

- (UILabel *)yuanPrice {
    if (!_yuanPrice) {
        _yuanPrice = [[UILabel alloc] init];
        _yuanPrice.font = [UIFont systemFontOfSize:14];
    }
    return _yuanPrice;
}

- (UILabel *)vipPrice {
    if (!_vipPrice) {
        _vipPrice = [[UILabel alloc] init];
        _vipPrice.textColor = CharacterLightGrayColor;
        _vipPrice.font = [UIFont systemFontOfSize:14];
    }
    return _vipPrice;
}

- (UIButton *)jiesuanButton {
    if (!_jiesuanButton) {
        _jiesuanButton = [[UIButton alloc] init];
        [_jiesuanButton setTitle:@"结算" forState:UIControlStateNormal];
        [_jiesuanButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _jiesuanButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_jiesuanButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _jiesuanButton.layer.cornerRadius = 20;
        _jiesuanButton.layer.masksToBounds = YES;
        [_jiesuanButton addTarget:self action:@selector(jiesuanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiesuanButton;
}


/**
 结算
 */
- (void)jiesuanClick {
    if (self.jiesuanBlock) {
        self.jiesuanBlock();
    }
}


@end
