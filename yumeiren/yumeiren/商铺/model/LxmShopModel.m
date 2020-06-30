//
//  LxmShopModel.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopModel.h"

@implementation LxmShopModel

@end

/**
 商铺商品列表页
 */
@implementation LxmShopListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmHomeGoodsModel"};
}

@end

@implementation LxmShopListRootModel 

@end

/**
 商品详情
 */
@implementation LxmGoodsDetailModel
@synthesize titleH = _titleH;
@synthesize num = _num;


- (NSString *)num {
    if (!_num) {
        _num = @"1";
    }
    return _num;
}


- (CGFloat)titleH {
    if (_titleH == 0) {
        _titleH = [self.goodName getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withBoldFontSize:15].height + 65;
    }
    return _titleH;
}


@end

@implementation LxmGoodsDetailModel1

@end

/**
 图片
 */
@implementation LxmGoodsDetailTuPianModel

//@synthesize width = _width;
//
//@synthesize height = _height;
//
//- (CGFloat)width {
//    if (_width == 0) {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
//        UIImage *image = [UIImage imageWithData:data];
//        _width = image.size.width;
//    }
//    return _width;
//}
//
//- (CGFloat)height {
//    if (_height == 0) {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
//        UIImage *image = [UIImage imageWithData:data];
//        _height = image.size.height;
//    }
//    return _height;
//}

@end


/**
 我要升级
 */
@implementation LxmShengjiModel

@end

@implementation LxmShengjiLsitModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"LxmShengjiModel"};
}

@end

@implementation LxmShengjiRootModel

@end
