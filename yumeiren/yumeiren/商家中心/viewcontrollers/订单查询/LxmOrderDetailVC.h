//
//  LxmOrderDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmOrderDetailVC : BaseTableViewController

@property (nonatomic, assign) bool isHiddenBottom;//是否展示底部按钮

@property (nonatomic, assign) BOOL iscaiGouandXiaoshou;

@property (nonatomic, strong) NSString *orderID;/* 订单号 */

@property (nonatomic, copy) void(^readBlock)(void);

@property (nonatomic, assign) BOOL isShengji;//无身份 升级中的单子

@end


/**
 商品详情 底部操作按钮
 */
@interface LxmOrderDetailBottomView : UIView

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) LxmShopCenterOrderModel *model;

@property (nonatomic, copy) void(^gotobuhuoBlock)(void);

@property (nonatomic, copy) void(^tuidanBlock)(void);

@end
