//
//  YMRRenWuSectionView.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRRenWuSectionView.h"

@implementation YMRRenWuSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
     
        UIView * redV = [[UIView alloc] init];
        [self.contentView addSubview:redV];
        redV.backgroundColor = MainColor;
        [redV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@2);
            make.height.equalTo(@15);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        self.leftLB = [[UILabel alloc] init];
        self.leftLB.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.leftLB];
        [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(redV.mas_right).offset(5);
        }];
        
        self.rigthImageV = [[UIImageView alloc] init];
        self.rigthImageV.image = [UIImage imageNamed:@"youb"];
        [self.contentView addSubview:self.rigthImageV];
        [self.rigthImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@9);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            
        }];
        
        self.rightLB = [[UILabel alloc] init];
        self.rightLB.font = [UIFont systemFontOfSize:14];
        self.rightLB.textColor = CharacterLightGrayColor;
        [self.contentView addSubview:self.rightLB];
        [self.rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.rigthImageV.mas_left).offset(-5);
        }];
        self.rightLB.text = @"已完成任务";
        
        self.rightBt = [[UIButton alloc] init];
        [self.contentView addSubview:self.rightBt];
        [self.rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rigthImageV);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@50);
            make.width.equalTo(@120);
        }];
        
    }
    return self;
    
}

@end
