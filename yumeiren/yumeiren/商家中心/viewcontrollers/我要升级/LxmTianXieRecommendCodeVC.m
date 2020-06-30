//
//  LxmTianXieRecommendCodeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/3/6.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmTianXieRecommendCodeVC.h"
#import "LxmLoginView.h"

@interface LxmTianXieRecommendCodeVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmTextAndPutinTFView *recommendView;//推荐码

@property (nonatomic, strong) UIButton *submitButton;//确认提交按钮

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmTianXieRecommendCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - 1)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmTextAndPutinTFView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[LxmTextAndPutinTFView alloc] init];
        _recommendView.leftLabel.text = @"推荐码";
        _recommendView.rightTF.placeholder = @"输入推荐码";
        _recommendView.lineView.hidden = YES;
    }
    return _recommendView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写推荐码";
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self initHeaderView];
    [self setConstrains];
}

/**
 添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.recommendView];
    [self.headerView addSubview:self.submitButton];
    [self.headerView addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendView.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@44);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.bottom.equalTo(self.recommendView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

- (void)submitButtonClick {
    if (self.recommendView.rightTF.text.isValid) {
        [SVProgressHUD show];
        self.submitButton.userInteractionEnabled = NO;
        WeakObj(self);
        [LxmNetworking networkingPOST:code_role_type parameters:@{@"token":SESSION_TOKEN,@"recommendCode":self.recommendView.rightTF.text} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            selfWeak.submitButton.userInteractionEnabled = YES;
            if ([responseObject[@"key"] intValue] == 1000) {
                NSString *ishefa = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]];
                if (ishefa.intValue == 1) {
                    if (selfWeak.recommendCodeBlock) {
                        selfWeak.recommendCodeBlock(self.recommendView.rightTF.text);
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"不是正常市代及以上的用户,推荐码不合法!"];
                }
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            selfWeak.submitButton.userInteractionEnabled = YES;
            [SVProgressHUD show];
        }];
        
    } else {
        [UIAlertController showAlertWithmessage:@"请填写有效的推荐码！"];
    }
}

@end
