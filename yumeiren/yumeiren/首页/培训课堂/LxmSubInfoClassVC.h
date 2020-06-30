//
//  LxmSubInfoClassVC.h
//  yumeiren
//
//  Created by 李晓满 on 2020/2/21.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseViewController.h"

@interface LxmSubInfoClassVC : BaseViewController

@property (nonatomic, assign) NSInteger info_type;

@end


@interface LxmSubClassInfoCell : UICollectionViewCell

@property (nonatomic, strong) LxmClassGoodsModel *model;

@end

@interface lxmYuYinView : UIView

@end

@interface LxmSubYuYinInfoCell : UICollectionViewCell

@property (nonatomic, strong) LxmClassGoodsModel *model;

@end
