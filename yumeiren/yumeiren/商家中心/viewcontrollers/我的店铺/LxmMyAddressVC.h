//
//  LxmMyAddressVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyAddressVC : BaseTableViewController

@property (nonatomic, copy) void(^didselectedAddressBlock)(LxmAddressModel *model);

@end

/**
 我的地址cell
 */
@interface LxmMyAddressCell : UITableViewCell

@property (nonatomic, strong) LxmAddressModel *model;

@property (nonatomic, copy) void(^modeifyCurrentAddressBlock)(LxmAddressModel *model);

@end
