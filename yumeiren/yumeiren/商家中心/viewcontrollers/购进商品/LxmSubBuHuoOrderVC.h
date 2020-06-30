//
//  LxmSubBuHuoOrderVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSubBuHuoOrderVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *status;

@end

/**
 补货视图
 */
@interface LxmSubBuHuoOrderTopCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;//商家中心 发货订单

@end

@interface LxmSubBuHuoOrderPriceCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;//商家中心 发货订单

@property (nonatomic, assign) BOOL isDaiBuHuo;

@property (nonatomic, strong) NSString *shifujineMoney;//订单查询 详情

@end

@interface LxmSubBuHuoOrderButtonCell : UITableViewCell

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;//商家中心 发货订单

@property (nonatomic, copy) void(^gotobuhuoBlock)(void);

@property (nonatomic, copy) void(^tuidanBlock)(void);

@property (nonatomic, copy) void(^deleteorderBlock)(void);

@end
