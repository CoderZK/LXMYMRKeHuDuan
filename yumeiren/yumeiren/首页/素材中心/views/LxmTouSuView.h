//
//  LxmTouSuView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmTouSuView : UIView

@end

@interface LxmTouSuListCell : UITableViewCell

@property (nonatomic, strong) LxmTouSuListModel *listModel;

@end

/**
 投诉详情 投诉编号
 */
@interface LxmTouSuDetailBianHaoCell : UITableViewCell

@property (nonatomic, strong) LxmTouSuDetailModel *model;

@end
/**
 投诉详情 投诉内容
 */
@interface LxmTouSuDetailContentCell : UITableViewCell

@property (nonatomic, strong) LxmTouSuDetailModel *model;

@end
/**
 投诉详情 投诉图片
 */
@interface LxmTouSuDetailImageCell : UITableViewCell

@property (nonatomic, strong) LxmTouSuDetailModel *model;

@end

/**
 官方客服Cell
 */
@interface LxmTouSuDetailKeFuCell : UITableViewCell

@property (nonatomic, strong) LxmTouSuRecordModel *model;

@end

/**
 投诉结果 满意 或 不满意
 */
@interface LxmTouSuBottomView : UIView

@property (nonatomic, strong) UIButton *bumanyiButton;//不满意

@property (nonatomic, strong) UIButton *mamyiButton;//满意

@end
