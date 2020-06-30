//
//  LxmPayVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmPayCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIImageView *selectImgView;//选择

@property (nonatomic, strong) UIView *lineView;//线

@end

typedef NS_ENUM(NSInteger, LxmPayVC_type) {
    LxmPayVC_type_jiaobaozhengjin,//交保证金
    LxmPayVC_type_bujiaobaozhengjin,//补交保证金
    LxmPayVC_type_gwcJieSuan,//购物车结算
    LxmPayVC_type_ddcx,//订单查询
    LxmPayVC_type_zjgm,//商品详情 直接购买
    LxmPayVC_type_yjbh,//一件补货支付补货订单
    LxmPayVC_type_wfbd,//接单平台 我发布的
    LxmPayVC_type_jiajia,//接单平台 加价
    LxmPayVC_type_shengjigouwu//升级购物
};

@interface LxmPayVC : BaseTableViewController

@property (nonatomic, strong) NSString *recommend_code;//推荐码

@property (nonatomic, strong) NSString *creatTime;//倒计时时间

@property (nonatomic, assign) BOOL isDDcxDetail;

@property (nonatomic, assign) BOOL isShengji;//无身份 升级中的单子

@property (nonatomic, assign) BOOL isBuJiao;

@property (nonatomic, strong) LxmJieDanListModel *jiajiaModel;//加价

@property (nonatomic, strong) NSString *jiajiaPrice;//加价金额

@property (nonatomic, strong) NSString *wfbdMoney;//我发布的 待支付

@property (nonatomic, strong) NSString *wfbdID;//我发布的id

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;//保证金model

@property (nonatomic, strong) LxmShopCarOrderModel *orderModel;//购物车结算model

@property (nonatomic, strong) NSString *shifuMoney;//订单查询 实付金额

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *zhijieGoumaiMoney;//订单查询 实付金额

@property (nonatomic, strong) LxmBuHuoModel *buhuoModel;//一件补货需要支付的钱数

@property (nonatomic, strong) LxmBuHuoModel *shengjiGouwuModel;//升级购物需要支付的钱数

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPayVC_type)type;

@end

NS_ASSUME_NONNULL_END
