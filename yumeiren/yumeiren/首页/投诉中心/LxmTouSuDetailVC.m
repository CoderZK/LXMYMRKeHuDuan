//
//  LxmTouSuDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTouSuDetailVC.h"
#import "LxmTouSuView.h"
#import "LxmPublishTouSuVC.h"

@interface LxmTouSuDetailVC ()

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmTouSuBottomView *bottomView;//底部确认发布view

@property (nonatomic, strong) LxmTouSuDetailModel *model;

@end

@implementation LxmTouSuDetailVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmTouSuBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmTouSuBottomView alloc] init];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投诉详情";
    [self initView];
    [self loadDeatilData];
}

/**
 view添加子视图
 */
- (void)initView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
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
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(64 + TableViewBottomSpace));
    }];
    [self.bottomView.bumanyiButton addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.mamyiButton addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : self.model.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LxmTouSuDetailBianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTouSuDetailBianHaoCell"];
            if (!cell) {
                cell = [[LxmTouSuDetailBianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTouSuDetailBianHaoCell"];
            }
            cell.model = self.model;
            return cell;
        } else if (indexPath.row == 1) {
            LxmTouSuDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTouSuDetailContentCell"];
            if (!cell) {
                cell = [[LxmTouSuDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTouSuDetailContentCell"];
            }
            cell.model = self.model;
            return cell;
        } else {
            LxmTouSuDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTouSuDetailImageCell"];
            if (!cell) {
                cell = [[LxmTouSuDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTouSuDetailImageCell"];
            }
            cell.model = self.model;
            return cell;
        }
    } else {
        LxmTouSuDetailKeFuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTouSuDetailKeFuCell"];
        if (!cell) {
            cell = [[LxmTouSuDetailKeFuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTouSuDetailKeFuCell"];
        }
        cell.model = self.model.details[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view =  [UIView new];
    view.backgroundColor = BGGrayColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row == 1) {
            return self.model.commetH;
        } else {
            NSArray *imgArr = [self.model.detailPic componentsSeparatedByString:@","];
            return ceil(imgArr.count/3.0) * (floor((ScreenW - 60)/3.0) + 15);
        }
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.model.details.count > 0) {
            return 15;
        }
        return 0.01;
    }
    return 0.01;
}

/**
 获取投诉详情数据
 */
- (void)loadDeatilData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:complain_detail parameters:@{@"token":SESSION_TOKEN,@"id":self.ID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.model = [LxmTouSuDetailModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
            selfWeak.bottomView.hidden = NO;
            if (selfWeak.model.status.intValue == 3) {//3 待评价
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(64 + TableViewBottomSpace));
                }];
            } else {
                [selfWeak.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
            [selfWeak.view layoutIfNeeded];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"messgae"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)bottomAction:(UIButton *)btn {
    if (btn == self.bottomView.bumanyiButton) {//不满意 继续投诉
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否继续投诉?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jieshuTouSu:@2];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] init];
            vc.tousuModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
       
    } else {//满意
        [self jieshuTouSu:@1];
    }
}

/**
 结束投诉 1满意 2 不满意
 */
- (void)jieshuTouSu:(NSNumber *)num {
    if (num.integerValue == 1) {
        self.bottomView.mamyiButton.userInteractionEnabled = NO;
    } else {
        self.bottomView.bumanyiButton.userInteractionEnabled = NO;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:close_complain parameters:@{@"token":SESSION_TOKEN,@"id":self.model.id,@"status":num} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (num.integerValue == 1) {
            self.bottomView.mamyiButton.userInteractionEnabled = YES;
        } else {
            self.bottomView.bumanyiButton.userInteractionEnabled = YES;
        }
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已结束投诉!"];
            [LxmEventBus sendEvent:@"detailTousuAction" data:nil];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.view layoutIfNeeded];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (num.integerValue == 1) {
            self.bottomView.mamyiButton.userInteractionEnabled = YES;
        } else {
            self.bottomView.bumanyiButton.userInteractionEnabled = YES;
        }
    }];
}

@end
