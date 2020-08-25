//
//  LxmMineYeJiKaoCell.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineYeJiKaoCell.h"

@implementation LxmMineYeJiKaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backV.backgroundColor = [UIColor whiteColor];
    self.backV.layer.cornerRadius = 5;
    self.backV.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backV.layer.shadowOffset = CGSizeMake(0, 0);
    self.backV.layer.shadowRadius = 5;
    self.backV.layer.shadowOpacity = 0.08;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.yjView.layer.cornerRadius = 3;
    self.yjView.clipsToBounds = YES;
    self.leftTwoLB.textColor  = self.rightTwoLB.textColor = MainColor;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 100) {
        self.leftOneLB.text = @"当月总完成(元)";
        self.rightOneLB.text = @"当月目标(元)";
        self.leftThreeLB.text = @"当月完成(元)";
        self.leftFourLB.text = @"当月新增同级直属(人)";
    }else {
       self.leftOneLB.text = @"当季总完成(元)";
        self.rightOneLB.text = @"当季目标(元)";
        self.leftThreeLB.text = @"当季完成(元)";
        self.leftFourLB.text = @"当季新增同级直属(人)";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setIsJingLi:(BOOL)isJingLi {
    _isJingLi = isJingLi;
    if (isJingLi) {
        
    self.leftTwoCon.constant = self.leftBottomCon.constant = self.desCon.constant = 0;
    self.bottomV.hidden = YES;
        
    }
}

@end
