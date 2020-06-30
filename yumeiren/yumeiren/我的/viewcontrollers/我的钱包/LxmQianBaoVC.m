//
//  LxmQianBaoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmQianBaoVC.h"
#import "LxmMyTeamVC.h"
#import "LxmChongZhiVC.h"
#import "LxmTiXianVC.h"
#import "LxmZhuanZhangVC.h"
#import "LxmJiaoYIRecordVC.h"
#import "LxmXiaoShouIncomeVC.h"

@interface LxmQianBaoVC ()

@property (nonatomic, strong) LxmMyTeamNavView *navView;//导航栏

@property (nonatomic, strong) LxmMyTeamTopView *topView;//顶部视图

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LxmUserInfoModel *model;//我的红包界面用到的

@end

@implementation LxmQianBaoVC

- (LxmMyTeamNavView *)navView {
    if (!_navView) {
        _navView = [[LxmMyTeamNavView alloc] init];
        _navView.titleLabel.hidden = YES;
        [_navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _navView.rightButton.hidden = YES ;
    }
    return _navView;
}

- (LxmMyTeamTopView *)topView {
    if (!_topView) {
        _topView = [[LxmMyTeamTopView alloc] initWithFrame:CGRectZero style:LxmMyTeamTopView_style_qianbao];
    }
    return _topView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadQianbaoData];
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
    
    
    
    //市级及以上有 提现 转账按钮
    if ([LxmTool ShareTool].userModel.roleType.intValue < 2) {
        [self.topView.bottomView2.centerButton addTarget:self action:@selector(chongzhiClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.topView.bottomView2.leftButton addTarget:self action:@selector(chongzhiClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.bottomView2.centerButton addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.bottomView2.rightButton addTarget:self action:@selector(zhuanZhangClick) forControlEvents:UIControlEventTouchUpInside];
    }
}



- (void)refreshInfo {
    WeakObj(self);
    [self loadMyUserInfoWithOkBlock:^{
        selfWeak.topView.infoModel = [LxmTool ShareTool].userModel;
        [selfWeak.tableView reloadData];
    }];
}

/**
 添加视图
 */
- (void)initSubviews {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.navView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 215));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmQianBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmQianBaoCell"];
    if (!cell) {
        cell = [[LxmQianBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmQianBaoCell"];
    }
    if (indexPath.row == 0) {
        cell.iconImgView.image = [UIImage imageNamed:@"wdqb_jyjl"];
        cell.titleLabel.text = @"交易记录";
        cell.detailLabel.hidden = YES;
    } else {
        cell.iconImgView.image = [UIImage imageNamed:@"wdqb_xssr"];
        cell.detailLabel.hidden = NO;
        cell.titleLabel.text = @"销售收入";
        cell.detailLabel.text = [NSString stringWithFormat:@"¥%@",self.model.inMoney];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LxmJiaoYIRecordVC *vc = [[LxmJiaoYIRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LxmXiaoShouIncomeVC *vc = [[LxmXiaoShouIncomeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 充值
 */
- (void)chongzhiClick {
    LxmChongZhiVC *vc = [[LxmChongZhiVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 提现
 */
- (void)tixianClick {
    if ([LxmTool ShareTool].userModel.roleType.intValue >= 2) {
        LxmTiXianVC *vc = [[LxmTiXianVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [UIAlertController showAlertWithmessage:@"市级及以上门店可申请提现!"];
    }
}

/**
 转账
 */
- (void)zhuanZhangClick {
    LxmZhuanZhangVC *vc = [[LxmZhuanZhangVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadQianbaoData {
    if (!self.model) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:balance_info parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            NSDictionary *dic = responseObject[@"result"][@"map"];
            if ([dic isKindOfClass:NSDictionary.class]) {
                selfWeak.model = [LxmUserInfoModel mj_objectWithKeyValues:dic];
                selfWeak.topView.infoModel = selfWeak.model;
                [selfWeak.tableView reloadData];
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end

@interface LxmQianBaoCell ()

@property (nonatomic, strong) UIImageView *accimgView;

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmQianBaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.accimgView];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accimgView.mas_leading).offset(-10);
        make.centerY.equalTo(self);
    }];
    [self.accimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textColor = CharacterDarkColor;
    }
    return _detailLabel;
}

- (UIImageView *)accimgView {
    if (!_accimgView) {
        _accimgView = [UIImageView new];
        _accimgView.image = [UIImage imageNamed:@"next"];
    }
    return _accimgView;
}

@end
