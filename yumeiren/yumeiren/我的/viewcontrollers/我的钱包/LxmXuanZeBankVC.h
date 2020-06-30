//
//  LxmXuanZeBankVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmXuanZeBankVC : BaseTableViewController

@property (nonatomic, strong) LxmBankModel *currentModel;

@property (nonatomic, copy) void(^selectBankModelBlock)(LxmBankModel *model);

@end


