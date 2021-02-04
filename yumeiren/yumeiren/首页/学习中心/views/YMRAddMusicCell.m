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
    
    if ([mm.time containsString:@"."]) {
        NSArray<NSString *> * arr = [mm.time componentsSeparatedByString:@"."];
        self.timeLB.text = [NSString stringWithFormat:@"%02d:%02d",arr[0].intValue,[arr lastObject].intValue * 6];
    }else{
        self.timeLB.text = [NSString stringWithFormat:@"%02d:00",mm.time.intValue];
    }
   
    
}

@end
