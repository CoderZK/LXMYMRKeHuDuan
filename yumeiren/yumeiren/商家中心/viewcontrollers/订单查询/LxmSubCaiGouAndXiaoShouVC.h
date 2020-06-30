//
//  LxmSubBuHuoCaiGouAndXiaoShouVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmSubCaiGouAndXiaoShouVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *type;//1-发货订单，2-批发销售，3-批发采购

@property (nonatomic, strong) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
