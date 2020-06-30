//
//  LxmShengJiTiaoJianVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmMyTeamVC.h"
#import "LxmLoginView.h"

@interface LxmCenterButton : UIView
@property (nonatomic, strong) UIButton *oneButton;//第一步

@property (nonatomic, strong) UIButton *secondButton;//第二步

@end

@interface LxmShengJiTiaoJianVC : BaseTableViewController

@property (nonatomic, strong) LxmShengjiModel *model;//升级model

@property (nonatomic, strong) NSString *orderID;//无身份已下单 的订单号

@end

@interface LxmShengJiTiaoJianHeaderView : UIView

@property (nonatomic, strong) UIView *shaowView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImgView;//角色图标

@property (nonatomic, strong) UIView *leftLineView;//左侧线

@property (nonatomic, strong) UILabel *titleLabel;//升级条件

@property (nonatomic, strong) UIView *rightLineView;//右侧线

@property (nonatomic, strong) LxmCenterButton *centerBtn;

@property (nonatomic, strong) LxmAgreeButton *agreeButton;//同意协议

@property (nonatomic, strong) UIButton *shengjiButton;//去升级 // 申请审核 已申请 申请成功可升级

@property (nonatomic, strong) UIButton *cancelShengjiButton;//取消升级

@property (nonatomic, assign) BOOL isHiddleCancel;//是否隐藏取消升级按钮

@end
