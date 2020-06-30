//
//  LxmShopCarModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmShopCarModel : NSObject

@property (nonatomic, strong) NSString *good_name;/* 商品名称 */

@property (nonatomic, strong) NSString *list_pic;/* 商品图片 */

@property (nonatomic, strong) NSString *give_pic;/* 商品图片 */

@property (nonatomic, strong) NSString *good_price;/* 商品原价 */

@property (nonatomic, strong) NSString *proxy_price;/* 商品代理价 */

@property (nonatomic, strong) NSString *id;/* 购物车id */

@property (nonatomic, strong) NSString *user_id;/*  */

@property (nonatomic, strong) NSString *create_time;/* 购物车id */

@property (nonatomic, strong) NSString *status;/*  */

@property (nonatomic, strong) NSString *good_id;/* 商品id */

@property (nonatomic, strong) NSString *num;/* 数量 */

@property (nonatomic, strong) NSString *good_num;/* 数量 */

@property (nonatomic, strong) NSString *com_num;/* 数量 */

@property (nonatomic, assign) BOOL isSelected;/* 是否选中 */

@property (nonatomic, strong) NSString *pinjieStr;//商品不足拼接字符串

@property (nonatomic, strong) NSString *maxNum;//最大库存量

@end

@interface LxmShopCarListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmShopCarModel *>*list;/* 商品列表 */

@end

@interface LxmShopCarRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopCarListModel *result;/**结果*/

@end

/**
 购物车下单
 */
@interface LxmShopCarOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;/* 订单号 */

@property (nonatomic, strong) NSString *price;/* 价格 */

@property (nonatomic, strong) NSString *balance;/* 余额 */

@end

@interface LxmShopCarMapModel : NSObject

@property (nonatomic, strong) LxmShopCarOrderModel *map;/* map */

@property (nonatomic, strong) NSArray  <LxmShopCarModel *>*list;/* 商品列表 */

@end

@interface LxmShopCarOrderRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopCarMapModel *result;/**结果*/

@end

@interface LxmAcGoodsModel : NSObject
@property (nonatomic, strong) NSString *goodIdList;
@property (nonatomic, strong) NSString *goodName;
@property (nonatomic, strong) NSString *goodPic;
@property (nonatomic, strong) NSString *id;

///  满金额的，满足多少金额送，比如满2万送一个，这个就是20000
@property (nonatomic, strong) NSString *infoMoney;

/// 活动名称
@property (nonatomic, strong) NSString *infoName;

/// 满足数量赠送
@property (nonatomic, strong) NSString *infoNum;
@property (nonatomic, strong) NSString *sendNum;

/// 1：满金额赠送，2：满数量赠送
@property (nonatomic, strong) NSString *infoType;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, assign) BOOL isCanShow;

@property (nonatomic, assign) NSInteger loc_num;
@end
