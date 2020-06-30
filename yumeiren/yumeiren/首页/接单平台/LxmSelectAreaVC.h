//
//  LxmSelectAreaVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/27.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSelectAreaVC : BaseTableViewController

@property (nonatomic, strong) NSString *city;

@property (nonatomic, copy) void(^didSelectCity)(NSString *city);

@end

