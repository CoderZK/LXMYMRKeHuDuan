//
//  LxmJiaoNaBaoZhengJinVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmJiaoNaBaoZhengJinVC : BaseTableViewController

@property (nonatomic, strong) LxmShengjiModel *model;

@property (nonatomic, assign) BOOL isBuJiao;//是否是补交保证金

@property (nonatomic, strong) NSString *recommend_code;//推荐码

@end


@interface LxmJiaoNaBaoZhengJinHeaderView : UIView

@property (nonatomic, strong) UIView *shaowView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImgView;//角色图标

@property (nonatomic, strong) UILabel *moneyLabel;//保证金

@property (nonatomic, strong) UIView *leftLineView;//左侧线

@property (nonatomic, strong) UILabel *titleLabel;//保证金说明

@property (nonatomic, strong) UIView *rightLineView;//右侧线

@property (nonatomic, strong) IQTextView *detailTextView;//说明

@property (nonatomic, strong) UIButton *shengjiButton;//去升级 // 申请审核 已申请 申请成功可升级

@end
