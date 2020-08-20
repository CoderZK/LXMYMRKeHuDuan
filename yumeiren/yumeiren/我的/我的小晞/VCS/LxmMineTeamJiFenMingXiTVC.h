//
//  LxmMineTeamJiFenMingXiTVC.h
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmMineTeamJiFenMingXiTVC : BaseTableViewController
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,assign)NSInteger scoreType;
@property(nonatomic,strong)LxmMyTeamListModel  *jifenModel;
@end

NS_ASSUME_NONNULL_END
