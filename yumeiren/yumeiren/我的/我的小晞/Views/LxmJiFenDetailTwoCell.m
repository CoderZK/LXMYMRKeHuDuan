//
//  SWTJiFenDetailTwoCell.m
//  yumeiren
//
//  Created by zk on 2020/7/10.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenDetailTwoCell.h"

@implementation LxmJiFenDetailTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgV.layer.cornerRadius = 15;
    self.imgV.clipsToBounds = YES;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
