//
//  LxmMineModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmMineModel : NSObject

@end

/**
 银行列表
 */
@interface LxmBankModel : NSObject

@property (nonatomic, strong) NSString *bankName;/* 银行名称 */

@property (nonatomic, strong) NSString *id;/* 银行id */

@property (nonatomic, assign) BOOL isSelected;//是否选中

@end

@interface LxmBankListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmBankModel *>*list;/*银行列表*/

@end

@interface LxmBankRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmBankListModel *result;/**结果*/

@end

/**
 银行卡列表
 */
@interface LxmMyBankModel : NSObject

@property (nonatomic, strong) NSString *bankName;/* 银行名称 */

@property (nonatomic, strong) NSString *openBank;/* 开户行 */

@property (nonatomic, strong) NSString *username;/* 留存姓名 */

@property (nonatomic, strong) NSString *bankCode;/* 银行卡号 */

@property (nonatomic, strong) NSString *id;/* 银行卡id */

@end

@interface LxmMyBankListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMyBankModel *>*list;/*银行列表*/

@end

@interface LxmMyBankRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyBankListModel *result;/**结果*/

@end


/**
 我的红包
 */
@interface LxmMyHongBaoModel : NSObject

@property (nonatomic, strong) NSString *createTime;/* 记录时间 */

@property (nonatomic, strong) NSString *getMoney;/* 多少钱 */

@property (nonatomic, strong) NSString *infoType;/* 1 2 */

@end

@interface LxmMyHongBaoListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMyHongBaoModel *>*list;/*银行列表*/

@end

@interface LxmMyHongBaoRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMyHongBaoListModel *result;/**结果*/

@end

@interface LxmBaseModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) NSString *result;/**结果*/

@end

/**
 交易记录 销售收入
 */
@interface LxmJiYiRecordModel : NSObject

@property (nonatomic, strong) NSString *status;/* 11:批发采购结算中 12：批发采购已完成 21:销售已完成 32：充值已完成 41：转账已完成 51：红包转让已完成  52:红包转出 61：接单收入已完成 71：接单退回 81：公司返款已完成 91:保证金加 92：保证金减 101：充值已完成 111:提现中 112：提现成功 113：提现失败 121：后台扣款已完成*/

@property (nonatomic, strong) NSString *create_time;/* 记录时间 */

@property (nonatomic, strong) NSString *info_money;/* 金额 */

@property (nonatomic, strong) NSString *order_code;/* 订单号 */

@property (nonatomic, strong) NSString *info_type;/* 1-批发采购，2-批发销售，3-充值，4-转账，5-红包，6-接单收入，7-接单退回，8-公司返款，9-保证金，10-后台充值，11-提现,12-后台扣款 */

@property (nonatomic, strong) NSString *changeMoney;/* 金额 */

@property (nonatomic, strong) NSString *createTime;/* 金额 */

@property (nonatomic, strong) NSString *infoType;/* 1：获得，2：扣除 */

@property (nonatomic, strong) NSString *content;/* 金额 */

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *info_id;

@end

@interface LxmDepositMapModel : NSObject

@property (nonatomic, strong) NSString *depositNeed;/* 需要满足的保证金 */

@property (nonatomic, strong) NSString *deposit;/* 当前保证金 */

@end


@interface LxmJiYiRecordListModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmJiYiRecordModel *>*list;/*列表*/

@property (nonatomic, strong) LxmDepositMapModel *map;/*map*/

@end

@interface LxmJiYiRecordRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmJiYiRecordListModel *result;/**结果*/

@end


/**
 物流详情
 */
@interface LxmWuLiuInfoListModel : NSObject

@property (nonatomic, strong) NSString *create_time;/**时间*/

@property (nonatomic, strong) NSString *context;/**描述*/

@property (nonatomic, strong) NSString *year;/** 年 */

@property (nonatomic, strong) NSString *diff;/** 时间 */

@property (nonatomic, strong) NSString *day;/** 月日 */

@property (nonatomic, strong) NSString *time;/** 时间 */

@property (nonatomic, assign) CGFloat detailH;

@property (nonatomic, assign) CGFloat cellH;

@end

@interface LxmWuLiuInfoStateModel : NSObject

@property (nonatomic, strong) NSString *title;/** 标题 */

@property (nonatomic, strong) NSArray  <LxmWuLiuInfoListModel *>*list;/* 订单列表 */

@end


@interface LxmWuLiuInfoMapModel : NSObject

@property (nonatomic, strong) NSString *orderCode;/**订单号*/

@property (nonatomic, strong) NSString *company;/**物流公司*/

@property (nonatomic, strong) NSString *status;/**1：待支付，2：待发货，3：待确认收货,4:待补货，5：已完成，6：已取消*/
@end

@interface LxmWuLiuInfoResultModel : NSObject

@property (nonatomic, strong) NSArray  <LxmWuLiuInfoStateModel *>*list;/* 物流列表 */

@property (nonatomic, strong) LxmWuLiuInfoMapModel *map;/* 订单信息 */

@end


@interface LxmWuLiuInfoRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmWuLiuInfoResultModel *result;/**结果*/

@end


@interface LxmPushModel : NSObject

@property (nonatomic, strong) NSString *d;/** 友盟id */

@property (nonatomic, strong) NSString *p;/** 0 */

@property (nonatomic, strong) NSString *infoType;/** 1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息 */

@property (nonatomic, strong) NSString *infoUrl;/** 系统通知跳转的url */

@property (nonatomic, strong) NSString *secondType;/**  */

@property (nonatomic, strong) NSString *infoId;/** 跳转到的id */

@end


/**
 门店查询
 */
@interface LxmMenDianChaXunListModel : NSObject

@property (nonatomic, strong) NSString *address_detail;/** 详细地址 */

@property (nonatomic, strong) NSString *city;/** 城市 */

@property (nonatomic, strong) NSString *district;/** 区 */

@property (nonatomic, strong) NSString *latitude;/** 维度*/

@property (nonatomic, strong) NSString *longitude;/** 经度 */

@property (nonatomic, strong) NSString *distance;/** 距离 */

@property (nonatomic, strong) NSString *province;/** 省 */

@property (nonatomic, strong) NSString *show_name;/** 名称 */

@property (nonatomic, assign) CGFloat cellH;

@end

@interface LxmMenDianChaXunModel : NSObject

@property (nonatomic, strong) NSString *allPageNumber;/**总页数*/

@property (nonatomic, strong) NSString *count;/**总数*/

@property (nonatomic, strong) NSArray  <LxmMenDianChaXunListModel *>*list;/*列表*/

@end

@interface LxmMenDianChaXunRootModel : NSObject

@property (nonatomic, strong) NSString *key;/**总页数*/

@property (nonatomic, strong) NSString *message;/**总数*/

@property (nonatomic, strong) LxmMenDianChaXunModel *result;/**结果*/

@end

/**
 账单详情
 */
@interface LxmZhangDanDetailModel : NSObject

@property (nonatomic, strong) NSString *time;/** 时间戳 */

@property (nonatomic, strong) NSString *money;/** 金额 */

@property (nonatomic, strong) NSString *toName;/** 转到的人 */

@property (nonatomic, strong) NSString *fromName;/** 发起的人 */

@property (nonatomic, strong) NSString *type;/** 1-转出，2：转入 */

@property (nonatomic, strong) NSString *create_time;/** 充值时间 提现时间*/

@property (nonatomic, strong) NSString *status;/** 1：充值中，2：充值完成，3：充值失败 1：审核中，2：审核成功，3：审核失败 */

@property (nonatomic, strong) NSString *pay_money;/** 充值金额 提现金额*/

@property (nonatomic, strong) NSString *pay_type;/** 1：支付宝，2：微信 */

@property (nonatomic, strong) NSString *third_code;/** 第三方流水号 */

@property (nonatomic, strong) NSString *order_code;/** 系统订单号 */

@property (nonatomic, strong) NSString *open_bank;/** 开户行 */

@property (nonatomic, strong) NSString *bank_code;/** 银行卡号 */

@end

