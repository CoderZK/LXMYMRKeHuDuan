//
//  LxmSearchVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmSearchVC : BaseViewController

@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, strong) LxmShengjiModel *shengjiModel;

@property (nonatomic, assign) bool isDeep;//是否是二级页面 是加返回键

@property (nonatomic, assign) BOOL isAddLocolGoods;//是否是添加到本地商品

@property (nonatomic, assign) BOOL isClass;//是否是培训课堂

@property (nonatomic, assign) NSInteger info_type;

@property(nonatomic,assign)BOOL isHaoCai; //是否是耗材

@end

@interface LxmSearchPageReusableView : UICollectionReusableView

@end


@interface LxmSearchPageReusableCell : UICollectionViewCell

@end

NS_ASSUME_NONNULL_END
