//
//  LxmShopVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmShopVC : BaseTableViewController

@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;

@property (nonatomic, assign) bool isDeep;//是否是二级页面 是加返回键

@property (nonatomic, assign) BOOL isGotoGouwuChe;//是否去购物车

@property (nonatomic, assign) BOOL isAddLocolGoods;//是否是添加到本地商品

@end

NS_ASSUME_NONNULL_END
