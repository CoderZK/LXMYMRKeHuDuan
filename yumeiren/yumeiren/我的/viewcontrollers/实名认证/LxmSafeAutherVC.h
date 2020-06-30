//
//  LxmSafeAutherVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmSafeAutherVC : BaseTableViewController

@property (nonatomic, assign) BOOL isnext;//页面按钮是否显示下一步

@property (nonatomic, copy) void(^rezhengBlock)(void);

@end

NS_ASSUME_NONNULL_END
