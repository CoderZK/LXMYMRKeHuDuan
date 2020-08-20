//
//  LxmJiFenCYCell.h
//  yumeiren
//
//  Created by zk on 2020/7/7.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmJiFenCYCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *rankLabel;//总经理

@property (nonatomic, strong) UILabel *codeLabel;//授权码

@property (nonatomic, strong) UIButton *recordButton;//库存

@property (nonatomic, strong) UILabel *recordLabel;//库存

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) UILabel *memberNumLabel;//成员

@property (nonatomic, strong) UIView *lineView;//线

@property(nonatomic,strong)LxmMyTeamListModel *model;
@property(nonatomic,assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
