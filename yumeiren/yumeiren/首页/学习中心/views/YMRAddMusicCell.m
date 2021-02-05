//
//  YMRAddMusicCell.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRAddMusicCell.h"

@implementation YMRAddMusicCell

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
    self.titleLB.text = model.title;
    
    YMRXueXiModel *mm = [YMRXueXiModel mj_objectWithKeyValues:[model.backUrl mj_JSONObject]];
    self.timeLB.text = [NSString stringWithFormat:@"%02d:%02d",mm.time.intValue/60,mm.time.intValue%60];
    
   
    
}

@end
