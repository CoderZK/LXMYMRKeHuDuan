//
//  LxmSubYeJiVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSubYeJiVC : BaseTableViewController

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString *currentTime;//当前月份

@property (nonatomic, assign) NSInteger page;

- (void)loadData;

@end

@interface LxmYeJiCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) LxmMyYeJiListModel *yejiModel;

@end
