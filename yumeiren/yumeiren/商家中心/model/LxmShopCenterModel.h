//
//  LxmShopCenterModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LxmShopCarModel.h"
/**
 我的店铺列表
 */

@interface LxmShopCenterModel : NSObject

@property (nonatomic, strong) NSString *id;/* 库存id */

@property (nonatomic, strong) NSString *good_id;/* 商品id */

@property (nonatomic, strong) NSString *good_num;/* 库存数量 */

@property (nonatomic, strong) NSString *good_name;/* 商品名称 */

@property (nonatomic, strong) NSString *proxy_price;/* 代理价格 */

@property (nonatomic, strong) NSString *create_time;/* 时间 */

@property (nonatomic, strong) NSString *list_pic;/* 缩略图 */

@property (nonatomic, strong) NSString *give_pic;/* 缩略图 */

@property (nonatomic, strong) NSString *good_price;/* 商品价格 */

@property (nonatomic, strong) NSString *order_code;/* 订单号 */

@property (nonatomic, strong) NSString *order_id;/* 订单号 */

@property (nonatomic, strong) NSString *num;/* 变动数量 */

@property (nonatomic, strong) NSString *info_type;/* 1：采购入库，2：销售出库，3：自提出库 4后台入库 5 后台扣除*/

@property (nonatomic, assign) BOOL isSelected;/* 是否选中 */

@property (nonatomic, strong) NSString *tempbuhuoNum;/* 补货数量 */

@property (nonatomic, strong) NSString *buhuoNum;/* 补货数量 */

@property (nonatomic, assign) BOOL isBuhuo;/* 是否需要补货 */

@property (nonatomic, strong) NSString *special_type;//1：不可以，2：可以（减肥单项）

@end


@interface LxmShopCenterListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmShopCenterModel *>*list;/* 库存列表 */

@property (nonatomic, strong) NSString *data;/**满邮金额*/

@end


@interface LxmShopCenterRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopCenterListModel *result;/**结果*/

@end


/**
 商家个人中心
 */
@interface LxmShopCenterUserInfoModel : NSObject

@property (nonatomic, strong) NSString *id;/* 用户id */

@property (nonatomic, strong) NSString *username;/* 姓名 */

@property (nonatomic, strong) NSString *userHead;/* 头像 */

@property (nonatomic, strong) NSString *chatCode;/* 微信号 */

@property (nonatomic, strong) NSString *authorPic;/* 授权图片 */

@property (nonatomic, strong) NSString *deposit;/* 保证金 */

@property (nonatomic, strong) NSString *telephone;/* 手机号 */

@property (nonatomic, strong) NSString *recoCode;/* 授权码 */

@property (nonatomic, strong) NSString *roleType;/* 0：无，1：县代，2：市代，3：省代，4：ceo */

@property (nonatomic, strong) NSString *balance;/* 余额 */

@property (nonatomic, strong) NSString *redBalance;/* 红包余额 */

@property (nonatomic, strong) NSString *noReadNum;/* 未读消息数量 */

@property (nonatomic, strong) NSString *sex;/* 0-未设置，1-男，2-女 */

@end


@interface LxmShopCenterUserListModel : NSObject

@property (nonatomic, strong) NSString *infoType;/* 1:月度，2：季度 */

@property (nonatomic, strong) NSString *currentYear;/* 当前年份 */

@property (nonatomic, strong) NSString *endMonth;/* 季度结束月份 */

@property (nonatomic, strong) NSString *finishMoney;/* 完成金额 */

@property (nonatomic, strong) NSString *fromMonth;/* 季度起始月份 */

@property (nonatomic, strong) NSString *inMonth;/* 阅读所属月份 */

@property (nonatomic, strong) NSString *quarter;/* 第几季度 */

@property (nonatomic, strong) NSString *targetMoney;/* 目标金额 */

@end



/**
 收货地址
 */
@interface LxmAddressModel : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *username;/* 收货人姓名 */

@property (nonatomic, strong) NSString *telephone;/* 收货人手机号 */

@property (nonatomic, strong) NSString *province;/* 省 */

@property (nonatomic, strong) NSString *city;/* 市 */

@property (nonatomic, strong) NSString *district;/* 区 */

@property (nonatomic, strong) NSString *addressDetail;/* 详情地址 */

@property (nonatomic, strong) NSString *defaultStatus;/* 1：不是默认，2：是默认 */

@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface LxmAddressListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmAddressModel *>*list;/* 地址列表 */

@end


@interface LxmAddressRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmAddressListModel *result;/**结果*/

@end

/**
 商家中心 订单列表
 */

@interface LxmShopCenterOrderGoodsModel : NSObject

@property (nonatomic, strong) NSString *good_price;/* 商品价格 */

@property (nonatomic, strong) NSString *good_id;/* 商品id */

@property (nonatomic, strong) NSString *good_name;/* 商品名称 */

@property (nonatomic, strong) NSString *list_pic;/* 商品图片 */

@property (nonatomic, strong) NSString *num;/* 商品数量 */

@property (nonatomic, strong) NSString *proxy_price;/* 商品代理价 */

@end

@interface LxmShopCenterAcGoodsModel : NSObject
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *good_pic;
@property (nonatomic, strong) NSString *good_name;
@end


@interface LxmShopCenterOrderModel : NSObject

@property (nonatomic, strong) NSString *role_type;/* 等级*/

@property (nonatomic, strong) NSString *order_code;/* 订单号 */

@property (nonatomic, strong) NSString *t_name;/* 补货人姓名 */

@property (nonatomic, strong) NSString *t_tel;/* 补货人手机号 */

@property (nonatomic, strong) NSString *id;/* 订单id */

@property (nonatomic, strong) NSString *status;/* 1：待支付，2：待发货，3：待补货，4：已完成，5：已取消 */

@property (nonatomic, strong) NSString *total_money;/* 订单金额 */

@property (nonatomic, strong) NSString *province;/* 省 */

@property (nonatomic, strong) NSString *postage_type;/* 1：自提，2：快递 */

@property (nonatomic, strong) NSString *city;/* 市 */

@property (nonatomic, strong) NSString *district;/* 区 */

@property (nonatomic, strong) NSString *address_detail;/* 详情地址 */

@property (nonatomic, strong) NSString *username;/* 收货人姓名 */

@property (nonatomic, strong) NSString *telephone;/* 收货人手机号 */

@property (nonatomic, strong) NSArray  <LxmShopCenterOrderGoodsModel *>*sub;/* 商品列表 */

@property (nonatomic, strong) NSArray  <LxmShopCenterOrderGoodsModel *>*sub2;/* 商品列表 */

@property (nonatomic, strong) NSArray  <LxmShopCenterAcGoodsModel *>*sends;/* 商品列表 */

@property (nonatomic, strong) NSString *create_time;/* 下单时间 */

@property (nonatomic, strong) NSString * postage_status; /* 1：免邮，2：不免 */

@property (nonatomic, strong) NSString *address_id;/* 下单地址id */

@property (nonatomic, strong) NSString *user_id;/* 用户id */

@property (nonatomic, strong) NSString *order_type;/*  1-发货订单，2-批发销售，3-批发采购  */

@property (nonatomic, strong) NSString *postage_code;/* 物流单号 */

@property (nonatomic, assign) BOOL isSelected;/* 是否选中 */

@property (nonatomic, assign) BOOL isShiFu;/* 是否是实付的金额 */

@property (nonatomic, strong) NSString *order_info;/* 备注 */

@property (nonatomic, assign) CGFloat orderHeight;/* 备注高度 */

/* 补货订单详情 */
@property (nonatomic, strong) NSArray  <LxmShopCenterOrderModel *>*orders;/* 订单详情 */

@property (nonatomic, assign) CGFloat addressHeight;

@end


@interface LxmShopCenterOrderListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmShopCenterOrderModel *>*list;/* 订单列表 */

@end


@interface LxmShopCenterOrderRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopCenterOrderListModel *result;/**结果*/

@end

/**
 补货详情
 */
@interface LxmBuhuoDetailModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) LxmShopCenterOrderModel *map;/* 订单信息 */

@end

@interface LxmBuhuoDetailRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmBuhuoDetailModel *result;/**结果*/

@end


/**
 订单详情
 */
@interface LxmShopCenterOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) LxmShopCenterOrderModel *map;/* 订单信息 */

@end

@interface LxmShopCenterOrderDetailRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmShopCenterOrderDetailModel *result;/**结果*/

@end

/**
 我的业绩汇总
 */
@interface LxmMyYeJiModel : NSObject

@property (nonatomic, strong) NSString *monthSaleMoney;/* 本月销售 */

@property (nonatomic, strong) NSString *monthSaleIn;/* 本月进货 */

@property (nonatomic, strong) NSString *monthSaleLi;/* 本月利润 */

@property (nonatomic, strong) NSString *groupTotal;/* 团队总业绩 */

@property (nonatomic, strong) NSString *rank;/* 同级别业绩排名 */

@end

@interface LxmMyYeJiMapModel : NSObject

@property (nonatomic, strong) LxmMyYeJiModel *map;/* 业绩model */

@end

@interface LxmMyYeJiRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyYeJiMapModel *result;/**结果*/

@end

/**
 我的业绩
 */
@interface LxmMyYeJiListModel : NSObject

@property (nonatomic, strong) NSString *userHead;/* 用户头像 */

@property (nonatomic, strong) NSString *username;/* 用户名 */

@property (nonatomic, strong) NSString *roleType;/* 0：无，1：县代，2：市代，3：省代，4：ceo */

@property (nonatomic, strong) NSString *targetM;/* 目标金额 */

@property (nonatomic, strong) NSString *saleM;/* 完成金额 */

@property (nonatomic, strong) NSString *id;/* 列表id */

@end

@interface LxmMyYeJiListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMyYeJiListModel *>*list;/* 业绩列表 */

@end

@interface LxmMyYeJiListRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyYeJiListModel1 *result;/**结果*/

@end

/**
 我的团队汇总
 */
@interface LxmMyTeamModel : NSObject

@property (nonatomic, strong) NSString *monthIn;/* 本月新增 */

@property (nonatomic, strong) NSString *groupTotal;/* 团队全部 */

@property (nonatomic, strong) NSString *firstT;/* 直属 */

@property (nonatomic, strong) NSString *secondT;/* 非直属 */

@property (nonatomic, strong) NSString *roleType;/* 代理类型 */

@property (nonatomic, strong) NSString *saleTotal;/* 业绩 */

@end

@interface LxmMyTeamMapModel : NSObject

@property (nonatomic, strong) LxmMyTeamModel *map;/* 业绩model */

@end

@interface LxmMyTeamRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyTeamMapModel *result;/**结果*/

@end

/**
 我的团队
 */
@interface LxmMyTeamListModel : NSObject

@property (nonatomic, strong) NSString *userHead;/* 用户头像 */

@property (nonatomic, strong) NSString *username;/* 用户名 */

@property (nonatomic, strong) NSString *id;/* 用户id */

@property (nonatomic, strong) NSString *roleType;/* 0：无，1：县代，2：市代，3：省代，4：ceo */

@property (nonatomic, strong) NSString *recommendCode;/* 授权码 */

@property (nonatomic, strong) NSString *firstN;/* 直属数量 */


@end

@interface LxmMyTeamListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMyTeamListModel *>*list;/* 团队列表 */

@end

@interface LxmMyTeamListRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyTeamListModel1 *result;/**结果*/

@end


/**
 查看他人的信息
 */
@interface LxmSeeOtherInfoModel : NSObject

@property (nonatomic, strong) NSString *userHead;/* 用户头像 */

@property (nonatomic, strong) NSString *username;/* 用户名 */

@property (nonatomic, strong) NSString *roleType;/* 0：无，1：县代，2：市代，3：省代，4：ceo */

@property (nonatomic, strong) NSString *telephone;/* 手机号 */

@property (nonatomic, strong) NSString *chatCode;/* 微信号 */

@property (nonatomic, strong) NSString *recommendCode;/* 授权码 */

@property (nonatomic, strong) NSString *recommendName;/* 推荐人姓名 */

@property (nonatomic, strong) NSString *firstName;/* 上级名称 */

@property (nonatomic, strong) NSString *monthM;/* 本月 */

@property (nonatomic, strong) NSString *totalM;/* 累计 */

@end

@interface LxmSeeOtherInfoMapModel : NSObject

@property (nonatomic, strong) LxmSeeOtherInfoModel *map;/* 业绩model */

@end

@interface LxmSeeOtherInfoRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmSeeOtherInfoMapModel *result;/**结果*/

@end

/**
 我的仓库汇总
 */
@interface LxmMyCangKuContentModel : NSObject

@property (nonatomic, strong) NSString *goodNum;/** 商品数量 */

@property (nonatomic, strong) NSString *stockNum;/** 库存数量 */

@end

@interface LxmMyCangKuContentMapModel : NSObject

@property (nonatomic, strong) LxmMyCangKuContentModel *map;

@end

@interface LxmMyCangKuContentRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyCangKuContentMapModel *result;/**结果*/

@end

/**
 消息首页
 */
@interface LxmNoticeIndexModel : NSObject

@property (nonatomic, strong) NSString *info_type;/**1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息*/

@property (nonatomic, strong) NSString *title;/**消息内容*/

@property (nonatomic, strong) NSString *create_time;/**消息时间*/

@end

@interface LxmNoticeListModel : NSObject

@property (nonatomic, strong) NSArray  <LxmNoticeIndexModel *>*list;/* 消息首页list */

@end

@interface LxmNoticeRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmNoticeListModel *result;/**结果*/

@end
/**
 消息列表
 */
@interface LxmMsgModel : NSObject

@property (nonatomic, strong) NSString *id;/* 消息id */

@property (nonatomic, strong) NSString *title;/** 标题 */

@property (nonatomic, strong) NSString *create_time;/** 时间 */

@property (nonatomic, strong) NSString *des;/** 简介 */

@property (nonatomic, strong) NSString *read_status;/** 1-未读，2-已读 */

@property (nonatomic, strong) NSString *info_url;/** 如果有就跳转网页  系统通知会返回 */

@property (nonatomic, strong) NSString *info_id;/** 如果有，就根据类型跳转对应的详情， 订单类型的会有。 */

@property (nonatomic, strong) NSString *info_type;/** 1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息 */

@property (nonatomic, strong) NSString *second_type;
/** 21- 新代理 22-老代理升级 31-采购 32-销售 33-提现 34-充值 35-保证金变动 36-转账变动 41-接单相关 51-批量购进 52-批量销售 53-补货单相关 61-投诉相关 71-红包奖励 - 要做拆红包特效 72-素材其他类型 */

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, assign) CGFloat cellH1;

@end

@interface LxmMsgListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMsgModel *>*list;/* 消息list */

@end

@interface LxmMsgRootModel : NSObject

@property (nonatomic, strong) NSString *key; /** 总页数 */

@property (nonatomic, strong) NSString *message; /** 总数 */

@property (nonatomic, strong) LxmMsgListModel *result; /* 结果 */

@end

/**
 一键补货
 */
@interface LxmBuHuoModel : NSObject

@property (nonatomic, strong) NSString *needPay;/* 1-需要支付，2-不需要已经完成 */

@property (nonatomic, strong) NSString *orderId;/* 订单id */

@property (nonatomic, strong) NSString *price;/* 待支付总金额 */

@property (nonatomic, strong) NSString *balance;/* 余额 */

@property (nonatomic, strong) NSString *lowMoney;/* 最低下单金额 */

@end

@interface LxmBuHuoMapModel : NSObject

@property (nonatomic, strong) LxmBuHuoModel *map;/* map model */

@property (nonatomic, strong) NSArray  <LxmShopCarModel *>*list;/* 商品列表 */

@end

@interface LxmBuHuoRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmBuHuoMapModel *result;/**结果*/

@end

//年度考核

@interface LxmNianDuKaoHeModel : NSObject

@property (nonatomic, strong) NSString *end_day;/* 结束日期*/

@property (nonatomic, strong) NSString *begin_day;/* 开始日期*/

@property (nonatomic, strong) NSString *yearMoney;/* 指标*/

@property (nonatomic, strong) NSString *in_money;/* 业绩*/

@property (nonatomic, strong) NSString *userHead;/* 头像*/

@property (nonatomic, strong) NSString *telephone;/* 手机号*/

@property (nonatomic, strong) NSString *username;/* 名字*/

@property (nonatomic, strong) NSString *roleType;/* 角色*/

@property (nonatomic, strong) NSString *id;/* 名字*/

@end

@interface LxmNianDuKaoHeMapModel : NSObject

@property (nonatomic, strong) LxmNianDuKaoHeModel *map;/* map model */

@end


@interface LxmNianDuKaoHeRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmNianDuKaoHeMapModel *result;/**结果*/

@end


/**
 年度考核列表
 */

@interface LxmNianDuKaoHeListModel1 : NSObject

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray  <LxmNianDuKaoHeModel *>*list;

@end

@interface LxmNianDuKaoHeListRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LxmNianDuKaoHeListModel1 *result;

@end
