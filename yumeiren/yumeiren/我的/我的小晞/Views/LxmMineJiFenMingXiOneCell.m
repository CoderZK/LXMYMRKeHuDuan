//
//  LxmMineJiFenMingXiOneCell.m
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineJiFenMingXiOneCell.h"

@implementation LxmMineJiFenMingXiOneCell

- (void)setModel:(LxmJiFenModel *)model  {
    _model = model;
    
    NSInteger type = model.second_type.integerValue;
    NSInteger status = model.status.integerValue;
    NSDateFormatter * formaater = [[NSDateFormatter alloc] init];
    [formaater setDateFormat:@"MM月dd日 HH:mm"];
    
    [self.typeBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.typeBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.typeBt setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.typeBt.layer.cornerRadius = 0;
    self.typeBt.clipsToBounds = YES;
    
    if (status == 1) {
        [self.typeBt setTitleColor:RGB(244, 150, 86) forState:UIControlStateNormal];
        [self.typeBt setTitle:@"审核中" forState:UIControlStateNormal];
    }else if (status == 2) {
        [self.typeBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        [self.typeBt setTitle:@"成功" forState:UIControlStateNormal];
    }else {
        [self.typeBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        [self.typeBt setTitle:@"失败" forState:UIControlStateNormal];
    }
    
    
    if (type == 1) {
        self.titleLB.text = [NSString stringWithFormat:@" 来自-%@直属业绩小晞%@",model.by_name,@""];
        self.moneyLB.text = [NSString stringWithFormat:@"+%@",model.score];
         [self.typeBt setTitleColor:RGB(255, 134, 62) forState:UIControlStateNormal];
        [self.typeBt setImage:[UIImage imageNamed:@"kk940"] forState:UIControlStateNormal];
        self.typeBt.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.typeBt setTitle:[NSString stringWithFormat:@"直属购进奖励%0.1f%%",model.sale_rate.doubleValue * 100] forState:UIControlStateNormal];
        
        
    }else if (type == 2) {
        
        self.titleLB.text = [NSString stringWithFormat:@"转出-转给%@",model.by_name];
        self.moneyLB.text = [NSString stringWithFormat:@"-%@",model.score];
        
        if (status == 1) {
                  [self.typeBt setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
                  [self.typeBt setTitle:@"确认" forState:UIControlStateNormal];
                  self.typeBt.layer.cornerRadius = 3;
                  self.typeBt.clipsToBounds = YES;
                  [self.typeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              }else if (status == 2){
                  [self.typeBt setTitle:@"已确认" forState:UIControlStateNormal];
                  [self.typeBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
              }else {
                  [self.typeBt setTitle:@"失败" forState:UIControlStateNormal];
              }

        
    }else if (type == 3) {
        self.titleLB.text = [NSString stringWithFormat:@"转入-来自%@",model.by_name];
        self.moneyLB.text = [NSString stringWithFormat:@"+%@",model.score];
      
    }else if (type == 4) {
        self.titleLB.text = [NSString stringWithFormat:@"提取%@",@""];
        self.moneyLB.text = [NSString stringWithFormat:@"-%@",model.score];
    }else if (type == 5) {
        
        self.titleLB.text = [NSString stringWithFormat:@"收入-团队销售业绩%@",model.sale_money];
        self.moneyLB.text = [NSString stringWithFormat:@"+%@",model.score];
         [self.typeBt setTitleColor:RGB(255, 134, 62) forState:UIControlStateNormal];
        [self.typeBt setImage:[UIImage imageNamed:@"kk940"] forState:UIControlStateNormal];
        self.typeBt.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.typeBt setTitle:[NSString stringWithFormat:@" 收入小晞 = 销售业绩 x %0.1f%% - 下级分配",model.sale_rate.doubleValue * 100] forState:UIControlStateNormal];
        
    }else if (type == 6) {
        self.titleLB.text = [NSString stringWithFormat:@"转入-来自%@",model.by_name];
        self.moneyLB.text = [NSString stringWithFormat:@"+%@",model.score];
      
    }else if (type == 7 ) {
        self.titleLB.text = [NSString stringWithFormat:@"转出-转给%@",model.by_name];
        self.moneyLB.text = [NSString stringWithFormat:@"-%@",model.score];
        
        if (status == 1) {
                  [self.typeBt setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
                  [self.typeBt setTitle:@"确认" forState:UIControlStateNormal];
                  self.typeBt.layer.cornerRadius = 3;
                  self.typeBt.clipsToBounds = YES;
                  [self.typeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              }else if (status == 2){
                  [self.typeBt setTitle:@"已确认" forState:UIControlStateNormal];
                  [self.typeBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
              }else {
                  [self.typeBt setTitle:@"失败" forState:UIControlStateNormal];
              }
        
    }else if (type == 8) {
        self.titleLB.text = [NSString stringWithFormat:@"提取%@",@""];
        self.moneyLB.text = [NSString stringWithFormat:@"-%@",model.score];
    }
    
    if (model.create_time.length > 3) {
        self.timeLB.text = [[model.create_time substringToIndex:model.create_time.length - 3] getIntervalToMMdd];
    }
    
    
    
    
   
    
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
