//
//  LxmJianFeiShengJiVC.h
//  yumeiren
//
//  Created by 李晓满 on 2020/2/26.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmJianFeiShengJiVC : BaseTableViewController

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSMutableArray <LxmShengjiModel *>*jianfeiArr;//减肥单项数组

@end

NS_ASSUME_NONNULL_END
