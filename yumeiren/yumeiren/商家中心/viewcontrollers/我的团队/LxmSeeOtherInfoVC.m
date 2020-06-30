//
//  LxmSeeOtherInfoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSeeOtherInfoVC.h"
#import "LxmMyTeamVC.h"
#import "LxmUserInfoView.h"
#import "LxmJieDanPublishVC.h"

@interface LxmSeeOtherInfoVC ()

@property (nonatomic, strong) LxmMyTeamNavView *navView;//导航栏

@property (nonatomic, strong) LxmMyTeamTopView *topView;//顶部视图

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LxmUserCodeCell *wechatCell;//微信号

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *tjrCell;//推荐人

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *sjCell;//上级

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *byxsCell;//本月销售

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *ljxsCell;//本月累计销售

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmSeeOtherInfoModel *infoModel;

@end

@implementation LxmSeeOtherInfoVC

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (LxmUserCodeCell *)wechatCell {
    if (!_wechatCell) {
        _wechatCell = [[LxmUserCodeCell alloc] init];
        _wechatCell.titleLabel.text = @"微信号";
        _wechatCell.detailLabel.text = @"dddddddd";
    }
    return _wechatCell;
}

- (LxmJieDanPublishTextFieldCell *)tjrCell {
    if (!_tjrCell) {
        _tjrCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _tjrCell.titleLabel.text = @"推荐人";
//        _tjrCell.textField.text = @"巴啦啦";
        _tjrCell.textField.userInteractionEnabled = NO;
    }
    return _tjrCell;
}

- (LxmJieDanPublishTextFieldCell *)sjCell {
    if (!_sjCell) {
        _sjCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _sjCell.titleLabel.text = @"上级";
//        _sjCell.textField.text = @"青稞侠";
        _sjCell.textField.userInteractionEnabled = NO;
    }
    return _sjCell;
}

- (LxmJieDanPublishTextFieldCell *)byxsCell {
    if (!_byxsCell) {
        _byxsCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _byxsCell.titleLabel.text = @"本月销售";
//        _byxsCell.textField.text = @"¥14758.00";
        _byxsCell.textField.userInteractionEnabled = NO;
    }
    return _byxsCell;
}

- (LxmJieDanPublishTextFieldCell *)ljxsCell {
    if (!_ljxsCell) {
        _ljxsCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _ljxsCell.titleLabel.text = @"累计销售";
//        _ljxsCell.textField.text = @"¥449281.00";
        _ljxsCell.textField.userInteractionEnabled = NO;
    }
    return _ljxsCell;
}

- (LxmMyTeamNavView *)navView {
    if (!_navView) {
        _navView = [[LxmMyTeamNavView alloc] init];
        _navView.titleLabel.text = @"查看他人信息";
        [_navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _navView.rightButton.hidden = YES ;
    }
    return _navView;
}

- (LxmMyTeamTopView *)topView {
    if (!_topView) {
        _topView = [[LxmMyTeamTopView alloc] initWithFrame:CGRectZero style:LxmMyTeamTopView_style_otherInfo];
    }
    return _topView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self initSubviews];
    [self setConstrains];
    self.contentView.frame = CGRectMake(0, 0, ScreenW, 50 * 5 + 20);
    self.tableView.tableHeaderView = self.contentView;
    [self loadUserInfo];
}

/**
 添加视图
 */
- (void)initSubviews {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.navView];
    [self.contentView addSubview:self.wechatCell];
    [self.contentView addSubview:self.tjrCell];
    [self.contentView addSubview:self.sjCell];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.byxsCell];
    [self.contentView addSubview:self.ljxsCell];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 165));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    
    [self.wechatCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.tjrCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.sjCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tjrCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sjCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
    [self.byxsCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.ljxsCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.byxsCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}
/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 查看他人信息
 */
- (void)loadUserInfo {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:other_info parameters:@{@"token":SESSION_TOKEN,@"userId":self.model.id} returnClass:LxmSeeOtherInfoRootModel.class success:^(NSURLSessionDataTask *task, LxmSeeOtherInfoRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.infoModel = responseObject.result.map;
            selfWeak.topView.otherInfoModel = selfWeak.infoModel;
            if (selfWeak.infoModel.chatCode.isValid) {
                _wechatCell.detailLabel.text = selfWeak.infoModel.chatCode;
                [selfWeak.wechatCell mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.trailing.equalTo(self.contentView);
                    make.height.equalTo(@50);
                }];
            } else {
                [selfWeak.wechatCell mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.trailing.equalTo(self.contentView);
                    make.height.equalTo(@0);
                }];
            }
            
            _sjCell.textField.text = selfWeak.infoModel.firstName;
            _tjrCell.textField.text = selfWeak.infoModel.recommendName;
            _byxsCell.textField.text = [NSString stringWithFormat:@"¥%.2f",selfWeak.infoModel.monthM.doubleValue];
            _ljxsCell.textField.text =  [NSString stringWithFormat:@"¥%.2f",selfWeak.infoModel.totalM.doubleValue];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
