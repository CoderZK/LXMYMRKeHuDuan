//
//  LxmWebViewController.m
//  zhima
//
//  Created by lxm on 14/11/19.
//  Copyright (c) 2014年 lxm. All rights reserved.
//

#import "LxmWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface LxmWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
{
    
    
    UIProgressView * _progress;
    WKWebView * _wkWebView;
    UIActivityIndicatorView * _activityView;
    
    NSString * _htmlStr;
    NSString * _urlStr;
}
@end

@implementation LxmWebViewController

-(void)loadHtmlStr:(NSString *)htmlStr withBaseUrl:(NSString *)urlStr {
    _htmlStr = htmlStr;
    _urlStr = urlStr;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (_progress) {
        [self.navigationController.navigationBar addSubview:_progress];
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [LxmEventBus sendEvent:@"seeAllready" data:nil];
    [LxmEventBus sendEvent:@"singCompleted" data:nil];
    if (_progress) {
        [_progress removeFromSuperview];
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    if (self.readBlock) {
        self.readBlock();
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:@"new"] doubleValue];
        [_progress setProgress:progress animated:YES];
        _progress.hidden=(progress>=1);
        if (progress>=1) {
            _progress.progress = 0;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = BGGrayColor;
    [self.view addSubview:line];
    
    _wkWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.bounds.size.width, self.view.bounds.size.height - StateBarH - 44)];
    _wkWebView.allowsBackForwardNavigationGestures=YES;
    _wkWebView.navigationDelegate=self;
    [self.view addSubview:_wkWebView];
    [[_wkWebView configuration].userContentController addScriptMessageHandler:self name:@"completeFn"];

    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1.5, self.view.bounds.size.width, 1.5)];
    _progress.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    //修改进度条颜色
    _progress.progressTintColor = MainColor;
    _progress.trackTintColor = MainColor;
    
    if (_loadUrl) {
        if (_postParames) {
            NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:_loadUrl];
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody:[_postParames dataUsingEncoding:NSUTF8StringEncoding]];
            [_wkWebView loadRequest:req];
        }  else {
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:_loadUrl]];
        }
    }else if (_htmlStr) {
        [_wkWebView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:_urlStr]];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark UIWebViewDelegate
//WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url rangeOfString:@"需要跳转源生界面的URL判断"].location != NSNotFound) {
        //跳转原生界面
        //Cancel the navigation
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //code
    NSLog(@"name = %@, body = %@", message.name, message.body);
    if (message.name && [message.name isEqualToString:@"completeFn"]) {
        //返回订单详情页
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
    }
}




@end
