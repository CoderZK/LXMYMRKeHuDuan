//
//  LxmJieDanListViewController.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmJieDanListViewController : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@property (nonatomic, strong) NSString *city;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger allPageNum;

- (void)loadData;

@end

@interface LxmJieDanListRenCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, strong) LxmJieDanListModel *jieshouModel;

@property (nonatomic, strong) LxmJieDanListModel *detailModel;

@end
