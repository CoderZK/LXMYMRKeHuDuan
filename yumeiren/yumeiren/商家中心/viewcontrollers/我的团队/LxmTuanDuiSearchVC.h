//
//  LxmTuanDuiSearchVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmTuanDuiSearchVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *type;

@end

@interface LxmTuanDuiSearchCell : UITableViewCell

@property (nonatomic, strong) LxmMyTeamListModel *model;

@property (nonatomic, copy) void(^seeKuCunBlock)(LxmMyTeamListModel *model);

@end
