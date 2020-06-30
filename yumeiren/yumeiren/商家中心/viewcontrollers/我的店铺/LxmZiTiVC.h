//
//  LxmZiTiVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmZiTiVC : BaseTableViewController

@property (nonatomic, assign) BOOL isJinHuodan;//是否是进货单页面

@end

//自提cell
@interface LxmZiTiCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterModel *model;

@property (nonatomic, copy) void(^selectClick)(LxmShopCenterModel *model);

@end
