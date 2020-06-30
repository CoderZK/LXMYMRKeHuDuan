//
//  LxmRegistXieYiAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/28.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmRegistXieYiAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^sureBlock)(void);

@end

