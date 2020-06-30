//
//  LxmSeeOtherInfoVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmSeeOtherInfoVC : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@property (nonatomic, strong) LxmMyTeamListModel *model;

@end

NS_ASSUME_NONNULL_END
