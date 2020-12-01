//
//  YMRTiShiShowView.m
//  yumeiren
//
//  Created by zk on 2020/11/23.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "YMRTiShiShowView.h"

@interface YMRTiShiShowView()
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UITextView * TV;
@end

@implementation YMRTiShiShowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.whiteV = [[UIView alloc] init];
        self.whiteV.layer.cornerRadius = 10;
        self.whiteV.clipsToBounds = YES;
        self.whiteV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteV];
        [self.whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-15);
            make.centerX.equalTo(self);
            make.width.equalTo(@271);
            make.height.equalTo(@250);
        }];
        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"179"];
        [self addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteV).offset(-35);
            make.width.equalTo(@71);
            make.centerX.equalTo(self);
            make.height.equalTo(@71);
        }];
        
        UILabel * lB =[[UILabel alloc] init];
        lB.font = [UIFont boldSystemFontOfSize:18];
        lB.text = @"贴心提示";
        lB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lB];
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.whiteV).offset(55);
        }];

        
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.backgroundColor = RGB(239, 90, 107);
        [self.whiteV addSubview:button];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.whiteV);
            make.bottom.equalTo(self.whiteV).offset(-20);
            make.width.equalTo(@180);
            make.height.equalTo(@40);
        }];
        
        self.TV = [[UITextView alloc] initWithFrame:CGRectMake(15, 90, 271-30, 250-90-90)];
        self.TV.editable = NO;
        [self.whiteV addSubview:self.TV];
        self.TV.font = [UIFont systemFontOfSize:14];
//        self.TV.backgroundColor = [UIColor redColor];
        self.TV.text = @"";
        self.TV.textColor = CharacterDarkColor;
//        [self.TV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.whiteV).offset(15);
//            make.left.equalTo(self.whiteV).offset(-15);
//            make.top.equalTo(self.whiteV).offset(190);
//            make.bottom.equalTo(self.whiteV).offset(-70);
//        }];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }
    return self;
}

- (void)setDesStr:(NSString *)desStr {
    _desStr = desStr;
    self.TV.text = desStr;
    
    
}

- (void)clickAction:(UIButton *)button {
    
    
    
  
    if (self.clickShengJiBlock != nil) {
        [self diss];
        self.clickShengJiBlock();
    }
    
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)diss {
    
    [self removeFromSuperview];
}

@end
