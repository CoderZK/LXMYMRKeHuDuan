//
//  LxmSubShopVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmSubShopVC : BaseViewController

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;

@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, strong) NSString *type_id;

@property (nonatomic, assign) BOOL isAddLocolGoods;//是否是添加到本地商品

@end

NS_ASSUME_NONNULL_END
