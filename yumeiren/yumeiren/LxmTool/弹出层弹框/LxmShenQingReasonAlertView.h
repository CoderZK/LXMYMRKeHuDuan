//
//  LxmShenQingReasonAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmShenQingReasonAlertView : UIView

-(void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^shenqingReasonBlock)(NSString *reason);

@end

