//
//  LxmJiaJiaAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/2.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LxmJiaJiaAlertView_type) {
    LxmJiaJiaAlertView_type_jiajia,
    LxmJiaJiaAlertView_type_dafen,
    LxmJiaJiaAlertView_type_zye//红包转余额
};

@interface LxmJiaJiaAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(LxmJiaJiaAlertView_type)type;

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^jiajiaBlock)(NSString *price);

@end


