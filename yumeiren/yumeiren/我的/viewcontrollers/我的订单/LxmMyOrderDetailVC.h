//
//  LxmMyOrderDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyOrderDetailVC : BaseTableViewController

@property (nonatomic, strong) NSString *orderID;/* 订单号 */

@property (nonatomic, strong) NSString *postage_code;/* 物流单号 */

@end

