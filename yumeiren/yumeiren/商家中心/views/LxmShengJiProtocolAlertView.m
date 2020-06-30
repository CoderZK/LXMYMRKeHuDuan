//
//  LxmShengJiProtocolAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/8.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShengJiProtocolAlertView.h"
#import <WebKit/WebKit.h>

@interface LxmShengJiProtocolAlertView ()

@property (nonatomic, strong) UIView *contentView;



@property (nonatomic, strong) WKWebView *webView;/* web */

@property (nonatomic, strong) LxmShengJiProtocolBottomView *bottomView;


@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmShengJiProtocolAlertView

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        CGFloat height = ScreenH - 200;
        if (height > 600) {
            height = 600;
        }
        CGFloat width = ScreenW - 30;
        if (width > 350) {
            width = 350;
        }
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - width)*0.5, (self.bounds.size.height - height)*0.5, width, height)];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        [self initContentSubviews];
        [self setConstrains];
        [self.bottomView.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView.sureButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomView.cancelButton.tag = 300;
        self.bottomView.sureButton.tag = 301;
    }
    return self;
}

/**
 添加视图
 */
- (void)initContentSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.bottomView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-60);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.webView.mas_bottom);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = @"煜美人品牌授权之协议";
    }
    return _titleLabel;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (void)setUrl:(NSString *)url {
    _url = url;
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

- (LxmShengJiProtocolBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [LxmShengJiProtocolBottomView new];
    }
    return _bottomView;
}


-(void)show {
    [self.timer invalidate];
    self.timer = nil;
    self.time = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        selfWeak.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.bottomView.sureButton.enabled = NO;
    [self.bottomView.sureButton setTitle:[NSString stringWithFormat:@"%ds",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.bottomView.sureButton.enabled = YES;
        [self.bottomView.sureButton setTitle:@"同意" forState:UIControlStateNormal];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (self.bottomButtonClickBlock) {
        self.bottomButtonClickBlock(btn.tag);
    }
    [self dismiss];
}

@end

@interface LxmShengJiProtocolBottomView ()

@property (nonatomic, strong) UIView *lineView;//


@end
@implementation LxmShengJiProtocolBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.lineView];
    [self addSubview:self.cancelButton];
    [self addSubview:self.sureButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-30);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
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
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton new];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"5s" forState:UIControlStateNormal];
        _sureButton.enabled = NO;
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sureButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}



@end
