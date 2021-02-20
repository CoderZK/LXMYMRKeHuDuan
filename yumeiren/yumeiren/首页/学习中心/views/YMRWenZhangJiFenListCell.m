//
//  YMRWenZhangJiFenListCell.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangJiFenListCell.h"

@implementation YMRWenZhangJiFenListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YMRXueXiModel *)model {
    _model = model;
    
    self.numberLB.text = [NSString stringWithFormat:@"+%@",model.score];
    self.numberLB.textColor = MainColor;
    self.timeLB.text = [model.createTime getIntervalToZHXLongTime];
    if (model.infoType.intValue == 1) {
        self.nameLB.text = @"每日完成任务获得";
    }else if (model.infoType.intValue == 2) {
        self.nameLB.text = @"连续一周完成任务获得";
    }else if (model.infoType.intValue == 3) {
        self.nameLB.text = @"连续一个月完成任务获得";
    }else if (model.infoType.intValue == 4) {
        self.nameLB.text = @"连续一个季度完成任务获得";
    }
 
}

@end
