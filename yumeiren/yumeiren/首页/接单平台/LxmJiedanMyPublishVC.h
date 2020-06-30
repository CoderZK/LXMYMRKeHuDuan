//
//  LxmJiedanMyPublishVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmJiedanMyPublishVC : BaseTableViewController

@end


/**
 订单编号
 */
@interface LxmJieDanOrderBianHaoCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, strong) LxmJieDanListModel *jieshouModel;

@end

/**
 服务类型加右测价格
 */
@interface LxmJieDanOrderServiceTypeAndMoneyCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, strong) LxmJieDanListModel *jiedanModel;

@property (nonatomic, strong) LxmJieDanListModel *detailModel;

@end

/**
 只有一个label
 */
@interface LxmJieDanOrderLabelCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) LxmJieDanListModel *jieshouModel;//我接收的单子

@property (nonatomic, strong) LxmJieDanListModel *detailModel;//详情加价至

@end

/**
 带有评价图cell
 */
@interface LxmJieDanMyCenterCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@end
/**
 接单人cell
 */
@interface LxmJieDanRenCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@end
/**
 Button
 */
@interface LxmJieDanMyBottomCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, strong) LxmJieDanListModel *jiedanModel;//接单大厅

@property (nonatomic, strong) LxmJieDanListModel *jieshouModel;//我接收的单子

@property (nonatomic, copy) void(^bottomButtonActionBlock)(NSInteger index,LxmJieDanListModel *model);

@end
