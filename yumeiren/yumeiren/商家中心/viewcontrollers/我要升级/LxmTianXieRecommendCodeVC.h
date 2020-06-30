//
//  LxmTianXieRecommendCodeVC.h
//  yumeiren
//
//  Created by 李晓满 on 2020/3/6.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmTianXieRecommendCodeVC : BaseTableViewController

@property (nonatomic, copy) void(^recommendCodeBlock)(NSString *code);

@end

NS_ASSUME_NONNULL_END
