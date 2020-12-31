//
//  LxmShengJiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShengJiVC.h"
#import "LxmShengJiTiaoJianVC.h"
#import "LxmJianFeiShengJiVC.h"

@interface LxmShengJiVC ()

@property (nonatomic, strong) LxmShengjiRootModel *model;

@property (nonatomic, strong) NSString *preRoleType;

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSMutableArray <LxmShengjiModel *>*jianfeiArr;//小红包系列数组

@property (nonatomic, strong) NSMutableArray <LxmShengjiModel *>*otherArr;//其他等级数组

@end

@implementation LxmShengJiVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_jianbian2"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:UIColor.whiteColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    void(^roleBlock)(void) = ^(void){
        
        if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.5"]){
            self.navigationItem.title = @" 当前等级-小红包系列-vip会员 ";
        } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.4"]) {
            self.navigationItem.title = @" 当前等级-小红包系列-高级会员 ";
        } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.3"]) {
            self.navigationItem.title = @" 当前等级-小红包系列-荣誉会员 ";
        } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"1.1"]) {
            self.navigationItem.title = @" 当前等级-小红包系列-市服务商 ";
        } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"2.1"]) {
            self.navigationItem.title = @" 当前等级-小红包系列-省服务商 ";
        } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"3.1"]) {
            self.navigationItem.title = @" 当前等级-小红包系列-CEO";
        } else {
            if ([LxmTool ShareTool].userModel.roleType.floatValue == -1) {
                self.navigationItem.title = @"当前等级-无";
            } else if ([LxmTool ShareTool].userModel.roleType.floatValue == 0){
                self.navigationItem.title = @"当前等级-vip门店";
            } else if ([LxmTool ShareTool].userModel.roleType.floatValue == 1){
                self.navigationItem.title = @"当前等级-高级门店";
            } else if ([LxmTool ShareTool].userModel.roleType.floatValue == 2){
                self.navigationItem.title = @"当前等级-市服务商";
            } else if ([LxmTool ShareTool].userModel.roleType.floatValue == 3){
                self.navigationItem.title = @"当前等级-省服务商";
            } else if ([LxmTool ShareTool].userModel.roleType.floatValue == 4){
                self.navigationItem.title = @"当前等级-CEO";
            }
        }
    };
    WeakObj(self);
    [selfWeak loadMyUserInfoWithOkBlock:^{
        roleBlock();
    }];
    [selfWeak loadRoleInfo];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbarwhite"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = CharacterDarkColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:CharacterDarkColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = CharacterDarkColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.jianfeiArr = [NSMutableArray array];
    self.otherArr = [NSMutableArray array];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.otherArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShengJiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmShengJiCell"];
    if (!cell) {
        cell = [[LxmShengJiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmShengJiCell"];
    }
    cell.model = self.otherArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmShengjiModel *model = self.otherArr[indexPath.section];
    
    if ([model.roleType isEqualToString:@"-0.5"]) {
        if ([LxmTool.ShareTool.userModel.roleType isEqualToString:@"0"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.05"]) {
            return;
        }
        LxmJianFeiShengJiVC *vc = [[LxmJianFeiShengJiVC alloc] init];
        vc.orderID = self.orderID;
        vc.jianfeiArr = self.jianfeiArr;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (model.inStatus.intValue == 7 || model.inStatus.intValue == 8) {
            return;
        }
        
        bool ishave = NO;
        LxmShengjiModel *temp = nil;
        for (LxmShengjiModel *model in self.otherArr) {
            if (model.inStatus.intValue < 6) {
                ishave = YES;
                temp = model;
                break;
            }
        }
        if (ishave) {
            if (temp == model) {
                LxmShengJiTiaoJianVC *vc = [[LxmShengJiTiaoJianVC alloc] init];
                vc.model = model;
                vc.orderID = self.orderID;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"你当前有正在升级的状态,请先完成升级"];
                return;
            }
        } else {
            LxmShengJiTiaoJianVC *vc = [[LxmShengJiTiaoJianVC alloc] init];
            vc.model = model;
            vc.orderID = self.orderID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

/**
 查看升级状态和升级条件信息
 */
- (void)loadRoleInfo {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:get_role_info parameters:@{@"token":SESSION_TOKEN} returnClass:LxmShengjiRootModel.class success:^(NSURLSessionDataTask *task, LxmShengjiRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            selfWeak.orderID = responseObject.result.data;
            selfWeak.model = responseObject;
            [selfWeak.otherArr removeAllObjects];
            [selfWeak.jianfeiArr removeAllObjects];
            for (LxmShengjiModel *m in selfWeak.model.result.list) {
                if ([m.roleType isEqualToString:@"-0.3"] || [m.roleType isEqualToString:@"-0.4"] || [m.roleType isEqualToString:@"-0.5"] || [m.roleType isEqualToString:@"1.1"] || [m.roleType isEqualToString:@"2.1"] || [m.roleType isEqualToString:@"3.1"]) {
                    [selfWeak.jianfeiArr addObject:m];
                } else {
                    [selfWeak.otherArr addObject:m];
                }
            }
            if (selfWeak.jianfeiArr.count >= 3) {
                bool isHave = NO;
                for (LxmShengjiModel *m0 in selfWeak.jianfeiArr) {
                    if (m0.inStatus.intValue <= 6) {
                        isHave = YES;
                    }
                }
                NSString *inStatus = @"8";
                if (!isHave) {
                    for (LxmShengjiModel *m0 in selfWeak.jianfeiArr) {
                        if (m0.inStatus.intValue <= 8) {
                            inStatus = @"7";
                        }
                    }
                }
                LxmShengjiModel *m1 = [LxmShengjiModel new];
                m1.inStatus = isHave ? @"6" : inStatus;
                m1.roleType = @"-0.5";
                [selfWeak.otherArr addObject:m1];
            }
            
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end


/**
 升级cell
 */
@interface LxmShengJiCell ()

@property (nonatomic, strong) UIImageView *bgView;//背景

@property (nonatomic, strong) UIImageView *iconImgView;//升级图标

@property (nonatomic, strong) UILabel *roleLabel;//升级角色

@property (nonatomic, strong) UILabel *stateLabel;//是否升级

@property (nonatomic, strong) UIImageView *accImgView;

@end
@implementation LxmShengJiCell

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
 添加约束
 */
- (void)initSubviews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.roleLabel];
    [self.bgView addSubview:self.stateLabel];
    [self.bgView addSubview:self.accImgView];
}

/**
 添加视图
 */
- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(20);
        make.centerY.equalTo(self.bgView);
        make.width.height.equalTo(@40);
    }];
    [self.roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(20);
        make.centerY.equalTo(self);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.hidden = YES;
    }
    return _iconImgView;
}

- (UILabel *)roleLabel {
    if (!_roleLabel) {
        _roleLabel = [[UILabel alloc] init];
        _roleLabel.textColor = UIColor.whiteColor;
        _roleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _roleLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textColor = UIColor.whiteColor;
        _stateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"next2"];
    }
    return _accImgView;
}


- (void)setModel:(LxmShengjiModel *)model {
    _model = model;
    if ([_model.roleType isEqualToString:@"-0.5"]) {
        _stateLabel.text = @"";
        if (_model.inStatus.intValue == 6){//亮色选中
            _bgView.image = [UIImage imageNamed:@"shengji_bg_n"];
        } else {
            _bgView.image = [UIImage imageNamed:@"shengji_bg_y"];
        }
    } else {
        if (_model.inStatus.intValue < 6) {
            _stateLabel.text = @"升级中";
            _bgView.image = [UIImage imageNamed:@"shengji_bg_n"];
        } else if (_model.inStatus.intValue == 6) {
            _stateLabel.text = @"未升级";
            _bgView.image = [UIImage imageNamed:@"shengji_bg_n"];
        } else if (_model.inStatus.intValue == 7){//亮色选中
            _bgView.image = [UIImage imageNamed:@"shengji_bg_y"];
            _stateLabel.text = @"已升级";
        } else {
            _stateLabel.text = @"已升级";
            _bgView.image = [UIImage imageNamed:@"shengji_bg_y"];
        }
    }
    
    if (_model.roleType.doubleValue == -1) {
        _roleLabel.text = @"无";
    } else if (_model.roleType.doubleValue == -0.5){
        _roleLabel.text = @"小红包系列";
    } else if (_model.roleType.doubleValue == 0){
        _roleLabel.text = @"vip门店";
    } else if (_model.roleType.doubleValue == 1){
        _roleLabel.text = @"高级门店";
    }else if (_model.roleType.doubleValue == 1.05){
        _roleLabel.text = @"优秀门店";
    } else if (_model.roleType.doubleValue == 2){
        _roleLabel.text = @"市服务商";
    } else if (_model.roleType.doubleValue == 3){
        _roleLabel.text = @"省服务商";
    } else if (_model.roleType.doubleValue == 4){
        _roleLabel.text = @"CEO";
    } else if (_model.roleType.doubleValue == 5) {
        _roleLabel.text = @"总经销商";
    }
    
}

- (void)setJianfeiModel:(LxmShengjiModel *)jianfeiModel {
    _jianfeiModel = jianfeiModel;
    if (_jianfeiModel.inStatus.intValue < 6) {
        _stateLabel.text = @"升级中";
        _bgView.image = [UIImage imageNamed:@"shengji_bg_n"];
    } else if (_jianfeiModel.inStatus.intValue == 6) {
        _stateLabel.text = @"未升级";
        _bgView.image = [UIImage imageNamed:@"shengji_bg_n"];
    } else if (_jianfeiModel.inStatus.intValue == 7){//亮色选中
        _bgView.image = [UIImage imageNamed:@"shengji_bg_y"];
        _stateLabel.text = @"已升级";
    } else {
        _stateLabel.text = @"已升级";
        _bgView.image = [UIImage imageNamed:@"shengji_bg_y"];
    }
    if ([_jianfeiModel.roleType isEqualToString:@"-0.3"]) {
        _roleLabel.text = @"荣誉会员";
    } else if ([_jianfeiModel.roleType isEqualToString:@"-0.4"]){
        _roleLabel.text = @"高级会员";
    } else if ([_jianfeiModel.roleType isEqualToString:@"-0.5"]){
        _roleLabel.text = @"VIP会员";
    } else if ([_jianfeiModel.roleType isEqualToString:@"1.1"]){
        _roleLabel.text = @"市服务商";
    } else if ([_jianfeiModel.roleType isEqualToString:@"2.1"]){
        _roleLabel.text = @"省服务商";
    } else if ([_jianfeiModel.roleType isEqualToString:@"3.1"]){
        _roleLabel.text = @"CEO";
    }
    
}


@end
