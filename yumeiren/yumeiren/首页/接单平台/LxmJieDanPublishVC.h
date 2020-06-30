//
//  LxmJieDanPublishVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LxmJieDanPublishVC : BaseTableViewController

@end


@interface LxmJieDanPublishTextFieldCell : UIControl

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end


@interface LxmJieDanPublishSelectedCell : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *subTitleLabel;
@property (nonatomic, strong) UIImageView *jiantouView;

@property (nonatomic, copy) void(^clickBlock)(void);

@end
