//
//  LxmFaceBookVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/8.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmFaceBookVC.h"

@interface LxmFaceBookVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIView *bgView;//

@property (nonatomic, strong) IQTextView *textView;//输入

@property (nonatomic, strong) UIButton *submitButton;//提交

@end

@implementation LxmFaceBookVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, ScreenW, self.view.bounds.size.height - 0.5)];
    }
    return _headerView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.maxLength = 300;
        _textView.placeholder = @"请输入反馈意见~";
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    [self initSubviews];
    [self initHeaderView];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (void)initHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.bgView];
    [self.headerView addSubview:self.textView];
    [self.headerView addSubview:self.submitButton];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@200);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.leading.equalTo(self.headerView).offset(13);
        make.trailing.equalTo(self.headerView).offset(-13);
        make.height.equalTo(@200);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@44);
    }];
}

/**
 提交意见反馈
 */
- (void)submitClick:(UIButton *)btn {
    [self.textView endEditing:YES];
    if (!self.textView.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈意见!"];
        return;
    }
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"content" : self.textView.text
                           };
    [SVProgressHUD show];
    WeakObj(self);
    btn.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:feed_back parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已提交意见反馈!"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

@end
