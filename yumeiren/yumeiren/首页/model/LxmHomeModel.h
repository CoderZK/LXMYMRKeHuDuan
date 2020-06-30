//
//  LxmHomeModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmHomeModel : NSObject

@end

/**
 发布投诉
 */

@interface LxmPublishTouSutModel : NSObject

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) NSString *width;

@property (nonatomic, strong) NSString *height;

@end




/**
 投诉中心列表
 */
@interface LxmTouSuListModel : NSObject

@property (nonatomic, strong) NSString *commend;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *detailPic;

@property (nonatomic, strong) NSString *details;

@property (nonatomic, strong) NSString *frontUserId;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *longCode;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *userId;

@end


@interface LxmTouSuListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmTouSuListModel *>*list;

@end

@interface LxmTouSuListRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmTouSuListModel1 *result;

@end

/**
 投诉详情
 */

@interface LxmTouSuRecordModel : NSObject

@property (nonatomic, strong) NSString *userHead;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *commend;

@property (nonatomic, strong) NSString *createTime;

@end


@interface LxmTouSuDetailModel : NSObject

@property (nonatomic, strong) NSString *commend;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *detailPic;

@property (nonatomic, strong) NSArray <LxmTouSuRecordModel *>*details;

@property (nonatomic, strong) NSString *frontUserId;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *longCode;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) CGFloat commetH;//评论内容高度

@end

/**
 素材中心
 */
@interface LxmSuCaiContentTypeListModel : NSObject

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *infoType;

@property (nonatomic, strong) NSString *listPic;

@property (nonatomic, strong) NSString *mainPic;

@property (nonatomic, strong) NSString *orderIndex;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL isSelected;

@end

@interface LxmSuCaiContentTypeModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmSuCaiContentTypeListModel *>*list;

@end

@interface LxmSuCaiContentTypeRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmSuCaiContentTypeModel *result;

@end

/**
 素材列表
 */

@interface LxmSuCaiListModel : NSObject

@property (nonatomic, strong) NSString *media_num;

@property (nonatomic, strong) NSString *type_name;

@property (nonatomic, strong) NSString *user_head;

@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, strong) NSString *title_num;

@property (nonatomic, strong) NSString *recommend;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *video_url;

@property (nonatomic, strong) NSString *status;//1：审核中，2：审核通过，3：审核拒绝

@property (nonatomic, strong) NSString *username;

@property (nonatomic, assign) BOOL iszhankai;

@end

@interface LxmSuCaiListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmSuCaiListModel *>*list;

@end

@interface LxmSuCaiListRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmSuCaiListModel1 *result;

@end

/**
 接单平台
 */

@interface LxmJieDanPublishModel : NSObject

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *payPrice;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *typeName;

@end

@interface LxmJieDanPublishModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmJieDanPublishModel *>*list;

@end

@interface LxmJieDanPublishRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmJieDanPublishModel1 *result;

@end

@interface LxmJieDanListModel : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *username;//展示昵称

@property (nonatomic, strong) NSString *userId;//展示用户id

@property (nonatomic, strong) NSString *user_head;//展示头像

@property (nonatomic, strong) NSString *telephone;//服务对象手机号

@property (nonatomic, strong) NSString *province;//所在省

@property (nonatomic, strong) NSString *city;//所在市

@property (nonatomic, strong) NSString *district;//所在区

@property (nonatomic, strong) NSString *addressDetail;//所在详细地址

@property (nonatomic, strong) NSString *serviceType;//服务类型id

@property (nonatomic, strong) NSString *serviceTypeName;//服务类型

@property (nonatomic, strong) NSString *servicePrice;//服务价格

@property (nonatomic, strong) NSString *serviceDay;//服务天数

@property (nonatomic, strong) NSString *addPrice;//加价

@property (nonatomic, strong) NSString *beginTime;//服务开始时间 时间戳

@property (nonatomic, strong) NSString *endTime;//服务结束时间 时间戳

@property (nonatomic, strong) NSString *createTime;//订单创建时间 时间戳

@property (nonatomic, strong) NSString *status;//1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效

@property (nonatomic, strong) NSString *orderCode;//流水号

@property (nonatomic, strong) NSString *backCommend;//退单理由

@property (nonatomic, strong) NSString *backPic;//退单图片

@property (nonatomic, strong) NSString *score;//打分

@property (nonatomic, strong) NSString *getPrice;//最终得到的金额

@property (nonatomic, strong) NSString *judgePic;//评价单

@property (nonatomic, strong) NSString *showHead;//头像

@property (nonatomic, strong) NSString *showName;//昵称

@property (nonatomic, strong) NSString *takeTime;//接单时间

@end

@interface LxmJieDanListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmJieDanListModel *>*list;

@end

@interface LxmJieDanListRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmJieDanListModel1 *result;

@end

/**
 首页
 */
@interface LxmHomeGoodsModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *list_pic;/*商品缩略图*/

@property (nonatomic, strong) NSString *id;/*商品id*/

@property (nonatomic, strong) NSString *good_name;/**商品名称*/

@property (nonatomic, strong) NSString *good_price;/*商品价格*/

@property (nonatomic, strong) NSString *proxy_price;/*商品代理价格*/

@property (nonatomic, strong) NSString *num;//本地列表商品数量

@property (nonatomic, assign) BOOL isSelected;/* 本地列表商品是否选中 */

@property (nonatomic, strong) NSString *up_num;//上级库存数量

@property (nonatomic, strong) NSString *com_num;//公司库存数量

@property (nonatomic, strong) NSString *special_type;//1：不可以，2：可以（减肥单项）

@property (nonatomic, strong) NSString *give_pic;//赠送商品显示的图片

@end


@interface LxmHomeGoodsTypesModel : NSObject

@property (nonatomic, strong) NSString *id;/*商品所属分类id*/

@property (nonatomic, strong) NSString *title;/*商品所属分类标题*/

@property (nonatomic, strong) NSString *listPic;/*商品所属分类banner*/

@property (nonatomic, strong) NSArray  <LxmHomeGoodsModel *>*goodList;/*所属分类下的所有商品*/

@end

@interface LxmHomeBannerModel : NSObject

@property (nonatomic, strong) NSString *id;/*banner id*/

@property (nonatomic, strong) NSString *pic;/*banner 图片*/

@property (nonatomic, strong) NSString *info_id;/*商品 id*/

@property (nonatomic, strong) NSString *info_type;/*1：商品详情*/

@property (nonatomic, strong) NSString *content;/* 富文本 */

@end


@interface LxmHomeMapModel : NSObject

@property (nonatomic, strong) NSArray  <LxmHomeBannerModel *>*banners;/*banners*/

@property (nonatomic, strong) NSArray  <LxmHomeGoodsTypesModel *>*goodTypes;/*商品分类*/

@property (nonatomic, strong) NSString *roleType;/*代理类型 0：无，1：县代，2：市代，3：省代，4：ceo*/

@property (nonatomic, strong) NSString *depositStatus;/*2：不需要补齐保证金，1：需要*/

@end

//培训课堂model

@interface LxmClassGoodsModel : NSObject

@property (nonatomic, strong) NSString *info_type;/*1：图文教程，2：音频教程，3：视频教程*/

@property (nonatomic, strong) NSString *type_name;/*分类名称*/

@property (nonatomic, strong) NSString *list_pic;/*列表图片*/

@property (nonatomic, strong) NSString *id;/*课程id*/

@property (nonatomic, strong) NSString *title;/* 课程标题 */

@property (nonatomic, strong) NSString *content;/* 课程内容 */

@property (nonatomic, strong) NSString *status;/*  */

@end

@interface LxmClassGoodsResultModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmClassGoodsModel *>*list;

@end

@interface LxmClassRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmClassGoodsResultModel *result;

@end

//培训课堂详情model

@interface LxmClassDetailModel : NSObject

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *imagePath;

@property (nonatomic, strong) NSString *infoType;

@property (nonatomic, strong) NSString *listPic;

@property (nonatomic, strong) NSString *mp3Path;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *typeId;

@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) NSString *videoPath;

@property (nonatomic, assign) CGFloat titleH;//标题高度

@property (nonatomic, assign) CGFloat contentH;//内容高度

@end

@interface LxmClassDetailDataModel : NSObject

@property (nonatomic, strong) LxmClassDetailModel *data;

@end

@interface LxmClassDetailRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmClassDetailDataModel *result;

@end
