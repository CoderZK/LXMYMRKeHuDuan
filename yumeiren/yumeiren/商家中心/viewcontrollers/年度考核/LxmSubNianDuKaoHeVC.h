//
//  LxmSubNianDuKaoHeVC.h
//  yumeiren
//
//  Created by 李晓满 on 2020/4/22.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSubNianDuKaoHeVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *type;

@end

//
@interface LxmSubNianDuKaoHeCell : UITableViewCell

@property (nonatomic, strong) LxmNianDuKaoHeModel *model;

@end
