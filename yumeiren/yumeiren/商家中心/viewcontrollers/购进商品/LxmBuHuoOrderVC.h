//
//  LxmBuHuoOrderVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmBuHuoOrderVC : BaseTableViewController

@end


/// 一键补货
@interface LxmBuHuoOrderBottomView : UIView

@property (nonatomic, copy) void(^yijianClickBlock)(void);

@end
