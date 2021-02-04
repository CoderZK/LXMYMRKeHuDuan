//
//  LxmHomeView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHomeView.h"

@implementation LxmHomeView

@end

@implementation LxmHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end


@implementation LxmHomeButtonItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (UIImageView *)itemImgView {
    if (!_itemImgView) {
        _itemImgView = [[UIImageView alloc] init];
    }
    return _itemImgView;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.textColor = CharacterDarkColor;
        _itemLabel.font = [UIFont systemFontOfSize:14];
    }
    return _itemLabel;
}

- (UILabel *)redLabel {
    if (!_redLabel) {
        _redLabel = [UILabel new];
        _redLabel.font = [UIFont systemFontOfSize:9];
        _redLabel.textColor = UIColor.whiteColor;
        _redLabel.backgroundColor = MainColor;
        _redLabel.layer.cornerRadius = 7.5;
        _redLabel.layer.masksToBounds= YES;
        _redLabel.textAlignment = NSTextAlignmentCenter;
        _redLabel.hidden = YES;
    }
    return _redLabel;
}
/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.itemImgView];
    [self addSubview:self.itemLabel];
    [self addSubview:self.redLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.itemImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(8);
        make.centerX.equalTo(self);
    }];
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImgView).offset(-5);
        make.leading.equalTo(self.itemImgView.mas_trailing).offset(-10);
        make.width.height.equalTo(@15);
    }];
    [self layoutIfNeeded];
}

- (void)setRedNum:(NSString *)redNum {
    _redNum = redNum;
    self.redLabel.hidden = _redNum.intValue == 0;
    self.redLabel.text = _redNum;
    CGFloat w = [_redNum getSizeWithMaxSize:CGSizeMake(200, 15) withFontSize:10].width;
    w = w > 15 ? (w + 10) : 15;
    [self.redLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImgView).offset(-5);
        make.leading.equalTo(self.itemImgView.mas_trailing).offset(-10);
        make.width.equalTo(@(w));
        make.height.equalTo(@15);
    }];
}

@end


/**
 item cell
 */
@interface LxmHomeButtonCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LxmHomeButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
        if ([LxmTool ShareTool].userModel.roleType.integerValue >= 2 ) {
            self.layout.itemSize = CGSizeMake(floor(ScreenW*0.2), 100);
        } else {
            self.layout.itemSize = CGSizeMake(floor(ScreenW*0.25), 100);
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100) collectionViewLayout:self.layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:LxmHomeButtonItem.class forCellWithReuseIdentifier:@"LxmHomeButtonItem"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([LxmTool ShareTool].userModel.roleType.integerValue >= 2 ) {
        return 5;
    }
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeButtonItem *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeButtonItem" forIndexPath:indexPath];
    if (self.currentRole >= 2 ) {
        if (indexPath.item == 0) {
            buttonItem.itemLabel.text = @"关于我们";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"gywm"];
        } else if (indexPath.item == 1) {
            buttonItem.itemLabel.text = @"素材中心";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"sczx"];
        } else if (indexPath.item == 2) {
            buttonItem.itemLabel.text = @"投诉中心";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"tszx"];
        } else if (indexPath.item == 3) {
            buttonItem.itemLabel.text = @"接单平台";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"gywm"];
        } else {
            buttonItem.itemLabel.text = @"培训课堂";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"pxkt"];
        }
    } else {
        if (indexPath.item == 0) {
            buttonItem.itemLabel.text = @"关于我们";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"gywm"];
        } else if (indexPath.item == 1) {
            buttonItem.itemLabel.text = @"素材中心";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"sczx"];
        } else if (indexPath.item == 2) {
            buttonItem.itemLabel.text = @"投诉中心";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"tszx"];
        } else {
            buttonItem.itemLabel.text = @"培训课堂";
            buttonItem.itemImgView.image = [UIImage imageNamed:@"pxkt"];
        }
    }
    
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    if (self.didSelectItemBlock) {
        selfWeak.didSelectItemBlock(indexPath.item);
    }
}

- (void)setCurrentRole:(NSInteger)currentRole {
    _currentRole = currentRole;
    if (_currentRole >= 2 ) {
        self.layout.itemSize = CGSizeMake(floor(ScreenW*0.2), 100);
    } else {
        self.layout.itemSize = CGSizeMake(floor(ScreenW*0.25), 100);
    }
    [self.collectionView reloadData];
}

@end

/**
 区头
 */
@implementation LxmHomeSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

@end


/**
 商品列表底部视图
 */
@interface LxmHomeGoodsBottomView : UIView

@property (nonatomic, strong) UILabel *titleLabel;//商品名称

@property (nonatomic, strong) UILabel *moneyLabel;//商品价格

@property (nonatomic, strong) UIButton *shopCarButton;//购物车按钮

@end
@implementation LxmHomeGoodsBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstarins];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.shopCarButton];
}

- (void)setConstarins {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self.shopCarButton.mas_leading);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self.shopCarButton.mas_leading);
    }];
    [self.shopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.equalTo(@40);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.text = @"淡淡清香味香水";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = MainColor;
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.text = @"￥198";
    }
    return _moneyLabel;
}

- (UIButton *)shopCarButton {
    if (!_shopCarButton) {
        _shopCarButton = [[UIButton alloc] init];
        [_shopCarButton setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        _shopCarButton.contentEdgeInsets = UIEdgeInsetsMake(21, 10, 5, 5);
    }
    return _shopCarButton;
}

@end



@interface LxmHomeGoodsItem()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *yingyinView;

@property (nonatomic, strong) UIImageView *goodsImgView;//图片

@property (nonatomic, strong) LxmHomeGoodsBottomView *bottmView;//底部视图

@end
@implementation LxmHomeGoodsItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yingyinView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.goodsImgView];
        [self.bgView addSubview:self.bottmView];
        [self.yingyinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(8);
            make.bottom.trailing.equalTo(self).offset(-8);
        }];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(5);
            make.bottom.trailing.equalTo(self).offset(-5);
        }];
        [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@((ScreenW - 45)/2));
        }];
        [self.bottmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsImgView.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.bgView);
        }];
    }
    return self;
}

- (UIView *)yingyinView {
    if (!_yingyinView) {
        _yingyinView = [[UIView alloc] init];
        _yingyinView.backgroundColor = [UIColor whiteColor];
        _yingyinView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _yingyinView.layer.shadowRadius = 5;
        _yingyinView.layer.shadowOpacity = 0.5;
        _yingyinView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _yingyinView;
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

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.image = [UIImage imageNamed:@"tupian"];
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.layer.masksToBounds = YES;
    }
    return _goodsImgView;
}
- (LxmHomeGoodsBottomView *)bottmView {
    if (!_bottmView) {
        _bottmView = [[LxmHomeGoodsBottomView alloc] init];
        [_bottmView.shopCarButton addTarget:self action:@selector(addCardClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottmView;
}

- (void)setGoodsModel:(LxmHomeGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _bottmView.titleLabel.text = _goodsModel.good_name;
   
    if (self.isHaoCai) {
//        NSString * str = @"";
//        if (goodsModel.good_price.doubleValue == 0) {
//
//            str = [NSString stringWithFormat:@"%@积分",[goodsModel.score_price getPriceStr]];
//
//        }else {
//            if (goodsModel.score_price.doubleValue == 0) {
//                str = [NSString stringWithFormat:@"¥%@",[goodsModel.good_price getPriceStr]];
//            }else {
//                str = [NSString stringWithFormat:@"¥%@+%@积分",[goodsModel.good_price getPriceStr],[goodsModel.score_price getPriceStr]];
//            }
//        }
//
//        _bottmView.moneyLabel.attributedText = [str getMutableAttributeStringWithFont:14 lineSpace:0 textColor:MainColor fontTwo:12 nsrange:[str rangeOfString:@"¥"] fontThtree:12 nsrangethree:[str rangeOfString:@"积分"]];
        
        _bottmView.moneyLabel.attributedText = [@"" getjiFenOrMoneyWithPrice:goodsModel.good_price withSorce:goodsModel.score_price];
        
    }else {
        _bottmView.moneyLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.good_price];
    }
    
}

/**
 点击购物车按钮
 */
- (void)addCardClick {
    if (self.addCardClickBlock) {
        self.addCardClickBlock(self.goodsModel);
    }
}


@end


/**
 首页商品
 */
#import "LxmGoodsDetailVC.h"
#import "LxmShengJiVC.h"

#import "LxmRenZhengProtocolVC.h"
#import "LxmSafeAutherVC.h"

@interface LxmHomeGoodsCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) LxmHomeGoodsTypesModel *typeModel;

@end
@implementation LxmHomeGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((ScreenW - 25)/2, (ScreenW - 25)/2 + 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ((ScreenW - 25)/2 + 50 + 5)*ceil(6/2.0) + 20) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:LxmHomeGoodsItem.class forCellWithReuseIdentifier:@"LxmHomeGoodsItem"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeModel.goodList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeGoodsItem *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeGoodsItem" forIndexPath:indexPath];
    itemCell.goodsModel = self.typeModel.goodList[indexPath.item];
    WeakObj(self);
    itemCell.addCardClickBlock = ^(LxmHomeGoodsModel *goodsModel) {
        [selfWeak addCarClick:goodsModel];
    };
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmGoodsDetailVC *vc = [[LxmGoodsDetailVC alloc] init];
    vc.goodsID = self.typeModel.goodList[indexPath.item].id;
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(LxmHomeGoodsTypesModel *)model {
    _model = model;
    self.typeModel = _model;
    [self.collectionView reloadData];
}

/**
 添加购物车 如果没有角色 需要先升级 最少是高级门店才能购买货物
 */
- (void)addCarClick:(LxmHomeGoodsModel *)goodModel {
    if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
        
        [SVProgressHUD showErrorWithStatus: [NSString stringWithFormat:@"不属于%@商品，无法购买",[LxmTool ShareTool].roleTypeName]];
        
    
        
        return;
    }
    
    if ([LxmTool ShareTool].userModel.roleType.intValue == -1) {//没有身份 不能进行购买商品
        if ([LxmTool ShareTool].userModel.shopStatus.intValue == 2 || [LxmTool ShareTool].userModel.shopStatus.intValue == 6 ) {
//            addCarBlock();
            [self addCar:goodModel];
        } else {
            if ([LxmTool ShareTool].userModel.idCode.isValid) {//已实名认证
                if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 1) {//已读
                    LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
                } else if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 2){
                    //未读 跳转协议界面
                    LxmRenZhengProtocolVC *vc = [[LxmRenZhengProtocolVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isnext = YES;
                [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        [self addCar:goodModel];
    }
}

- (void)addCar:(LxmHomeGoodsModel *)goodModel {
    NSInteger shopStatus = LxmTool.ShareTool.userModel.shopStatus.intValue;
    if (shopStatus == 0 || shopStatus == 1 || shopStatus == 2 || shopStatus == 4 || shopStatus == 5) {//有升级中的状态 不能直接加入购物车 要提示进入升级通道
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"进入升级通道,下单更便宜哦!" message:@"是否进入升级通道?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
           vc.hidesBottomBarWhenPushed = YES;
           [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
        }]];
        [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
        
    } else {
        NSDictionary *dict = @{
                                  @"token" : SESSION_TOKEN,
                                  @"goodId" : goodModel.id,
                                  @"num" : @1
                                  };
           [SVProgressHUD show];
           [LxmNetworking networkingPOST:add_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
               [SVProgressHUD dismiss];
               if ([responseObject[@"key"] integerValue] == 1000) {
                   [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [LxmEventBus sendEvent:@"addCarSuccess" data:nil];
                   });
                   
               } else {
                   [UIAlertController showAlertWithmessage:responseObject[@"message"]];
               }
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               [SVProgressHUD dismiss];
           }];
    }
}

@end
