//
//  LxmHomeView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmHomeView : UIView

@end

/**
 表头视图 bannerView
 */
@interface LxmHomeHeaderView : UIView

@end

@interface LxmHomeButtonItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView *itemImgView;

@property (nonatomic, strong) UILabel *itemLabel;

@property (nonatomic, strong) UILabel *redLabel;

@property (nonatomic, strong) NSString *redNum;//未读消息数量

@end

/**
 item cell
 */
@interface LxmHomeButtonCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentRole;

@property (nonatomic, copy) void(^didSelectItemBlock)(NSInteger index);

@end

@interface LxmHomeGoodsItem : UICollectionViewCell

@property (nonatomic, strong) LxmHomeGoodsModel *goodsModel;

@property (nonatomic, copy) void(^addCardClickBlock)(LxmHomeGoodsModel *goodsModel);
@property (nonatomic, strong) NSString *roleType;

@end

/**
 区头
 */
@interface LxmHomeSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *imgView;

@end

/**
 首页商品
 */
@interface LxmHomeGoodsCell : UITableViewCell

@property (nonatomic, strong) LxmHomeGoodsTypesModel *model;

@end
