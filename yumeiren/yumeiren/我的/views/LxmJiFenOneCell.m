//
//  LxmJiFenOneCell.m
//  yumeiren
//
//  Created by zk on 2020/7/28.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenOneCell.h"

@implementation LxmJiFenOneCell

- (void)setModel:(LxmHomeBannerModel *)model {
    _model = model;
    
    if (model.info_type.intValue == 1) {
        self.leftOneLB.text = @"收入";
        self.socreLB.text = [NSString stringWithFormat:@"+%@",model.score_price.getPriceStr];
    }else {
        self.leftOneLB.text = @"兑换";
        self.socreLB.text = [NSString stringWithFormat:@"-%@",model.score_price.getPriceStr];
    }
    self.timeLB.text = [model.create_time getIntervalToZHXLongTime];
    
    
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
