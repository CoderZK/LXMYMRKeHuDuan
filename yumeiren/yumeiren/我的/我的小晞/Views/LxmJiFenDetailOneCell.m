//
//  LxmJiFenDetailOneCell.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenDetailOneCell.h"

@implementation LxmJiFenDetailOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailBt.layer.cornerRadius = 12;
    self.detailBt.clipsToBounds = YES;
    [self.detailBt setTitleColor:MainColor forState:UIControlStateNormal];
    self.detailBt.layer.borderColor = MainColor.CGColor;
    self.detailBt.layer.borderWidth = 0.5;
    self.detailBt.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
