//
//  LxmJieSuanView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmJieSuanView : UIView

@end

@interface LxmJieSuanBottomView : UIView

@property (nonatomic, strong) UILabel *moneyLabel;//实付金额

@property (nonatomic, copy) void(^tijiaoBlock)(void);



@end

/**
 选择配送方式
 */
@interface LxmJieSuanPeiSongStyleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//配送方式

@property (nonatomic, strong) UILabel *styleLabel;//方式

@end

/**
 配送商品
 */
@interface LxmJieSuanPeiSongGoodsCell : UITableViewCell

@property (nonatomic, strong) LxmShopCarModel *model;//商品

@property (nonatomic, strong) LxmShopCenterOrderGoodsModel *orderDetailGoodsModel;//订单查询 详情

@property (nonatomic, strong) LxmShopCenterOrderGoodsModel *orderModel;//商家中心 发货订单

@end

/**
数量 商品价格
 */
@interface LxmJieSuanPeiSongInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) UILabel *detailLabel;//

@end

/**
 收货地址
 */
@interface LxmJieSuanPeiSongAddressCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) LxmAddressModel *addressModel;

@end

/// 结算活动商品cell
@interface LxmAcGoodsCell : UITableViewCell

@property (nonatomic, strong) LxmAcGoodsModel *model;

@property (nonatomic, strong) LxmShopCenterAcGoodsModel *detailGoodsModel;

@end

@interface LxmNoteCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) UILabel *detailLabel;//

@end
