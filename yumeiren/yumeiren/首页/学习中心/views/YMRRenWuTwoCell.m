//
//  YMRRenWuTwoCell.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRRenWuTwoCell.h"

@implementation YMRRenWuTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    self.headBt.layer.cornerRadius = 20;
    self.headBt.clipsToBounds = YES;
    self.leveBt.layer.cornerRadius = 8;
    self.leveBt.clipsToBounds = YES;
    [self.leveBt setTitle:@"Lve10" forState:UIControlStateNormal];
    self.leveBt.backgroundColor = leve10Color;
    self.scoreLB.textColor = MainColor;
    
    self.lineV.backgroundColor = RGB(250, 250, 250);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
