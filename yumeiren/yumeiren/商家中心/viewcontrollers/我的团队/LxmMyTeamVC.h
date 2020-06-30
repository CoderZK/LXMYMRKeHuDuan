//
//  LxmMyTeamVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseViewController.h"
#import "LxmMineVC.h"

@interface LxmMyTeamVC : BaseTableViewController

@end

/**
 导航栏
 */
@interface LxmMyTeamNavView : UIView

@property (nonatomic, strong) UIButton *leftButton;//左侧按钮

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIButton *rightButton;//右侧按钮

@end


typedef NS_ENUM(NSInteger, LxmMyTeamTopView_style) {
    LxmMyTeamTopView_style_myTeam,
    LxmMyTeamTopView_style_otherInfo,
    LxmMyTeamTopView_style_qianbao
};

@interface LxmMyTeamDetailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@end



@interface LxmMyTeamTopView : UIView

@property (nonatomic, strong) LxmMyTeamModel *teamModel;//我的团队

@property (nonatomic, strong) LxmSeeOtherInfoModel *otherInfoModel;//查看他人信息

@property (nonatomic, strong) LxmUserInfoModel *infoModel;//LxmMyTeamTopView_style_qianbao

@property (nonatomic, strong) LxmMyTeamDetailView *bottomView;

@property (nonatomic, strong) LxmQianBaoTopView *bottomView2;

- (instancetype)initWithFrame:(CGRect)frame style:(LxmMyTeamTopView_style)style;

@end
