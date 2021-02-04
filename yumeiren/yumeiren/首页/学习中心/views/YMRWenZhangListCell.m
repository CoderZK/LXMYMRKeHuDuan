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

- (void)setModel:(YMRXueXiModel *)model {
    _model = model;
    
    self.titleLB.text = model.title;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"] options:SDWebImageRetryFailed];
    if (model.count.floatValue <10000) {
        self.numberLB.text = [NSString stringWithFormat:@"%d人跟读",model.count.intValue];
    }else {
        self.numberLB.text = [NSString stringWithFormat:@"%0.1f万人跟读",model.count.floatValue/10000];
    }
    NSArray<NSString *> * arr = [model.people_pic componentsSeparatedByString:@","];
    self.leftImageV.hidden = self.centerImageV.hidden = self.rightImageV.hidden = YES;
    self.leftCons.constant = self.centerCons.constant = self.rightCons.constant = 0;
    if (arr.count > 0) {
        self.leftImageV.hidden = NO;
        [self.leftImageV sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
        self.rightCons.constant = 15;
    }
    
    if (arr.count > 1 && arr[1].length > 1) {
        self.centerImageV.hidden = NO;
        [self.centerImageV sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
        
        self.rightCons.constant = 15;
    }
    
    if (arr.count > 2 && arr[2].length > 1) {
        self.rightImageV.hidden = NO;
        [self.rightImageV sd_setImageWithURL:[NSURL URLWithString:arr[2]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
        self.rightCons.constant = 15;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
