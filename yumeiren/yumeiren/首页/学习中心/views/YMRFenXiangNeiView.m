//
//  YMRFenXiangNeiView.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRFenXiangNeiView.h"

@implementation YMRFenXiangNeiView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8.5, 17, 17)];
        self.imgV.image = [UIImage imageNamed:@"laba"];
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgV];
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgV.frame) + 5, 10, frame.size.width - (CGRectGetMaxX(self.imgV.frame) + 5) , 14)];
        self.titleLB.font = [UIFont systemFontOfSize:12];
        self.titleLB.text = @"文章跟读音频";
        [self addSubview:self.titleLB];
        
        self.leftLB = [[UILabel alloc] init];
        self.leftLB.font = [UIFont systemFontOfSize:8];
        self.leftLB.textColor = CharacterLightGrayColor;
        [self addSubview:self.leftLB];
        self.leftLB.text = @"00:00";
        [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.width.equalTo(@30);
            make.bottom.equalTo(self).offset(-5);
            make.height.equalTo(@10);
        }];
//        self.leftLB.backgroundColor  = [UIColor greenColor];
        
        self.rightLB = [[UILabel alloc] init];
        self.rightLB.font = [UIFont systemFontOfSize:8];
        self.rightLB.textColor = CharacterLightGrayColor;
        [self addSubview:self.rightLB];
        self.rightLB.textAlignment = NSTextAlignmentRight;
        self.rightLB.text = @"88:88";
        [self.rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.width.equalTo(@30);
            make.bottom.equalTo(self).offset(-5);
            make.height.equalTo(@10);
        }];
        
        self.bottomImgV = [[UIImageView alloc] init];
        [self addSubview:self.bottomImgV];
//        self.bottomImgV.contentMode = UIViewContentModeScaleToFill;
        self.bottomImgV.image = [UIImage imageNamed:@"yinbo"];
//        self.bottomImgV.backgroundColor = [UIColor redColor];
        [self.bottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftLB);
            make.height.equalTo(@10);
            make.left.equalTo(self.leftLB.mas_right);
            make.right.equalTo(self.rightLB.mas_left);
        }];
        self.backgroundColor = BGGrayColor;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        
        self.actionBt = [[UIButton alloc] init];
        [self addSubview:self.actionBt];
        [self.actionBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
    }
    return self;
}

@end
