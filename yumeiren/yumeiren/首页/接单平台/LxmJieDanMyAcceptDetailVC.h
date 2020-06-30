//
//  LxmJieDanMyAcceptDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmJieDanMyAcceptDetailVC : BaseTableViewController

@property (nonatomic, strong) LxmJieDanListModel *model;

@property (nonatomic, copy) void(^readBlock)(void);

@end

/**
 退单原因和图片
 */
@interface LxmJieDanMyAcceptDetailImgCell : UITableViewCell

@property (nonatomic, strong) LxmJieDanListModel *model;


@end
