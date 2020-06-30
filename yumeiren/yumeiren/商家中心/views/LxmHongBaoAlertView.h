//
//  LxmHongBaoAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmHongBaoAlertView : UIView

@property (nonatomic, copy) void(^chaiHongBaoBlock)(LxmHongBaoAlertView *view);

- (void)setConstrains:(BOOL)ischai money:(NSString *)money;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
