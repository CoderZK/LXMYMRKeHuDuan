//
//  YMRShowLuYinView.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRShowLuYinView.h"
@interface YMRShowLuYinView()
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UITextView * TV;
@property(nonatomic,strong)UILabel * titleLB;
@end

@implementation YMRShowLuYinView

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
            make.centerX.equalTo(self);
            make.width.equalTo(@180);
            make.height.equalTo(@250);
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
        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"180"];
        [self addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteV).offset(-40);
            make.width.equalTo(self.whiteV);
            make.centerX.equalTo(self);
            make.height.equalTo(@70);
        }];
        
        UILabel * lB =[[UILabel alloc] init];
        lB.font = [UIFont boldSystemFontOfSize:18];
        lB.text = @"你的录音以保存";
        lB.textAlignment = NSTextAlignmentCenter;
        lB.textColor = RGB(255, 97, 119);
        [self addSubview:lB];
        self.titleLB = lB;
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.whiteV).offset(100);
        }];

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }
    return self;
}

- (void)setDesStr:(NSString *)desStr {
    _desStr = desStr;
    self.TV.text = desStr;
    
    
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)diss {
    
    [self removeFromSuperview];
}

@end
