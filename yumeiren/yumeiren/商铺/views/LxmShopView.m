//
//  LxmShopView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopView.h"

@implementation LxmShopView

@end

/**
 价格 名称
 */
@interface LxmGoodsDetailPriceCell ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *priceLabel;//价格

@property (nonatomic, strong) UILabel *nameLabel;//名称

@end

@implementation LxmGoodsDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.lineView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.nameLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
        _priceLabel.textColor = MainColor;
    }
    return _priceLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (void)setDetailModel:(LxmGoodsDetailModel *)detailModel {
    _detailModel = detailModel;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.goodPrice];
    self.nameLabel.text = _detailModel.goodName;
}

@end

/**
 运费
 */
@interface LxmGoodsDetailPeiSongCell ()

@property (nonatomic, strong) UILabel *yunfeiLabel;//运费

@property (nonatomic, strong) UILabel *detailLabel;//说明

@end
@implementation LxmGoodsDetailPeiSongCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.yunfeiLabel];
        [self addSubview:self.detailLabel];
        [self.yunfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@30);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.yunfeiLabel.mas_trailing).offset(15);
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)yunfeiLabel {
    if (!_yunfeiLabel) {
        _yunfeiLabel = [[UILabel alloc] init];
        _yunfeiLabel.font = [UIFont systemFontOfSize:14];
        _yunfeiLabel.text = @"运费";
        _yunfeiLabel.textColor = CharacterGrayColor;
    }
    return _yunfeiLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (void)setDetailModel:(LxmGoodsDetailModel1 *)detailModel {
    _detailModel = detailModel;
    if (_detailModel.postMoney.intValue == 0) {
        self.detailLabel.text = @"物流发货";
    } else {
        self.detailLabel.text = [NSString stringWithFormat:@"满%@包邮或者到付",_detailModel.postMoney];
    }
}

@end

/**
 图文详情
 */

@interface LxmGoodsDetailTopCell ()

@property (nonatomic, strong) UILabel *topLabel;//图文详情

@end

@implementation LxmGoodsDetailTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.topLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15);
        make.height.equalTo(@20);
    }];
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.font = [UIFont boldSystemFontOfSize:15];
        _topLabel.textColor = CharacterDarkColor;
        _topLabel.text = @"图文详情";
    }
    return _topLabel;
}

@end


@interface LxmGoodsDetailTextCell ()

@property (nonatomic, strong) UILabel *miaoShuLabel;//文字

@end

@implementation LxmGoodsDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.miaoShuLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.miaoShuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UILabel *)miaoShuLabel {
    if (!_miaoShuLabel) {
        _miaoShuLabel = [UILabel new];
        _miaoShuLabel.font = [UIFont systemFontOfSize:14];
        _miaoShuLabel.textColor = CharacterDarkColor;
        _miaoShuLabel.numberOfLines = 0;
    }
    return _miaoShuLabel;
}


- (void)setData {
    self.miaoShuLabel.text = @"产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述";
}

- (void)setModel:(LxmGoodsDetailModel *)model {
    _model = model;
    self.miaoShuLabel.text = _model.content;
}

@end


@interface LxmGoodsDetailImgCell ()

@property (nonatomic, strong) UIImageView *imgView;//图片

@end

@implementation LxmGoodsDetailImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.imgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (void)setTupianModel:(LxmGoodsDetailTuPianModel *)tupianModel {
    _tupianModel = tupianModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_tupianModel.url] placeholderImage:[UIImage imageNamed:@"tabbarwhite"] options:SDWebImageScaleDownLargeImages];
    if (_tupianModel.width > ScreenW) {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self); make.height.equalTo(@(ScreenW*_tupianModel.height/_tupianModel.width));
            make.width.equalTo(@(ScreenW));
        }];
    }else {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(_tupianModel.width));
            make.height.equalTo(@(_tupianModel.height));
        }];
    }
}

@end
