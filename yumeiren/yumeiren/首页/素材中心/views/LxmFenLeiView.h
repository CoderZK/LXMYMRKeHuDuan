//
//  LxmFenLeiView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmFenLeiView : UIView

@end

/**
 用户cell
 */
@interface LxmFenLeiUserInfoCell : UITableViewCell

@property (nonatomic, strong) LxmSuCaiListModel *model;

@property (nonatomic, strong) UILabel *stateLabel;//审核状态

@property (nonatomic, strong) UIImageView *tuijianImgView;//是否是推荐过的

@property (nonatomic, strong) UIButton *deleteButton;//删除

@property (nonatomic, strong) UILabel *deleteLabel;//删除

@property (nonatomic, copy) void(^deleteSuCaiBlock)(LxmSuCaiListModel *model);

@end

/**
 内容cell
 */
@interface LxmFenLeiContentCell : UITableViewCell

@property (nonatomic, strong) LxmSuCaiListModel *model;

@property (nonatomic, strong) NSIndexPath *indexP;

@property (nonatomic, copy) void(^contentBlock)(BOOL iszhankai,NSIndexPath *indexP);

@end

/**
 展开收缩
 */
@interface LxmFenLeiButtonCell : UITableViewCell

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) LxmSuCaiListModel *model;

@end

/**
 图片cell
 */
@interface LxmFenLeiImgItemCell : UICollectionViewCell

@property (nonatomic, strong) LxmSuCaiListModel *model;

@property (nonatomic, strong) NSIndexPath *indexP;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, copy) void(^deleteImgBlock)(NSIndexPath *indexP);

@end

@interface LxmFenLeiImgCell : UITableViewCell

@property (nonatomic, strong) LxmSuCaiListModel *model;

@end
/**
 视频cell
 */
@interface LxmFenLeiVedioCell : UITableViewCell

@property (nonatomic, strong) LxmSuCaiListModel *model;

- (void)stopPlayer;

@end
/**
 底部
 */
@interface LxmFenLeiBottomCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmSuCaiListModel *model;

@end

/**
 分类标识
 */
@interface LxmFenLeiBiaoShiCell : UITableViewCell

@property (nonatomic, strong) UILabel *statelabel;

@property (nonatomic, strong) UIView *lineView;//线

@end
