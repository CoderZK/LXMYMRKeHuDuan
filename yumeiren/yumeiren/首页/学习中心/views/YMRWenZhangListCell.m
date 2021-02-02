//
//  YMRWenZhangListCell.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangListCell.h"

@implementation YMRWenZhangListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    self.backV.layer.cornerRadius = 10;
    self.backV.clipsToBounds = YES;
    self.backV.backgroundColor = [UIColor whiteColor];
    self.imageV.layer.cornerRadius = 10;
    self.imageV.clipsToBounds = YES;
    
    self.leftImageV.layer.cornerRadius = self.centerImageV.layer.cornerRadius = self.rightImageV.layer.cornerRadius = 7.5;
    
    self.leftImageV.clipsToBounds = self.centerImageV.clipsToBounds = self.rightImageV.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
