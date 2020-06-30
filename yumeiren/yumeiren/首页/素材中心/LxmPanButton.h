//
//  LxmPanButton.h
//  peiqiwu
//
//  Created by 李晓满 on 2019/5/30.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmPanButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, copy) void(^panBlock)(void);

/**
 default 15 15 15 15
 */
@property (nonatomic, assign) UIEdgeInsets marginInsets;

@end

NS_ASSUME_NONNULL_END
