//
//  LxmGoodsDetailShareAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmShareButtonItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView *itemImgView;

@property (nonatomic, strong) UILabel *itemLabel;

@end

@interface LxmGoodsDetailShareAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^didSelectShareItemBlock)(NSInteger index);

@end


NS_ASSUME_NONNULL_END
