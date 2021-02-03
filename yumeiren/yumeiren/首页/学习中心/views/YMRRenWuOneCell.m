//
//  YMRRenWuOneCell.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRRenWuOneCell.h"

@implementation YMRRenWuOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.confirmBt.layer.cornerRadius = 15;
    self.confirmBt.clipsToBounds = YES;
    self.confirmBt.backgroundColor = MainColor;
    
    self.backV.backgroundColor = [UIColor whiteColor];
    self.backV.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
    self.backV.layer.shadowOffset = CGSizeMake(0,0);
        // 设置阴影透明度
    self.backV.layer.shadowOpacity = 0.08;
        // 设置阴影半径
    self.backV.layer.shadowRadius = 10;
    self.backV.layer.cornerRadius = 10;
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
