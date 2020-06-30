//
//  LxmShopModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmHomeModel.h"

@interface LxmShopModel : NSObject

@end

/**
 商铺商品列表页
 */
@interface LxmShopListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmHomeGoodsModel *>*list;/*所属分类下的所有商品*/

@end

@interface LxmShopListRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopListModel *result;/**结果*/

@end

/**
 商品详情
 */
@interface LxmGoodsDetailModel : NSObject

@property (nonatomic, strong) NSString *specialType;/**1：不可以，2：可以（减肥单项）*/
@property (nonatomic, strong) NSString *givePic;/**赠送商品显示的图片*/
@property (nonatomic, strong) NSString *id;/**商品id*/

@property (nonatomic, strong) NSString *goodName;/**标题*/

@property (nonatomic, strong) NSString *listPic;/**列表图片*/

@property (nonatomic, strong) NSString *mainPic;/**轮播图*/

@property (nonatomic, strong) NSString *detailPic;/**详情图片*/

@property (nonatomic, strong) NSString *content;/**详情文字*/

@property (nonatomic, strong) NSString *goodPrice;/**价格*/

@property (nonatomic, strong) NSString *num;/*本地商品数量*/

@property (nonatomic, assign) CGFloat titleH;//标题高度

@property (nonatomic, strong) NSString *proxyPrice;/**商品代理价*/

@property (nonatomic, strong) NSString *upNum;//上级库存数量

@property (nonatomic, strong) NSString *comNum;//公司库存数量

@end


@interface LxmGoodsDetailModel1 : NSObject

@property (nonatomic, strong) LxmGoodsDetailModel *good;/**商品model*/

@property (nonatomic, strong) NSString *postMoney;/**满多少包邮，为0就不显示*/

@property (nonatomic, strong) NSString *cartNum;/*购物车商品数量*/

@end

/**
 图片
 */
@interface LxmGoodsDetailTuPianModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *status;

@end

/**
 我要升级
 */
@interface LxmShengjiModel : NSObject

@property (nonatomic, strong) NSString *checkType;/* 1：购买商品补足金额，2：后台审核，3：ceo五个省代 */

@property (nonatomic, strong) NSString *content;/* 协议 */

@property (nonatomic, strong) NSString *deposit;/* 保证金 */

@property (nonatomic, strong) NSString *depositMsg;/* 保证金说明 */

@property (nonatomic, strong) NSString *id;/*  */

@property (nonatomic, strong) NSString *inStatus;/*  */

@property (nonatomic, strong) NSString *payMoney;/* 购货要求 */

@property (nonatomic, strong) NSString *unitMoney;/* 升级购物要求 */

@property (nonatomic, strong) NSString *roleType;/* 0：无，1：县代，2：市代，3：省代，4：ceo */

@property (nonatomic, strong) NSString *url;/* 协议路径 */

@property (nonatomic, strong) NSString *depositUrl;/* 保证金协议路径 */

@property (nonatomic, strong) NSString *lowMoney;/* 购货要求 */

@property (nonatomic, strong) NSString *locStatus;/* 1：申请中，2：成功，3：失败 */


@end


@interface LxmShengjiLsitModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总页数*/

@property (nonatomic, strong) NSString *data;/** 无身份时升级中一个角色购物的订单id */

@property (nonatomic, strong) NSArray  <LxmShengjiModel *>*list;/* */

@end


@interface LxmShengjiRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShengjiLsitModel *result;/**结果*/

@end
