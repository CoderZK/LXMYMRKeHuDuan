//
//  LxmYiJianBuHuoVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmYiJianBuHuoVC : BaseTableViewController

@property (nonatomic, strong) LxmShopCenterOrderModel *model;

@end

/**
 一键补货 补货单
 */
@interface LxmYiJianBuHuoDanCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//选择按钮

@property (nonatomic, assign) bool isHaveSelect;//是否有选择按钮

@end

@interface LxmYiJianBuHuoOrderCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;

@property (nonatomic, strong) LxmShopCenterOrderModel *orderRenModel;

@property (nonatomic, assign) bool isHaveSelect;//是否有选择按钮

@end



@interface LxmYiJianBuHuoRenOrderCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;

@end


@interface LxmYiJianBuHuoGoodsCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderGoodsModel *orderModel;//

@property (nonatomic, assign) bool isHaveSelect;//是否有选择按钮

@end

@interface LxmYiJianBuHuoDanFootView : UIControl

@end

//本地购物车cell
@interface LxmLocalGoodsCell : UITableViewCell

@property (nonatomic, strong) LxmHomeGoodsModel *goodsModel;

@property (nonatomic, copy) void(^selectClick)(LxmHomeGoodsModel *goodsModel);

@property (nonatomic, copy) void(^modifySuccessBlock)(LxmHomeGoodsModel *goodsModel);

@end


//本地购物车cell
@interface LxmLocalGoodsCell1 : UITableViewCell

@property (nonatomic, strong) LxmHomeGoodsModel *goodsModel;

@property (nonatomic, copy) void(^selectClick)(LxmHomeGoodsModel *goodsModel);

@property (nonatomic, copy) void(^modifySuccessBlock)(LxmHomeGoodsModel *goodsModel);

@end
