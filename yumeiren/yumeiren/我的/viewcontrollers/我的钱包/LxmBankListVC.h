//
//  LxmSelectBankVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmBankListVC : BaseTableViewController

@property (nonatomic, strong) void(^selectBankModelBlock)(LxmMyBankModel *model);

@end


