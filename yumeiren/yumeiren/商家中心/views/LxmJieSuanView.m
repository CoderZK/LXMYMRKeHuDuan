//
//  LxmJieSuanView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieSuanView.h"

@implementation LxmJieSuanView

@end

@interface LxmJieSuanBottomView ()

@property (nonatomic, strong) UIButton *tijiaoButton;//提交订单

@property (nonatomic, strong) UIView *bottomView;

@end
@implementation LxmJieSuanBottomView

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
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.moneyLabel];
    [self.bottomView addSubview:self.tijiaoButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@70);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView).offset(15);
        make.centerY.equalTo(self.bottomView);
    }];
    [self.tijiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(@100);
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"实付金额 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥158" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        _moneyLabel.attributedText = att;
    }
    return _moneyLabel;
}

- (UIButton *)tijiaoButton {
    if (!_tijiaoButton) {
        _tijiaoButton = [[UIButton alloc] init];
        [_tijiaoButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_tijiaoButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_tijiaoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _tijiaoButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_tijiaoButton addTarget:self action:@selector(tijiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tijiaoButton;
}

- (void)tijiaoButtonClick:(UIButton *)btn {
    if (self.tijiaoBlock) {
        self.tijiaoBlock();
    }
}

@end

/**
 选择配送方式
 */
@interface LxmJieSuanPeiSongStyleCell ()

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmJieSuanPeiSongStyleCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.styleLabel];
    [self addSubview:self.accImgView];
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
    [self.styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
        make.centerY.equalTo(self);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)styleLabel {
    if (!_styleLabel) {
        _styleLabel = [UILabel new];
        _styleLabel.font = [UIFont systemFontOfSize:13];
        _styleLabel.textColor = CharacterDarkColor;
    }
    return _styleLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end

/**
 配送商品
 */
@interface LxmJieSuanPeiSongGoodsCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *numLabel;//数量

@end
@implementation LxmJieSuanPeiSongGoodsCell

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
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImgView).offset(-10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.numLabel.mas_leading).offset(-5);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.numLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
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
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:13];
        _numLabel.textColor = CharacterGrayColor;
    }
    return _numLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (void)setData {
    self.titleLabel.text = @"高端魅力修护套装";
    self.moneyLabel.text = @"¥198";
    self.numLabel.text = @"X2";
}

- (void)setModel:(LxmShopCarModel *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _model.good_name;
    CGFloat f = _model.good_price.doubleValue;
    NSInteger d = _model.good_price.integerValue;
    
    CGFloat f1 = _model.proxy_price.doubleValue;
    NSInteger d1 = _model.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:f1==d1 ? [NSString stringWithFormat:@"¥%ld ",d1] : [NSString stringWithFormat:@"¥%.2f ",f1] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:f==d ? [NSString stringWithFormat:@"¥%ld ",d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _model.num];
}

- (void)setOrderModel:(LxmShopCenterOrderGoodsModel *)orderModel {
    _orderModel = orderModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_orderModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _orderModel.good_name;
    CGFloat f = _orderModel.good_price.doubleValue;
    NSInteger d = _orderModel.good_price.integerValue;
    
    CGFloat f1 = _orderModel.proxy_price.doubleValue;
    NSInteger d1 = _orderModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:f1==d1 ? [NSString stringWithFormat:@"¥%ld ",d1] : [NSString stringWithFormat:@"¥%.2f ",f1] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:f==d ? [NSString stringWithFormat:@"¥%ld ",d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _orderModel.num];
    
}

/**
 订单查询 订单详情 商品信息
 */
- (void)setOrderDetailGoodsModel:(LxmShopCenterOrderGoodsModel *)orderDetailGoodsModel {
    _orderDetailGoodsModel = orderDetailGoodsModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_orderDetailGoodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _orderDetailGoodsModel.good_name;
    
    CGFloat f = _orderDetailGoodsModel.good_price.doubleValue;
    NSInteger d = _orderDetailGoodsModel.good_price.integerValue;
    
    CGFloat f1 = _orderDetailGoodsModel.proxy_price.doubleValue;
    NSInteger d1 = _orderDetailGoodsModel.proxy_price.integerValue;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:f1==d1 ? [NSString stringWithFormat:@"¥%ld ",d1] : [NSString stringWithFormat:@"¥%.2f ",f1] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:f==d ? [NSString stringWithFormat:@"¥%ld ",d] : [NSString stringWithFormat:@"¥%.2f ",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    _numLabel.text = [NSString stringWithFormat:@"X%@", _orderDetailGoodsModel.num];
}

@end
/**
 数量 商品价格
 */
@interface LxmJieSuanPeiSongInfoCell ()

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmJieSuanPeiSongInfoCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
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
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = CharacterDarkColor;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


/**
 收货地址
 */
@interface LxmJieSuanPeiSongAddressCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//定位图标

@property (nonatomic, strong) UIImageView *accImgView;//箭头z

@property (nonatomic, strong) UIImageView *bottomImgView;//底部背景图

@property (nonatomic, strong) UILabel *nameAndPhoneLabl;//姓名 + 电话

@property (nonatomic, strong) UILabel *detailLabel;//详情地址

@end
@implementation LxmJieSuanPeiSongAddressCell

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
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.accImgView];
    [self addSubview:self.bottomImgView];
    [self addSubview:self.nameAndPhoneLabl];
    [self addSubview:self.detailLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@6);
    }];
    [self.nameAndPhoneLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self).offset(20);
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.nameAndPhoneLabl.mas_bottom).offset(10);
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"local"];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"请选择收货地址";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)nameAndPhoneLabl {
    if (!_nameAndPhoneLabl) {
        _nameAndPhoneLabl = [UILabel new];
        _nameAndPhoneLabl.font = [UIFont systemFontOfSize:15];
        _nameAndPhoneLabl.textColor = CharacterDarkColor;
        _nameAndPhoneLabl.hidden = YES;
    }
    return _nameAndPhoneLabl;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.hidden = YES;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}


- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UIImageView *)bottomImgView {
    if (!_bottomImgView) {
        _bottomImgView = [UIImageView new];
        _bottomImgView.image = [UIImage imageNamed:@"bg_fengexian"];
    }
    return _bottomImgView;
}

- (void)setAddressModel:(LxmAddressModel *)addressModel {
    _addressModel = addressModel;
    self.titleLabel.hidden = YES;
    self.nameAndPhoneLabl.hidden = self.detailLabel.hidden = NO;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ",_addressModel.username] attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:_addressModel.telephone ? _addressModel.telephone : @"" attributes:@{ NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [att appendAttributedString:str];
    self.nameAndPhoneLabl.attributedText = att;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_addressModel.province, _addressModel.city, _addressModel.district, _addressModel.addressDetail];
}

@end

@interface LxmAcGoodsCell ()
@property (nonatomic, strong) UIImageView *iconImgView;//图片
@property (nonatomic, strong) UIButton *zIconImgView;//图片
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *numLabel;//数量
@end

@implementation LxmAcGoodsCell

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
    [self addSubview:self.iconImgView];
    [self addSubview:self.zIconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.zIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(10);
        make.width.height.equalTo(@30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.numLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UIButton *)zIconImgView {
    if (!_zIconImgView) {
        _zIconImgView = [[UIButton alloc] init];
        [_zIconImgView setTitle:@"赠" forState:UIControlStateNormal];
        _zIconImgView.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _zIconImgView.backgroundColor = MainColor;
        _zIconImgView.userInteractionEnabled = NO;
        _zIconImgView.layer.cornerRadius = 15;
        _zIconImgView.layer.masksToBounds = YES;
    }
    return _zIconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:13];
        _numLabel.textColor = CharacterGrayColor;
    }
    return _numLabel;
}

- (void)setModel:(LxmAcGoodsModel *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.goodPic]];
    _titleLabel.text = _model.goodName;
    _numLabel.text = [NSString stringWithFormat:@"x%ld", _model.loc_num];
}

- (void)setDetailGoodsModel:(LxmShopCenterAcGoodsModel *)detailGoodsModel {
    _detailGoodsModel = detailGoodsModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_detailGoodsModel.good_pic]];
    _titleLabel.text = _detailGoodsModel.good_name;
    _numLabel.text = [NSString stringWithFormat:@"x%ld", _detailGoodsModel.num.integerValue];
}

@end


@interface LxmNoteCell ()

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmNoteCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(15);
        make.top.equalTo(self).offset(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}


@end
