//
//  LxmTool.h
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmUserInfoModel.h"
#import "LxmHomeModel.h"

@interface LxmTool : NSObject
+(LxmTool *)ShareTool;

@property (nonatomic, strong) NSArray <LxmHomeGoodsModel *>*goodsList;/* 选中商品列表 */

@property (nonatomic, strong) NSArray <LxmHomeGoodsModel *>*shengjiGoodsList;/* 升级选中商品列表 */

/**
 保存到本地
 */
- (void)saveSubGoods:(LxmHomeGoodsModel *)goods;

/**
 删除本地
 */
- (void)delSubGoods:(LxmHomeGoodsModel *)goods;

/**
 本地商品数据全部删除
 */
- (void)delAllGoods;

/**
 保存升级货物到本地
 */
- (void)saveShengJiSubGoods:(LxmHomeGoodsModel *)goods;

/**
 删除本地升级货物
 */
- (void)delShengJiSubGoods:(LxmHomeGoodsModel *)goods;

/**
 本地升级货物商品数据全部删除
 */
- (void)delShengJiAllGoods;


@property(nonatomic,assign)bool isLogin;
@property(nonatomic,strong)NSString * session_uid;
@property(nonatomic,strong)NSString * session_token;

@property (nonatomic,strong)LxmUserInfoModel * userModel;

//推送token
@property(nonatomic,strong)NSString * deviceToken;

@property(nonatomic,strong)NSString * pushToken;


-(void)uploadDeviceToken;

@end
