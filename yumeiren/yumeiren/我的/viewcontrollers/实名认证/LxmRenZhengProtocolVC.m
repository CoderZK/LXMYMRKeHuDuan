//
//  LxmRenZhengProtocolVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmRenZhengProtocolVC.h"
#import <WebKit/WebKit.h>

@interface LxmRenZhengProtocolVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *bottomView;//底部视图

@property (nonatomic, strong) WKWebView *webView;/* web */

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) UIButton *sureButton;//确定

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmRenZhengProtocolVC

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        
        NSString *url = [NSString stringWithFormat:@"%@?username=%@&idCode=%@",@"https://app.hkymr.com/ruleDetailTotal.html",LxmTool.ShareTool.userModel.username,LxmTool.ShareTool.userModel.idCode];
        
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
    }
    return _webView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowOffset = CGSizeZero;
        _bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bottomView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bottomView;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:MainColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.layer.borderColor = MainColor.CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        [_cancelButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton new];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"5s" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"协议";
    [self initSubViews];
    [self.timer invalidate];
    self.timer = nil;
    self.time = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.sureButton.enabled = NO;
    [self.sureButton setTitle:[NSString stringWithFormat:@"%ds",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.sureButton.enabled = YES;
        [self.sureButton setTitle:@"同意" forState:UIControlStateNormal];
    }
}

- (void)initSubViews {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.sureButton];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 70));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self.bottomView).offset(15);
        make.trailing.equalTo(self.bottomView.mas_centerX).offset(-7.5);
        make.height.equalTo(@40);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.trailing.equalTo(self.bottomView).offset(-15);
        make.leading.equalTo(self.bottomView.mas_centerX).offset(7.5);
        make.height.equalTo(@40);
    }];
}

- (void)agreeClick:(UIButton *)btn {
    if (btn == _sureButton) {
        WeakObj(self);
        [LxmNetworking networkingPOST:up_agree parameters:@{@"token":SESSION_TOKEN} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
            if (responseObject.key.integerValue == 1000) {
                [selfWeak.navigationController popToRootViewControllerAnimated:NO];
                [LxmEventBus sendEvent:@"yitongyi" data:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

@end
