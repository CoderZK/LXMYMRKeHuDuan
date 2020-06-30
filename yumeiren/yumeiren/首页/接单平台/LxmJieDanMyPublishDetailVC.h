//
//  LxmJieDanMyPublishDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmJieDanMyPublishDetailVC : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@property (nonatomic, strong) LxmJieDanListModel *model;

@end

/**
 底部按钮
 */
@interface LxmJieDanMyPublishDetailBottomView : UIView

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, strong) LxmJieDanListModel *jieshouModel;

@property (nonatomic, copy) void(^bottomButtonActionBlock)(NSInteger index,LxmJieDanListModel *model);

@end
