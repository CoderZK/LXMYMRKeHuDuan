//
//  LxmYiJianBuHuoVC1.h
//  yumeiren
//
//  Created by 李晓满 on 2019/10/31.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmShopCarView.h"

@interface LxmYiJianBuHuoVC1 : BaseTableViewController

@property (nonatomic, strong) LxmShopCenterOrderModel *model;

@end


@interface LxmYiJianBuHuoCell1 : UITableViewCell

@property (nonatomic, strong) LxmShopCenterModel *buhuoModel;

@property (nonatomic, copy) void(^incOrDecClickBlock)(void);

@end


@interface LxmYiJianBuHuoBottom1 : UIView

@property (nonatomic, strong) UILabel *shifuLabel;/* 实付金额 */

@property (nonatomic, copy) void(^bottomBuhuoClickBlock)(void);

@end

