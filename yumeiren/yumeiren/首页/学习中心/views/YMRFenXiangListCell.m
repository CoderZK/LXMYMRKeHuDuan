//
//  YMRFenXiangListCell.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRFenXiangListCell.h"

@implementation YMRFenXiangListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.levelBt.layer.cornerRadius = 7.5;
    self.levelBt.clipsToBounds = YES;
    
    self.leftView = [[YMRFenXiangNeiView alloc] initWithFrame:CGRectMake(60, 80, (ScreenW - 80)/2, 50)];
    self.rightView = [[YMRFenXiangNeiView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame)+10, 80, (ScreenW - 80)/2, 50)];
    
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightView];
    
    self.linev.backgroundColor = LineColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
