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
    self.leftView.titleLB.text = @"文章跟读音频";
    self.rightView = [[YMRFenXiangNeiView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame)+10, 80, (ScreenW - 80)/2, 50)];
    self.rightView.titleLB.text = @"分享心得音频";
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightView];
    
    self.linev.backgroundColor = LineColor;
    
    
}

- (void)setModel:(YMRXueXiModel *)model {
    _model = model;
    [self.headBt sd_setBackgroundImageWithURL:[NSURL URLWithString:model.user_head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.nameLB.text = model.username;
    self.timeLB.text = [model.createTime getIntervalToFXXTNoHHmmime];
    [self.levelBt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%d",model.level_num.intValue]] forState:UIControlStateNormal];

    [self.levelBt setTitle:[NSString stringWithFormat:@"Lv%d",model.level_num.intValue] forState:UIControlStateNormal];
    
    self.levelBt.backgroundColor = colorArr[model.level_num.intValue];
    
    YMRXueXiModel * leftM = [YMRXueXiModel mj_objectWithKeyValues:[model.one_work mj_JSONObject]];
    YMRXueXiModel * rightM = [YMRXueXiModel mj_objectWithKeyValues:[model.one_work mj_JSONObject]];
    if (model.one_work.length > 0 ) {
        self.leftView.hidden = NO;
        NSInteger timeOne = leftM.time.intValue;
        self.leftView.rightLB.text = [NSString stringWithFormat:@"%02ld:%02ld",timeOne / 60,timeOne % 60];
    }else {
        self.leftView.hidden = YES;
    }
    if (model.two_work.length > 0) {
        self.rightView.hidden = NO;
        NSInteger timeOne = rightM.time.intValue;
        self.rightView.rightLB.text = [NSString stringWithFormat:@"%02ld:%02ld",timeOne / 60,timeOne % 60];
    }else {
        self.rightView.hidden = YES;
    }
    
    if (model.leftIsPlaying) {
        self.leftView.imgV.image = [UIImage imageNamed:@"zantingnei"];
    }else {
        self.leftView.imgV.image = [UIImage imageNamed:@"laba"];
    }
    if (model.rightIsPlaying) {
        self.rightView.imgV.image = [UIImage imageNamed:@"zantingnei"];
    }else {
        self.rightView.imgV.image = [UIImage imageNamed:@"laba"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
