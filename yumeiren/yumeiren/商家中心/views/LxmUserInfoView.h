//
//  LxmUserInfoView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmUserInfoView : UIView

@end

/**
 头像
 */
@interface LxmUserHeaderImgView : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImgView;

@end

/**
 微信号 手机号 复制
 */
@interface LxmUserCodeCell : UIControl

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@end
