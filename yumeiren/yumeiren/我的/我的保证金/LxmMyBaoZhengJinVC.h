//
//  LxmMyBaoZhengJinVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyBaoZhengJinVC : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@end


@interface LxmMyBaoZhengJinCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLabel;

@end
