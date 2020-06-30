//
//  LxmPublishTouSuVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, LxmPublishTouSuVC_type) {
    LxmPublishTouSuVC_type_tousu,
    LxmPublishTouSuVC_type_chedan,
    LxmPublishTouSuVC_type_shenqingdaili
};

@interface LxmPublishTouSuVC : BaseTableViewController

@property (nonatomic, strong) LxmTouSuDetailModel *tousuModel;//继续投诉的投诉id

@property (nonatomic, strong) LxmJieDanListModel *tuidanModel;//申请退单model

@property (nonatomic, copy) void(^shenqingDailiBlock)(NSString *reason, NSString *ids);

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPublishTouSuVC_type)type;

@end

