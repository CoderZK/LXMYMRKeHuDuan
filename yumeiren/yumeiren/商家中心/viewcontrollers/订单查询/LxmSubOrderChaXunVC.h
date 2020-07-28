//
//  LxmSubOrderChaXunVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, LxmSubOrderChaXunVC_type) {
    LxmSubOrderChaXunVC_type_shopCenter,
    LxmSubOrderChaXunVC_type_userCenter
};

@interface LxmSubOrderChaXunVC : BaseTableViewController

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmSubOrderChaXunVC_type)type;

@property (nonatomic, strong) NSNumber *status;//0-全部，1：待支付，2：待发货，3：待确认收货，4：已完成，5：已取消

@property(nonatomic,assign)BOOL isHaoCai;

@end

/**
 地址
 */
@interface LxmSubOrderChaXunAddressCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterOrderModel *orderModel;//商家中心 发货订单

@property (nonatomic, copy) void(^modifyAddressClick)(LxmShopCenterOrderModel *orderModel);

@end


@interface LxmModifyButton : UIButton

@end
