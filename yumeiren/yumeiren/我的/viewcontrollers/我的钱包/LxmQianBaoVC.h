//
//  LxmQianBaoVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmQianBaoVC : BaseTableViewController

@property (nonatomic, copy) void(^readBlock)(void);

@end

@interface LxmQianBaoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *detailLabel;//

@end
