//
//  LxmTouSuDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmTouSuDetailVC : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@property (nonatomic, strong) NSString *ID;//投诉id

@end

NS_ASSUME_NONNULL_END
