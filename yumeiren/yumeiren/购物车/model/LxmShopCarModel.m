//
//  LxmShopCarModel.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCarModel.h"

@implementation LxmShopCarModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"num" : @"good_num"};
//}

@end


@implementation LxmShopCarListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShopCarModel"};
}


@end

@implementation LxmShopCarRootModel 

@end

/**
 购物车下单
 */
@implementation LxmShopCarOrderModel

@end

@implementation LxmShopCarMapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShopCarModel"};
}

@end

@implementation LxmShopCarOrderRootModel 

@end

@implementation LxmAcGoodsModel

@end
