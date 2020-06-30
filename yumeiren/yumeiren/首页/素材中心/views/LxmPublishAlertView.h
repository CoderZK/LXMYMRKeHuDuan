//
//  LxmPublishAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmPublishAlertButton : UIButton

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *textLabel;//文字

@property (nonatomic, strong) UIImageView *imgView;//图片

@end

@interface LxmPublishAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^publishTypeBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
