//
//  LxmYearMonthPickerView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/13.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmYearMonthPickerView : UIView

@property (nonatomic,copy) void(^cancelBlock)(void);

@property (nonatomic,copy) void(^sureBlock)(NSString*,NSString*);

- (void)show;

- (void)dismiss;

@end


