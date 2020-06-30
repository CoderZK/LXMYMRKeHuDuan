//
//  LxmMyHongBaoVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyHongBaoVC : BaseTableViewController

@end

@interface LxmMyHongBaoSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@end

/**
 cell
 */
@interface LxmMyHongBaoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) LxmMyHongBaoModel *model;

@property (nonatomic, strong) LxmJiYiRecordModel *baozhengjinModel;

@end
