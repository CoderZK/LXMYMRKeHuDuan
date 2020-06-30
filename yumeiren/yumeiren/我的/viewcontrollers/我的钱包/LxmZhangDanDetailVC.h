//
//  LxmZhangDanDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,LxmZhangDanDetailVC_type) {
    LxmZhangDanDetailVC_type_chongzhi,
    LxmZhangDanDetailVC_type_tixian,
    LxmZhangDanDetailVC_type_zhuanzhang
};

@interface LxmZhangDanDetailVC : BaseTableViewController

@property (nonatomic, strong) LxmJiYiRecordModel *model;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmZhangDanDetailVC_type)type;

@end

