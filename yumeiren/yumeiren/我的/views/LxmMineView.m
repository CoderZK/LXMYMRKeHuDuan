//
//  LxmMineView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMineView.h"
#import "LxmHomeView.h"

@implementation LxmMineView

@end


/**
 我的订单 全部订单
 */
@interface LxmMineOrderTopView : UIControl

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIImageView *rightImgView;//箭头

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmMineOrderTopView

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
 添加子视图
 */
- (void)initSubviews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.rightImgView];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightImgView.mas_leading).offset(-3);
        make.centerY.equalTo(self);
    }];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont boldSystemFontOfSize:15];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.text = @"我的订单";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = CharacterLightGrayColor;
        _rightLabel.text = @"全部订单";
    }
    return _rightLabel;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image = [UIImage imageNamed:@"next"];
    }
    return _rightImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmMineOrderBottomView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) void(^itemDidSelectBlock)(NSInteger index);

@end
@implementation LxmMineOrderBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(floor((ScreenW - 60)*0.2), 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 60, 100) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmHomeButtonItem.class forCellWithReuseIdentifier:@"LxmHomeButtonItem"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeButtonItem *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeButtonItem" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wd_dfh"];
        buttonItem.itemLabel.text = @"待发货";
    } else if (indexPath.item == 1) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wd_dsh"];
        buttonItem.itemLabel.text = @"待收货";
    } else if (indexPath.item == 2) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wd_dzt"];
        buttonItem.itemLabel.text = @"待自提";
    } else if (indexPath.item == 3) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wd_ysh"];
        buttonItem.itemLabel.text = @"已收货";
    } else {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wd_yqx"];
        buttonItem.itemLabel.text = @"已自提";
    }
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemDidSelectBlock) {
        self.itemDidSelectBlock(indexPath.item);
    }
}

@end



/**
 我的订单
 */
@interface LxmMineOrderCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *shadowBgView;

@property (nonatomic, strong) LxmMineOrderTopView *topView;

@property (nonatomic, strong) LxmMineOrderBottomView *bottomView;

@end

@implementation LxmMineOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bgView);
        make.height.equalTo(@40);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.bottom.equalTo(self.bgView).offset(-5);
        make.leading.trailing.equalTo(self.bgView);
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

- (LxmMineOrderTopView *)topView {
    if (!_topView) {
        _topView = [[LxmMineOrderTopView alloc] init];
        [_topView addTarget:self action:@selector(myorderClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (LxmMineOrderBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmMineOrderBottomView alloc] init];
        WeakObj(self);
        _bottomView.itemDidSelectBlock = ^(NSInteger index) {
            if (selfWeak.itemDidSeletAtIndex) {
                selfWeak.itemDidSeletAtIndex(index);
            }
        };
    }
    return _bottomView;
}

/**
 我的订单
 */
- (void)myorderClick {
    if (self.myOrderBlock) {
        self.myOrderBlock();
    }
}

@end


/**
 我的cell
 */
@interface LxmMineCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel;//标题



@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
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
    [self addSubview:self.titleLabel];
    [self addSubview:self.detaillabel];
    [self addSubview:self.accImgView];
    [self addSubview:self.lineView];
}
/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
        make.centerY.equalTo(self);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self.accImgView);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
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
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detaillabel {
    if (!_detaillabel) {
        _detaillabel = [[UILabel alloc] init];
        _detaillabel.font = [UIFont systemFontOfSize:15];
        _detaillabel.textColor = CharacterDarkColor;
    }
    return _detaillabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    switch (_index) {
        case 0: {
            self.iconImgView.image = [UIImage imageNamed:@"wodeqianbao"];
            self.detaillabel.hidden = NO;
            self.titleLabel.text = @"我的钱包";
            self.detaillabel.text = @"¥2888";
        }
            break;
        case 3: {
            self.iconImgView.image = [UIImage imageNamed:@"wodehongbao"];
            self.detaillabel.hidden = NO;
            self.titleLabel.text = @"我的红包";
            self.detaillabel.text = @"";
        }
            break;
        case 4: {
            self.iconImgView.image = [UIImage imageNamed:@"baozhengjin"];
            self.detaillabel.hidden = NO;
            self.titleLabel.text = @"保证金";
            self.detaillabel.text = @"";
        }
            break;
            
        case 1: {
            self.iconImgView.image = [UIImage imageNamed:@"kk935"];
            self.detaillabel.hidden = YES;
            self.titleLabel.text = @"我的小煜";
            self.detaillabel.text = @"";
        }
            break;
            
        case 2: {
            self.iconImgView.image = [UIImage imageNamed:@"kk935"];
            self.detaillabel.hidden = YES;
            self.titleLabel.text = @"我的积分";
            self.detaillabel.text = @"";
        }
            break;
            
        case 5: {
            self.iconImgView.image = [UIImage imageNamed:@"wodeshimingzhi"];
            self.detaillabel.hidden = NO;
            self.titleLabel.text = @"实名认证";
            self.detaillabel.text = @"已认证";
        }
            break;
        case 6: {
            self.iconImgView.image = [UIImage imageNamed:@"wd_mdcx"];
            self.titleLabel.text = @"门店查询";
            self.detaillabel.hidden = YES;
        }
            break;
        case 7: {
            self.iconImgView.image = [UIImage imageNamed:@"kfzx"];
            self.detaillabel.hidden = YES;
            self.titleLabel.text = @"客服中心";
        }
            break;
        case 8: {
            self.iconImgView.image = [UIImage imageNamed:@"shezhi"];
            self.detaillabel.hidden = YES;
            self.titleLabel.text = @"设置";
        }
            break;
        default:
            break;
    }
}

- (void)setInfoModel:(LxmUserInfoModel *)infoModel {
    _infoModel = infoModel;
    
    self.titleLabel.hidden = NO;
    self.detaillabel.hidden = NO;
    self.iconImgView.hidden = NO;
    self.accImgView.hidden = NO;
    
    switch (self.index) {
        case 0: {
            CGFloat f = _infoModel.balance.doubleValue;
            NSInteger d = _infoModel.balance.integerValue;
            if (f == d) {
                self.detaillabel.text = [NSString stringWithFormat:@"¥%ld",(long)d];
            } else {
                self.detaillabel.text = [NSString stringWithFormat:@"¥%.2f",f];
            }
            
        }
            break;
        case 3: {
            CGFloat f = _infoModel.redBalance.doubleValue;
                          NSInteger d = _infoModel.redBalance.integerValue;
                          if (f == d) {
                              self.detaillabel.text = [NSString stringWithFormat:@"¥%ld",(long)d];
                          } else {
                              self.detaillabel.text = [NSString stringWithFormat:@"¥%.2f",f];
                          }
                          if (_infoModel.roleType.integerValue < 2) {
                              self.titleLabel.hidden = YES;
                              self.detaillabel.hidden = YES;
                              self.iconImgView.hidden = YES;
                              self.accImgView.hidden = YES;
                          } else {
                              self.titleLabel.hidden = NO;
                              self.detaillabel.hidden = NO;
                              self.iconImgView.hidden = NO;
                              self.accImgView.hidden = NO;
                          }
        }
            break;
        case 4: {
            
            CGFloat f = _infoModel.deposit.doubleValue;
            NSInteger d = _infoModel.deposit.integerValue;
            if (f == d) {
                self.detaillabel.text = [NSString stringWithFormat:@"¥%ld",(long)d];
            } else {
                self.detaillabel.text = [NSString stringWithFormat:@"¥%.2f",f];
            }
            if (_infoModel.roleType.integerValue < 2) {
                self.titleLabel.hidden = YES;
                self.detaillabel.hidden = YES;
                self.iconImgView.hidden = YES;
                self.accImgView.hidden = YES;
            } else {
                self.titleLabel.hidden = NO;
                self.detaillabel.hidden = NO;
                self.iconImgView.hidden = NO;
                self.accImgView.hidden = NO;
            }
            
          
            
            
        }
            break;
            case 1: {
              
            }
            break;
        case 2: {
              self.detaillabel.text = [self.infoModel.sendScore getPriceStr];
        }
            break;
            
        case 5: {
            self.detaillabel.text = (_infoModel.idCode.isValid && _infoModel.thirdStatus.integerValue == 1) ? @"已认证" : @"未认证";
        }
            break;
        case 6: {
            if (_infoModel.roleType.integerValue == -1) {
                self.titleLabel.hidden = YES;
                self.detaillabel.hidden = YES;
                self.iconImgView.hidden = YES;
                self.accImgView.hidden = YES;
            } else {
                self.titleLabel.hidden = NO;
                self.detaillabel.hidden = NO;
                self.iconImgView.hidden = NO;
                self.accImgView.hidden = NO;
            }
        }
            
        default:
            break;
    }
}

@end
