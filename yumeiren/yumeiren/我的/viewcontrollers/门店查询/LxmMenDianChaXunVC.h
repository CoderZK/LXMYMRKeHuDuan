//
//  LxmMenDianChaXunVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LxmMenDianChaXunVC : BaseTableViewController

@end


/**
 顶部输入view
 */
@interface LxmMenDianChaXunView : UIView

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *putinView;//输入view

@property (nonatomic, strong) UITextField *putinTF;//输入Tf

@property (nonatomic, strong) UIButton *rightButton;//右侧清空按钮

@end

/**
 cell
 */
@interface LxmMenDianChaXunCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) LxmMenDianChaXunListModel *model;

@end
