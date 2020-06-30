//
//  LxmYeJiVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmYeJiVC : BaseViewController

@end

@interface LxmYeJiTopView : UIView

@property (nonatomic, strong) LxmMyYeJiModel *model;

@property (nonatomic, copy) void(^selectYearAndMonth)(NSString *yearMonth);

@end
