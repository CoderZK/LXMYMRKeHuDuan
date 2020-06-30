//
//  LxmReadProtocolVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmReadProtocolVC.h"
#import <WebKit/WebKit.h>

@interface LxmReadProtocolVC ()

@property (nonatomic, strong) WKWebView *webView;/* web */

@property (nonatomic, strong) UIView *bottomView;//底部按钮

@property (nonatomic, strong) UIButton *agreeButton;//同意

@property (nonatomic, assign) NSInteger count;

@end

@implementation LxmReadProtocolVC

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitle:@"同意(1)" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"协议";
    [self initViews];
}

/**
 添加视图
 */
- (void)initViews {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.agreeButton];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 50));
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bottomView);
        make.height.equalTo(@50);
    }];
    NSString *url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.urls.firstObject,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        // 针对 9.0 以上的iOS系统进行处理
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        // 针对 9.0 以下的iOS系统进行处理
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}

/**
 同意
 */
- (void)agreeButtonClick {
    NSString *url = @"";
    if (self.urls.count == 1) {
        NSLog(@"1");
        [self agreeClick];
    } else if (self.urls.count == 2) {
        if (self.count == 0) {
            url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.urls.lastObject,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue >= 9.0) {
                // 针对 9.0 以上的iOS系统进行处理
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            } else {
                // 针对 9.0 以下的iOS系统进行处理
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            };
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [_webView loadRequest:request];
            [_agreeButton setTitle:@"同意(2)" forState:UIControlStateNormal];
        } else if (self.count == 1) {
            //同意
            NSLog(@"1");
            [self agreeClick];
        }
    } else if (self.urls.count == 3) {
        if (self.count == 0) {
            url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.urls[1],LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue >= 9.0) {
                // 针对 9.0 以上的iOS系统进行处理
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            } else {
                // 针对 9.0 以下的iOS系统进行处理
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            };
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [_webView loadRequest:request];
            [_agreeButton setTitle:@"同意(2)" forState:UIControlStateNormal];
        } else if (self.count == 1) {
            url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",self.urls.lastObject,LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue >= 9.0) {
                // 针对 9.0 以上的iOS系统进行处理
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            } else {
                // 针对 9.0 以下的iOS系统进行处理
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            };
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [_webView loadRequest:request];
            [_agreeButton setTitle:@"同意(3)" forState:UIControlStateNormal];
        } else if (self.count == 2) {
           //同意
            NSLog(@"1");
            [self agreeClick];
        }
    }
    if (self.count == 2) {
        self.count = 0;
    }
    self.count++;
}

/**
 同意完毕
 */
- (void)agreeClick {
    [LxmNetworking networkingPOST:up_agree parameters:@{@"token":self.token} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            if (self.yiduXiyiBlock) {
                self.yiduXiyiBlock();
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
