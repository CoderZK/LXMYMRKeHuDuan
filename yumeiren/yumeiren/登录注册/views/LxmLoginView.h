//
//  LxmLoginView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmLoginView : UIView

@end

@interface LxmTextAndPutinTFView : UIView

@property (nonatomic, strong) UILabel *leftLabel;//左侧标签

@property (nonatomic, strong) UITextField *rightTF;//右侧输入

@property (nonatomic, strong) UIView *lineView;

@end

@interface LxmAgreeButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UIButton *selectButton;

@end
