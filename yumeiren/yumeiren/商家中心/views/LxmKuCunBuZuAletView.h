//
//  LxmKuCunBuZuAletView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmKuCunBuZuAletView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^bottomClickBlock)(NSInteger index);

@end

@interface LxmKuCunBuZuBottomView : UIView

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) UIButton *sureButton;//确定

@end
