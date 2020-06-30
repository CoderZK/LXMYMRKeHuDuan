//
//  LxmShopView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmShopView : UIView

@end

/**
 价格 名称
 */
@interface LxmGoodsDetailPriceCell : UITableViewCell

@property (nonatomic, strong) LxmGoodsDetailModel *detailModel;//商品详情

@end

/**
 运费
 */
@interface LxmGoodsDetailPeiSongCell : UITableViewCell

@property (nonatomic, strong) LxmGoodsDetailModel1 *detailModel;

@end

/**
 图文详情
 */

@interface LxmGoodsDetailTopCell : UITableViewCell

@end

@interface LxmGoodsDetailTextCell : UITableViewCell

@property (nonatomic, strong) LxmGoodsDetailModel *model;//商品详情

@end

@interface LxmGoodsDetailImgCell : UITableViewCell

@property (nonatomic, strong) LxmGoodsDetailTuPianModel *tupianModel;//商品详情

@end
