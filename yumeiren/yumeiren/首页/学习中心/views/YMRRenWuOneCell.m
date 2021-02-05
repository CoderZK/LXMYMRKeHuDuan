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

- (void)setModel:(YMRXueXiModel *)model {
    _model = model;
    if (model.finishStatus.intValue == 0) {
        self.confirmBt.hidden = YES;
        self.titleLB.text = @"今日无任务";
    }else if (model.finishStatus.intValue == 1 || model.finishStatus.intValue == 3){
        self.confirmBt.hidden = NO;
        [self.confirmBt setTitle:@"去完成" forState:UIControlStateNormal];
    }else {
        [self.confirmBt setTitle:@"已完成" forState:UIControlStateNormal];
        self.confirmBt.hidden = NO;
    }
    NSString * str = [NSString stringWithFormat:@"完成跟读文章可获得%d积分",model.dayCardScore.intValue];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%d",model.dayCardScore.intValue]];;
    if ([model.shareWord isEqualToString:@"文章"]) {
        self.titleLB.attributedText = [str getMutableAttributeStringWithFont:14 lineSpace:0 textColor:CharacterDarkColor textColorTwo:MainColor nsrange:range];
    }else if ([model.shareWord isEqualToString:@"无"]){
        self.titleLB.text = @"今日无任务";
    }else {
        self.titleLB.attributedText = [str getMutableAttributeStringWithFont:14 lineSpace:0 textColor:CharacterDarkColor textColorTwo:MainColor nsrange:range];
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    self.tiemLB.text = [formatter stringFromDate:[NSDate date]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
