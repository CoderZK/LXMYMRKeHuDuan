//
//  LxmBuHuoDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmBuHuoDetailVC : BaseTableViewController

@property (nonatomic, assign) bool isHiddenBottom;//是否展示底部按钮

@property (nonatomic, strong) NSString *orderID;/* 补货订单id */

@property (nonatomic, copy) void(^readBlock)(void);

@end

NS_ASSUME_NONNULL_END
