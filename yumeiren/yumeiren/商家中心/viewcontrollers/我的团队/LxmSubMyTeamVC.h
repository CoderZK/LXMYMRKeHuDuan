//
//  LxmSubMyTeamVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSubMyTeamVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *type;//1-直属，2-非直属

@end

@interface LxmSubMyTeamCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) LxmMyTeamListModel *model;

@property (nonatomic, copy) void(^seeKuCunBlock)(LxmMyTeamListModel *model);

@property (nonatomic, copy) void(^seeOtherInfoBlock)(LxmMyTeamListModel *model);

@end

