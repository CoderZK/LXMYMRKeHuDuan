//
//  LxmMineVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LxmMineVC : BaseTableViewController

@end

@interface LxmQianBaoButton : UIButton

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@interface LxmQianBaoTopView : UIView

@property (nonatomic, strong) LxmQianBaoButton *leftButton;

@property (nonatomic, strong) LxmQianBaoButton *centerButton;

@property (nonatomic, strong) LxmQianBaoButton *rightButton;

@end
