//
//  YMRWenZhangJiFenGuiZeView.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangJiFenGuiZeView.h"
@interface YMRWenZhangJiFenGuiZeView()
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UITextView * TV;
@property(nonatomic,strong)UILabel * titleLB;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation YMRWenZhangJiFenGuiZeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton * bt = [[UIButton alloc] init];
        [bt addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.whiteV = [[UIView alloc] init];
        self.whiteV.layer.cornerRadius = 10;
        self.whiteV.clipsToBounds = YES;
        self.whiteV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteV];
        [self.whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(60);
            make.right.equalTo(self).offset(-60);
            make.height.equalTo(@380);
        }];
        
        UIButton * closeBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [self addSubview:closeBt];
        [closeBt addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * button =  [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
        [self.whiteV addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@40);
            make.right.top.equalTo(self.whiteV);
        }];
        [button addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        
    
        
        UILabel * lB =[[UILabel alloc] init];
        lB.font = [UIFont boldSystemFontOfSize:18];
        lB.text = @"规则明细";
        lB.textAlignment = NSTextAlignmentCenter;
//        lB.textColor = RGB(255, 97, 119);
        [self.whiteV addSubview:lB];
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.whiteV).offset(15);
        }];

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIView * redView = [[UIView alloc] init];
        redView.backgroundColor = [UIColor redColor];
        redView.alpha = 0.3;
        [self.whiteV addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(lB);
            make.height.equalTo(@6);
            make.top.equalTo(lB.mas_bottom).offset(-5);
        }];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.whiteV addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteV).offset(15);
            make.right.bottom.equalTo(self.whiteV).offset(-15);
            make.top.equalTo(lB.mas_bottom).offset(20);
            
        }];
        
        self.titleLB = [[UILabel alloc] init];
        self.titleLB.numberOfLines = 0;
        self.titleLB.font = [UIFont systemFontOfSize:14];
  
        [self.scrollView addSubview:self.titleLB];
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.scrollView);
            make.height.equalTo(@20);
        }];
        
        
    }
    return self;
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    self.titleLB.text = remark;
    CGFloat hh = [remark getSizeWithMaxSize:CGSizeMake(ScreenW - 150, 10000) withFontSize:14].height;
    [self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(hh));
    }];
    self.scrollView.contentSize = CGSizeMake(ScreenW - 150, hh);
    
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)diss {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

@end

