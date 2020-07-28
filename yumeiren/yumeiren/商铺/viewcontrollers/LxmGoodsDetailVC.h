//
//  LxmGoodsDetailVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmGoodsDetailVC : BaseTableViewController

@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;

@property (nonatomic, strong) NSString *goodsID;//商品id

@property (nonatomic, assign) BOOL isAddLocolGoods;//是否是添加到本地商品

@property(nonatomic,assign)BOOL isHaoCai; //是否是耗材

@end


/**
 商品详情底部按钮
 */

@interface LxmGoodsDetailButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *carNumLabel;//购物车数量

@property (nonatomic, strong) NSString *num;

@end

@interface LxmGoodsDetailBottomView : UIView

@property (nonatomic, strong) LxmGoodsDetailButton *carButton;/* 购物车 */

@property (nonatomic, copy) void(^bottomActionBlock)(NSInteger index);

@end
