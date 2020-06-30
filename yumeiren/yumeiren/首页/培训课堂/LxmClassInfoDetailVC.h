//
//  LxmClassInfoDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2020/3/10.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmClassInfoDetailVC : BaseTableViewController

@property (nonatomic, strong) NSString *classId;

@end

/// 标题
@interface LxmClassInfoTitleCell : UITableViewCell

@property (nonatomic, strong) LxmClassDetailModel *detailModel;

@end

/// 语音
@interface LxmClassInfoYuyinCell : UITableViewCell

@property (nonatomic, strong) LxmClassDetailModel *detailModel;

@end

/// 详情
@interface LxmClassInfoDetailCell : UITableViewCell

@property (nonatomic, strong) LxmClassDetailModel *detailModel;

@end


@interface LxmClassInfoVideoCell : UITableViewCell

@property (nonatomic, strong) LxmClassDetailModel *detailModel;

@end
