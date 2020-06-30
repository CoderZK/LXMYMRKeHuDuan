//
//  LxmShopCarView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmShopCarView : UIView

@end

//购物车加减view
@interface LxmNumView : UIView

@property (nonatomic, strong) UIButton *incButton;//+

@property (nonatomic, strong) UITextField *numTF;//输入

@property (nonatomic, strong) UIButton *decButton;//-

@end

//购物车cell
@interface LxmShopCarCell : UITableViewCell

@property (nonatomic, strong) LxmShopCarModel *carModel;//购物车Model

@property (nonatomic, copy) void(^selectClick)(LxmShopCarModel *carModel);

@property (nonatomic, copy) void(^modifyCarSuccess)(LxmShopCarModel *model);

@end

//购物车底部view
@interface LxmShopCarBottomView : UIView

@property (nonatomic, copy) void(^jiesuanBlock)(void);

@property (nonatomic, copy) void(^allSelectBlock)(BOOL isSelect);

@property (nonatomic, strong) UIButton *allSelectButton;//全选

@property (nonatomic, strong) UIImageView *allImgView;

@property (nonatomic, strong) UILabel *yuanPrice;//原价

@property (nonatomic, strong) UILabel *vipPrice;//vip价

@property (nonatomic, strong) UIButton *jiesuanButton;//结算

@property (nonatomic, assign) bool isYIjianbuhuo;


@end
