//
//  LxmShengJiProtocolAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/8.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmShengJiProtocolAlertView : UIView

@property (nonatomic, strong) UILabel *titleLabel;/* 标题 */

@property (nonatomic, strong) NSString *url;

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^bottomButtonClickBlock)(NSInteger index);

@end


@interface LxmShengJiProtocolBottomView : UIView

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) UIButton *sureButton;//确定

@end
