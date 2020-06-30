//
//  LxmShopCenterSelectedView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/28.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmShopCenterSelectedView : UIControl

@property (nonatomic, assign) NSInteger currentIndex;//当前选中

@property (nonatomic, copy) NSArray<NSString *> *dataArr;

@property (nonatomic, copy) void (^didSelectedIndex)(NSInteger currentIndex);

- (void)showAtView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
