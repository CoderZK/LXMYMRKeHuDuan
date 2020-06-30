//
//  LxmMineModel.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMineModel.h"

@implementation LxmMineModel

@end

/**
 银行列表
 */
@implementation LxmBankModel

@end

@implementation LxmBankListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmBankModel"};
}

@end

@implementation LxmBankRootModel

@end

/**
 银行卡列表
 */
@implementation LxmMyBankModel

@end

@implementation LxmMyBankListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMyBankModel"};
}

@end

@implementation LxmMyBankRootModel

@end

/**
 我的红包
 */
@implementation LxmMyHongBaoModel

@end



@implementation LxmMyHongBaoListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMyHongBaoModel"};
}

@end

@implementation LxmMyHongBaoRootModel 

@end

@implementation LxmBaseModel 

@end

/**
 交易记录 销售收入
 */
@implementation LxmJiYiRecordModel

@end

@implementation LxmDepositMapModel

@end

@implementation LxmJiYiRecordListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmJiYiRecordModel"};
}

@end

@implementation LxmJiYiRecordRootModel

@end

/**
 物流详情
 */
@implementation LxmWuLiuInfoListModel

@synthesize cellH = _cellH;
@synthesize detailH = _detailH;

- (CGFloat)detailH {
    if (_detailH == 0) {
        CGFloat h = [self.context getSizeWithMaxSize:CGSizeMake(ScreenW - 75, 9999) withFontSize:14].height;
        _detailH = 15 + 20 + 10 + h + 15;
    }
    return _detailH;
}

- (CGFloat)cellH {
    if (_cellH == 0) {
        CGFloat h = [self.context getSizeWithMaxSize:CGSizeMake(ScreenW - 51, 9999) withFontSize:12].height;
        _cellH = 10 + h + 5 + 10 + 5;
    }
    return _cellH;
}

@end

@implementation LxmWuLiuInfoStateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmWuLiuInfoListModel"};
}

@end

@implementation LxmWuLiuInfoMapModel

@end

@implementation LxmWuLiuInfoResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmWuLiuInfoStateModel"};
}

@end

@implementation LxmWuLiuInfoRootModel

@end

@implementation LxmPushModel

@end


/**
 门店查询
 */
@implementation LxmMenDianChaXunListModel
@synthesize cellH = _cellH;
- (CGFloat)cellH {
    if (_cellH == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.province,self.city,self.district,self.address_detail];
        CGFloat H = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 60, 999) withFontSize:12].height;
        _cellH = 25 + 20 + 15 + 20 + 15 + H + 15;
    }
    return _cellH;
}

@end

@implementation LxmMenDianChaXunModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmMenDianChaXunListModel"};
}

@end

@implementation LxmMenDianChaXunRootModel

@end


@implementation LxmZhangDanDetailModel

@end
