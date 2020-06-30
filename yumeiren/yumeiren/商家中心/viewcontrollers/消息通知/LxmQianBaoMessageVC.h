//
//  LxmQianBaoMessageVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmQianBaoMessageVC : BaseTableViewController

@property (nonatomic, strong) NSString *infoType;

@end

@interface LxmQianBaoMessageCell : UITableViewCell

@property (nonatomic, strong) LxmMsgModel *msgModel;

@property (nonatomic, copy) void(^hongbaoxiaoxiBlock)(LxmMsgModel *msgModel);

@end
