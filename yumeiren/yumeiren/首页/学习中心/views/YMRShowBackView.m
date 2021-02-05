//
//  YMRShowBackView.m
//  yumeiren
//
//  Created by zk on 2021/2/5.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRShowBackView.h"
@interface YMRShowBackView()
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UILabel * titleLB;
@end

@implementation YMRShowBackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.whiteV = [[UIView alloc] init];
        self.whiteV.layer.cornerRadius = 10;
        self.whiteV.clipsToBounds = YES;
        self.whiteV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteV];
        [self.whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-30);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.equalTo(@180);
        }];
        
//        UIButton * closeBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//        [self addSubview:closeBt];
//        [closeBt addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        
        
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
        lB.textAlignment = NSTextAlignmentCenter;
        lB.numberOfLines = 0;
        lB.text = @"你的录音未保存, 确认放弃吗?";
        [self addSubview:lB];
        self.titleLB = lB;
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.whiteV).offset(50);
        }];

        CGFloat ww = (260-60-15)/2.0;
        UIButton * leftBt  = [[UIButton alloc] init];
        leftBt.layer.cornerRadius = 15;
        leftBt.clipsToBounds = YES;
        leftBt.layer.borderColor = CharacterDarkColor.CGColor;
        leftBt.layer.borderWidth = 1.0;
        [leftBt setTitle:@"重新录制" forState:UIControlStateNormal];
        leftBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBt.tag = 100;
        [leftBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteV addSubview:leftBt];
        
        [leftBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteV).offset(30);
            make.bottom.equalTo(self.whiteV).offset(-20);
            make.width.equalTo(@(ww));
            make.height.equalTo(@30);
        }];
        
        UIButton * rightBt  = [[UIButton alloc] init];
        rightBt.layer.cornerRadius = 15;
        rightBt.clipsToBounds = YES;
       
        [rightBt setTitle:@"放弃保存" forState:UIControlStateNormal];
        rightBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBt.tag = 101;
        [rightBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteV addSubview:rightBt];
        rightBt.backgroundColor = RGB(255, 97, 119);
        
        [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.whiteV).offset(-30);
            make.bottom.equalTo(self.whiteV).offset(-20);
            make.width.equalTo(@(ww));
            make.height.equalTo(@30);
        }];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }
    return self;
}


- (void)action:(UIButton *)button {
    
    if (self.clickGoBlock != nil) {
        self.clickGoBlock(button.tag);
    }
    [self diss];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)diss {
    
    [self removeFromSuperview];
}

@end
