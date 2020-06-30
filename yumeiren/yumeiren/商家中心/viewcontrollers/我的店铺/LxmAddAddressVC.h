//
//  LxmAddAddressVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmAddAddressVC : BaseTableViewController

@property (nonatomic, strong) LxmAddressModel *model;

@end


@interface  LxmAddAddressSelectCell: UIControl

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *detailLabel;//详细

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) UIView *lineView;//线

@end
