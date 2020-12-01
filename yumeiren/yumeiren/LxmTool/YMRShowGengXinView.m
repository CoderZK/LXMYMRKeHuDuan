//
//  YMRShowGengXinView.m
//  yumeiren
//
//  Created by zk on 2020/11/23.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "YMRShowGengXinView.h"

@interface YMRShowGengXinView()
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UITextView * TV;
@end

@implementation YMRShowGengXinView

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
            make.width.equalTo(@271);
            make.height.equalTo(@400);
        }];
        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"180"];
        [self addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteV).offset(-40);
            make.width.equalTo(self.whiteV);
            make.centerX.equalTo(self);
            make.height.equalTo(@183);
        }];
        
        UILabel * lB =[[UILabel alloc] init];
        lB.font = [UIFont boldSystemFontOfSize:18];
        lB.text = @"发现新版本";
        lB.textAlignment = NSTextAlignmentCenter;
        lB.textColor = RGB(255, 97, 119);
        [self addSubview:lB];
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.whiteV).offset(100);
        }];
        
        
        UILabel * lB1 =[[UILabel alloc] init];
        lB1.font = [UIFont boldSystemFontOfSize:16];
        lB1.text = @"更新内容";
        [self.whiteV addSubview:lB1];
        [lB1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.whiteV).offset(15);
            make.top.equalTo(self.whiteV).offset(160);
        }];
        
        
        
        
        
        
        
        
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:@"马上更新" forState:UIControlStateNormal];
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
        
        self.TV = [[UITextView alloc] initWithFrame:CGRectMake(15, 190, 271-30, 400-70-190)];
        self.TV.editable = NO;
        [self.whiteV addSubview:self.TV];
        self.TV.font = [UIFont systemFontOfSize:14];
//        self.TV.backgroundColor = [UIColor redColor];
        self.TV.text = @"qpfqo请假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去而且偶然晴儿跟晴儿跟我孔雀尾容缺日去二qpfqo请假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去而且偶然晴儿跟晴儿跟我孔雀尾容缺日去二qpfqo请假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去假惹我房管局群殴我吴若甫公企鹅我发过去韦尔奇分局偶去而且偶然晴儿跟晴儿跟我孔雀尾容缺日去二";
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
    
    
    [self diss];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/id%@",strOfAppid]];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)diss {
    
    [self removeFromSuperview];
}

@end
