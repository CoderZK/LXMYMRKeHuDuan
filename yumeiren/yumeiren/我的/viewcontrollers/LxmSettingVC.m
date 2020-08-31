//
//  LxmSettingVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSettingVC.h"
#import "LxmShopCenterView.h"
#import "LxmFaceBookVC.h"
#import "LxmWebViewController.h"

#import "LxmLoginVC.h"

@interface LxmSettingVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, copy) NSArray<NSString *> *titleArr;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *exitButton;//退出登录

@property (nonatomic, strong) UIView *bgView;//开关的背景

@property (nonatomic, strong) UIButton *leftButton;//开

@property (nonatomic, strong) UIButton *rightButton;//关

@property (nonatomic , assign) CGFloat cacheSize;

@end

@implementation LxmSettingVC

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 12;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = LineColor.CGColor;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

-(UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_leftButton setTitle:@"关" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.selected = [LxmTool ShareTool].userModel.sendStatus.intValue == 2;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_rightButton setTitle:@"开" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.selected = [LxmTool ShareTool].userModel.sendStatus.intValue == 1;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _exitButton.layer.cornerRadius = 5;
        _exitButton.layer.masksToBounds = YES;
        [_exitButton addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    self.cacheSize = SDImageCache.sharedImageCache.totalDiskSize/1024/1024;
    _leftButton.selected = [LxmTool ShareTool].userModel.sendStatus.intValue == 2;
    _rightButton.selected = [LxmTool ShareTool].userModel.sendStatus.intValue == 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    _titleArr = @[@"清除缓存", @"关于我们", @"意见反馈",@"推送"];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.exitButton];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self.bottomView).offset(20);
        make.trailing.equalTo(self.bottomView).offset(-20);
        make.height.equalTo(@50);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            UIView * line = [[UIView alloc] init];
            line.backgroundColor = BGGrayColor;
            [cell addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell).offset(15);
                make.trailing.equalTo(cell).offset(-15);
                make.bottom.equalTo(cell);
                make.height.equalTo(@0.5);
            }];
            
            [cell addSubview:self.bgView];
            [self.bgView addSubview:self.leftButton];
            [self.bgView addSubview:self.rightButton];
            
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell).offset(-15);
                make.centerY.equalTo(cell);
                make.width.equalTo(@64);
                make.height.equalTo(@24);
            }];
            [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.bottom.equalTo(self.bgView);
                make.width.equalTo(@32);
            }];
            [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.trailing.bottom.equalTo(self.bgView);
                make.width.equalTo(@32);
            }];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            UIView * line = [[UIView alloc] init];
            line.backgroundColor = BGGrayColor;
            [cell addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell).offset(15);
                make.trailing.equalTo(cell).offset(-15);
                make.bottom.equalTo(cell);
                make.height.equalTo(@0.5);
            }];
            UIImageView *accImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            accImgView.image = [UIImage imageNamed:@"next"];
            cell.accessoryView = accImgView;
        }
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.cacheSize];
            cell.detailTextLabel.textColor = CharacterDarkColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.hidden = NO;
        } else {
            cell.detailTextLabel.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//清除缓存
        [self clearCache];
    } else if (indexPath.row == 1) {//关于我们
        LxmWebViewController *vc = [[LxmWebViewController alloc] init];
        vc.navigationItem.title = @"关于煜美人";
        vc.loadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_URL,@"/aboutMe.html"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {//意见反馈
        LxmFaceBookVC *vc = [[LxmFaceBookVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/**
 退出登录
 */
- (void)exitClick:(UIButton *)btn {
    [SVProgressHUD show];
    btn.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:app_logout parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已退出登录"];
            [LxmTool ShareTool].session_token = nil;
            [LxmTool ShareTool].userModel = nil;
            [LxmTool ShareTool].isLogin = NO;
            LxmLoginVC *vc = [LxmLoginVC new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [[UIViewController topViewController] presentViewController: [[BaseNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        btn.userInteractionEnabled = YES;
    }];
}

/**
 清除缓存
 */
- (void)clearCache {
    //清除缓存
    if (self.cacheSize > 0) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SDImageCache.sharedImageCache clearDiskOnCompletion:^{
                self.cacheSize = 0;
                [SVProgressHUD showSuccessWithStatus:@"清理成功" ];
                [self.tableView reloadData];
            }];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"暂无缓存可清理!"];
    }
}

- (void)buttonClick: (UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn == _leftButton) {//关
        _rightButton.selected = !btn.selected;
        if (_leftButton.selected) {
            [self updatePushState:@2];
        }
    } else {//开
        _leftButton.selected = !btn.selected;
        if (_rightButton.selected) {
            [self updatePushState:@1];
        }
    }
}

- (void)updatePushState:(NSNumber *)num {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LxmTool ShareTool].session_token forKey:@"token"];
    [dic setValue:[LxmTool ShareTool].deviceToken forKey:@"umeng_id"];
    [dic setValue:@1 forKey:@"device_type"];
    [dic setValue:num forKey:@"send_status"];
    WeakObj(self);
    [LxmNetworking networkingPOST:umeng_id_up parameters:dic returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        NSLog(@"推送token上传成功:%@",responseObject);
        if (responseObject.key.intValue == 1000) {
            if (num.intValue == 2) {
                _leftButton.selected = YES;
                _rightButton.selected = NO;
            } else {
                _rightButton.selected = YES;
                _leftButton.selected = NO;
            }
            [selfWeak loadMyUserInfoWithOkBlock:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
