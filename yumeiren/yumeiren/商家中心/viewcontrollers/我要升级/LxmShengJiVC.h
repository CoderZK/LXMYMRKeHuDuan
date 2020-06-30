//
//  LxmShengJiVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmShengJiVC : BaseTableViewController

@end


/**
 升级cell
 */
@interface LxmShengJiCell : UITableViewCell

@property (nonatomic, strong) LxmShengjiModel *model;//升级model

@property (nonatomic, strong) LxmShengjiModel *jianfeiModel;//减肥单项model

@end
