//
//  LxmSeeOtherKuCunVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSeeOtherKuCunVC : BaseTableViewController

@property (nonatomic, strong) LxmMyTeamListModel *model;

@end

@interface LxmSeeOtherKuCunCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterModel *model;

@end
