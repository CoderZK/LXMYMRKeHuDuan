//
//  LxmHomeModel.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHomeModel.h"

@implementation LxmHomeModel

@end

/**
 发布投诉
 */

@implementation LxmPublishTouSutModel

@end


/**
 投诉中心列表
 */
@implementation LxmTouSuListModel : NSObject

@end

@implementation LxmTouSuListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmTouSuListModel"};
}

@end

@implementation LxmTouSuListRootModel

@end

/**
 投诉详情
 */
@implementation LxmTouSuRecordModel

@end

@implementation LxmTouSuDetailModel

@synthesize commetH = _commetH;

- (CGFloat)commetH {
    if (_commetH == 0) {
        _commetH = [self.commend getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height + 30;
    }
    return _commetH;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"details" : @"LxmTouSuRecordModel"};
}

@end

/**
 素材中心
 */
@implementation LxmSuCaiContentTypeListModel

@end

@implementation LxmSuCaiContentTypeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmSuCaiContentTypeListModel"};
}

@end

@implementation LxmSuCaiContentTypeRootModel

@end

/**
 素材列表
 */

@implementation LxmSuCaiListModel

@end

@implementation LxmSuCaiListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmSuCaiListModel"};
}

@end

@implementation LxmSuCaiListRootModel 

@end

/**
 接单平台
 */

@implementation LxmJieDanPublishModel

@end

@implementation LxmJieDanPublishModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmJieDanPublishModel"};
}

@end

@implementation LxmJieDanPublishRootModel

@end


@implementation LxmJieDanListModel

- (NSString *)takeTime {
    if (!_takeTime) {
        _takeTime = @"";
    }
    return _takeTime;
}

@end

@implementation LxmJieDanListModel1

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmJieDanListModel"};
}

@end

@implementation LxmJieDanListRootModel 

@end

/**
 首页
 */
@implementation LxmHomeGoodsModel
@synthesize num = _num;

- (NSString *)num {
    if (!_num) {
        _num = @"0";
    }
    return _num;
}

MJCodingImplementation

@end

@implementation LxmHomeGoodsTypesModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodList" : @"LxmHomeGoodsModel"};
}

@end

@implementation LxmHomeBannerModel

@end


@implementation LxmHomeMapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"banners" : @"LxmHomeBannerModel",
             @"goodTypes" : @"LxmHomeGoodsTypesModel"
             };
}

@end

//培训课堂model

@implementation LxmClassGoodsModel

@end

@implementation LxmClassGoodsResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LxmClassGoodsModel"
             };
}

@end

@implementation LxmClassRootModel

@end

//培训课堂详情model

@implementation LxmClassDetailModel

@synthesize titleH = _titleH;
@synthesize contentH = _contentH;

- (CGFloat)titleH {
    if (_titleH == 0) {
        CGFloat H = [self.title getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withBoldFontSize:18].height;
        _titleH = 15 + H + 15;
    }
    return _titleH;
}

- (CGFloat)contentH {
    if (_contentH == 0) {
        CGFloat H = [self.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:13].height;
        _contentH = 15 + H + 15;
    }
    return _contentH;
}


@end

@implementation LxmClassDetailDataModel

@end

@implementation LxmClassDetailRootModel 

@end
