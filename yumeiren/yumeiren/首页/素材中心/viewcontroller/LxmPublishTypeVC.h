//
//  LxmPublishTypeVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmPublishTypeVC : BaseTableViewController

@property (nonatomic, copy) void(^contentTypeSelectBlock)(LxmSuCaiContentTypeListModel *model);

@property (nonatomic, strong) NSString *contentID;

@end

NS_ASSUME_NONNULL_END
