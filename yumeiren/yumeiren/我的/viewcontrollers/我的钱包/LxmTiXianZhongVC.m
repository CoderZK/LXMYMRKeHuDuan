//
//  LxmTiXianZhongVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTiXianZhongVC.h"
#import "LxmMineVC.h"
#import "LxmQianBaoVC.h"

@interface LxmTiXianZhongVC ()

@property (nonatomic, strong) LxmQianBaoButton *tixianButton;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIButton *finishButton;//完成按钮

@end

@implementation LxmTiXianZhongVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LxmQianBaoVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - 1)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (LxmQianBaoButton *)tixianButton {
    if (!_tixianButton) {
        _tixianButton = [[LxmQianBaoButton alloc] init];
        _tixianButton.imgView.image = [UIImage imageNamed:@"wdqb_tx"];
        _tixianButton.textLabel.text = @"提现中";
        _tixianButton.userInteractionEnabled = NO;
    }
    return _tixianButton;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _finishButton.layer.cornerRadius = 5;
        _finishButton.layer.masksToBounds = YES;
        [_finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self initHeaderView];
}
/**
 添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.tixianButton];
    [self.headerView addSubview:self.finishButton];
    [self.tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(35);
        make.centerX.equalTo(self.headerView);
        make.width.height.equalTo(@120);
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tixianButton.mas_bottom).offset(20);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
}

/**
 完成
 */
- (void)finishButtonClick {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LxmQianBaoVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
