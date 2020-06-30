//
//  LxmShengjiGouWuVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmShengjiGouWuVC : BaseTableViewController

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;

@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, assign) bool isDeep;//是否是二级页面 是加返回键

@end


