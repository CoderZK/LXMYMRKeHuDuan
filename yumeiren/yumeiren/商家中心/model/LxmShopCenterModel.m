//
//  LxmShopCenterModel.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCenterModel.h"

/**
 我的店铺列表
 */

@implementation LxmShopCenterModel

@end

@implementation LxmShopCenterListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShopCenterModel"};
}

@end

@implementation LxmShopCenterRootModel

@end

/**
 商家个人中心
 */
@implementation LxmShopCenterUserInfoModel

@end

@implementation LxmShopCenterUserListModel

@end


/**
 收货地址
 */
@implementation LxmAddressModel

@synthesize cellHeight = _cellHeight;
- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",self.province, self.city, self.district, self.addressDetail];
        CGFloat w = 0;
        if (self.defaultStatus.intValue == 1) {//不是默认
            w = ScreenW - 80 - 15;
        } else {//默认
            w = ScreenW - 80 - 70;
        }
        _cellHeight = [str getSizeWithMaxSize:CGSizeMake(w, 999) withFontSize:14].height + 15 + 20 + 10 + 15 ;
    }
    return _cellHeight;
}

@end


@implementation LxmAddressListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmAddressModel"};
}

@end


@implementation LxmAddressRootModel

@end

/**
 商家中心 订单列表
 */

@implementation LxmShopCenterOrderGoodsModel

@end


@implementation LxmShopCenterOrderModel

@synthesize orderHeight = _orderHeight;

@synthesize addressHeight = _addressHeight;

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"sub" : @"LxmShopCenterOrderGoodsModel",
             @"orders" : @"LxmShopCenterOrderModel",
             @"sends" : @"LxmShopCenterAcGoodsModel"
             };
}

- (CGFloat)orderHeight {
    if (_orderHeight == 0) {
        _orderHeight = [self.order_info getSizeWithMaxSize:CGSizeMake(ScreenW - 45 - 40, 9999) withFontSize:13].height + 30;
    }
    return _orderHeight;
}

- (NSArray<LxmShopCenterOrderGoodsModel *> *)sub2 {
    if (_sub2.count == 0) {
        if (self.sub.count > 2) {
            _sub2 = [self.sub subarrayWithRange:NSMakeRange(0, 2)];
        } else {
            _sub2 = self.sub;
        }
    }
    return _sub2;
}

- (CGFloat)addressHeight {
    if (_addressHeight == 0) {
        NSString *ss = [NSString stringWithFormat:@"%@ %@ %@ %@",self.province, self.city, self.district, self.address_detail];
        if (self.postage_status.intValue == 2 && self.status.intValue == 2) {
            //待确认发货 切是快递的
            _addressHeight = [ss getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 9999) withFontSize:14].height + 60;
            
        } else {
            _addressHeight = [ss getSizeWithMaxSize:CGSizeMake(ScreenW - 55, 9999) withFontSize:14].height + 60;
        }
    }
    return _addressHeight;
}


@end

@implementation LxmShopCenterOrderListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShopCenterOrderModel"};
}

@end

@implementation LxmShopCenterOrderRootModel

@end

/**
 补货详情
 */
@implementation LxmBuhuoDetailModel

@end

@implementation LxmBuhuoDetailRootModel

@end

/**
 订单详情
 */
@implementation LxmShopCenterOrderDetailModel

@end

@implementation LxmShopCenterOrderDetailRootModel 

@end

/**
 我的业绩汇总
 */
@implementation LxmMyYeJiModel

@end

@implementation LxmMyYeJiMapModel

@end

@implementation LxmMyYeJiRootModel 

@end

/**
 我的业绩
 */
@implementation LxmMyYeJiListModel

@end

@implementation LxmMyYeJiListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMyYeJiListModel"};
}

@end

@implementation LxmMyYeJiListRootModel

@end

/**
 我的团队汇总
 */
@implementation LxmMyTeamModel

@end

@implementation LxmMyTeamMapModel

@end

@implementation LxmMyTeamRootModel 

@end

/**
 我的团队
 */
@implementation LxmMyTeamListModel

@end

@implementation LxmMyTeamListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMyTeamListModel"};
}

@end

@implementation LxmMyTeamListRootModel 

@end

/**
 查看他人的信息
 */
@implementation LxmSeeOtherInfoModel

@end

@implementation LxmSeeOtherInfoMapModel

@end

@implementation LxmSeeOtherInfoRootModel

@end

/**
 我的仓库汇总
 */
@implementation LxmMyCangKuContentModel

@end

@implementation LxmMyCangKuContentMapModel

@end

@implementation LxmMyCangKuContentRootModel 

@end

/**
 消息首页
 */
@implementation LxmNoticeIndexModel

@end

@implementation LxmNoticeListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmNoticeIndexModel"};
}

@end

@implementation LxmNoticeRootModel

@end

/**
 消息列表
 */
@implementation LxmMsgModel
@synthesize cellH = _cellH;
@synthesize cellH1 = _cellH1;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"des" : @"description"};
}

- (CGFloat)cellH {
    if (_cellH == 0) {
        CGFloat titleH = [self.title getSizeWithMaxSize:CGSizeMake(ScreenW - 66, 9999) withBoldFontSize:15].height;
        CGFloat detailH = [self.des getSizeWithMaxSize:CGSizeMake(ScreenW - 60, 9999) withBoldFontSize:13].height;
        _cellH = 40 + 15 + titleH + 10 + detailH + 15 + 40;
    }
    return _cellH;
}

- (CGFloat)cellH1 {
    if (_cellH1 == 0) {
        CGFloat titleH1 = [self.title getSizeWithMaxSize:CGSizeMake(ScreenW - 66, 9999) withBoldFontSize:15].height;
        CGFloat detailH1 = [self.des getSizeWithMaxSize:CGSizeMake(ScreenW - 60, 9999) withBoldFontSize:13].height;
        _cellH1 = 40 + 15 + titleH1 + 10 + detailH1 + 15;
    }
    return _cellH1;
}

@end

@implementation LxmMsgListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMsgModel"};
}

@end

@implementation LxmMsgRootModel

@end

/**
 一键补货
 */
@implementation LxmBuHuoModel

@end

@implementation LxmBuHuoMapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShopCarModel"};
}

@end

@implementation LxmBuHuoRootModel

@end

@implementation LxmShopCenterAcGoodsModel

@end

//年度考核



@implementation LxmNianDuKaoHeModel

@end

@implementation LxmNianDuKaoHeMapModel

@end


@implementation LxmNianDuKaoHeRootModel

@end

/**
 年度考核列表
 */

@implementation LxmNianDuKaoHeListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmNianDuKaoHeModel"};
}

@end

@implementation LxmNianDuKaoHeListRootModel

@end
