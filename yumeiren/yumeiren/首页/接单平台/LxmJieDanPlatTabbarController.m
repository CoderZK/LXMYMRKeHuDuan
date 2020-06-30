//
//  LxmJieDanPlatTabbarController.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanPlatTabbarController.h"
#import "LxmJieDanListViewController.h"
#import "LxmJieDanMyViewController.h"

#import "LxmSelectAreaVC.h"

@interface LxmJieDanPlatTabbarController () <UITabBarControllerDelegate>

//@property (nonatomic, strong) UIButton *rightButton;//导航栏右侧按钮

@property (nonatomic, strong) LxmJieDanPlatAddressButton *rightButton;//导航栏右侧按钮

@property (nonatomic, strong) NSString *currentCity;

@property (nonatomic, strong) LxmJieDanListViewController *vc;

@end

@implementation LxmJieDanPlatTabbarController

- (LxmJieDanPlatAddressButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[LxmJieDanPlatAddressButton alloc] initWithFrame:CGRectMake(0, 0, 120,40)];
        [_rightButton addTarget:self action:@selector(selectArea) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单平台";
    self.currentCity = LxmTool.ShareTool.userModel.city;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.delegate = self;
    self.view.backgroundColor = UIColor.whiteColor;
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIColor *color = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:206/255.0 alpha:1];
    UIColor *color_n = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        tabBarAppearance.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
        tabBarAppearance.shadowColor = UIColor.whiteColor;
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : color};
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : color_n};
        self.tabBar.standardAppearance = tabBarAppearance;
    }
    LxmJieDanListViewController *jiedanlistvc = [[LxmJieDanListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    self.vc = jiedanlistvc;
    jiedanlistvc.city = self.currentCity;
    jiedanlistvc.tabBarItem.image = [[UIImage imageNamed:@"liebiao2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    jiedanlistvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"liebiao"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [jiedanlistvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [jiedanlistvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    jiedanlistvc.tabBarItem.title = @"列表";
    
    LxmJieDanMyViewController *jiedanMyvc = [[LxmJieDanMyViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    jiedanMyvc.tabBarItem.image = [[UIImage imageNamed:@"wd_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    jiedanMyvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"wd_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [jiedanMyvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [jiedanMyvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    jiedanMyvc.tabBarItem.title = @"我的";
    
    self.viewControllers = @[jiedanlistvc,jiedanMyvc];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
    leftItem.tintColor = CharacterDarkColor;
    //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakObj(self);
    [LxmEventBus registerEvent:@"danCout" block:^(id data) {
        NSString *data1 = [NSString stringWithFormat:@"%@",data];
        if (data1.integerValue == 0) {
            selfWeak.rightButton.cityLabel.text = [NSString stringWithFormat:@"%@",selfWeak.currentCity];
        } else {
            selfWeak.rightButton.cityLabel.text = [NSString stringWithFormat:@"%@(%@)",selfWeak.currentCity,data];
        }
    }];
    
    [LxmEventBus registerEvent:@"danzifabusuccess" block:^(id data) {
        selfWeak.selectedIndex = 1;
    }];
}

- (void)baseLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        tabBarController.navigationItem.title = @"接单平台";
        self.rightButton.hidden = NO;
    } else if (tabBarController.selectedIndex == 1) {
        tabBarController.navigationItem.title = @"我的";
        self.rightButton.hidden = YES;
    }
}

- (void)selectArea {
    LxmSelectAreaVC *vc = [[LxmSelectAreaVC alloc] init];
    vc.city = self.currentCity;
    WeakObj(self);
    vc.didSelectCity = ^(NSString *city) {
        selfWeak.currentCity = city;
        selfWeak.vc.city = city;
        selfWeak.vc.allPageNum = 1;
        selfWeak.vc.page = 1;
        [selfWeak.vc loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end


/**
 代理区域选择 button
 */

@interface LxmJieDanPlatAddressButton ()

- (CGSize)intrinsicContentSize;

@property (nonatomic, strong) UIImageView *iconImgView;

@end

@implementation LxmJieDanPlatAddressButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cityLabel];
        [self addSubview:self.iconImgView];
        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.iconImgView.mas_leading);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(120, 40);
}


- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [UILabel new];
        _cityLabel.textColor = CharacterDarkColor;
        _cityLabel.font = [UIFont systemFontOfSize:15];
        _cityLabel.text = @"常州(10)";
    }
    return _cityLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"arrow"];
    }
    return _iconImgView;
}

@end

