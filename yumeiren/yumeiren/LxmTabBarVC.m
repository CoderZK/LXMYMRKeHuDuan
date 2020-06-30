//
//  LxmTabBarVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmTabBarVC.h"
#import "LxmHomeVC.h"
#import "LxmShopVC.h"
#import "LxmShopCenterVC.h"
#import "LxmShopCarVC.h"
#import "LxmMineVC.h"

@interface LxmTabBarVC () <UITabBarControllerDelegate>

@end

@implementation LxmTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:206/255.0 alpha:1];
    UIColor *color_n = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.delegate = self;
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        tabBarAppearance.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
        tabBarAppearance.shadowColor = UIColor.whiteColor;
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : color};
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : color_n};
        self.tabBar.standardAppearance = tabBarAppearance;
    }
    
    LxmHomeVC *homeVC = [[LxmHomeVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"sy_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"sy_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [homeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    homeVC.tabBarItem.title = @"首页";
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    
    LxmShopVC *shopVC = [[LxmShopVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    shopVC.tabBarItem.image = [[UIImage imageNamed:@"sp_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"sp_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [shopVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [shopVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    shopVC.tabBarItem.title = @"商铺";
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:shopVC];
    
    LxmShopCenterVC *shopCenterVC = [[LxmShopCenterVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    shopCenterVC.tabBarItem.image = [[UIImage imageNamed:@"sjzx_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopCenterVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"sjzx_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [shopCenterVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [shopCenterVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    shopCenterVC.tabBarItem.title = @"商家中心";
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:shopCenterVC];
    
    LxmShopCarVC *shopCarVC = [[LxmShopCarVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    shopCarVC.tabBarItem.image = [[UIImage imageNamed:@"gwd_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopCarVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"gwd_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [shopCarVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [shopCarVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    shopCarVC.tabBarItem.title = @"购物袋";
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:shopCarVC];
    
    LxmMineVC *mineVC = [[LxmMineVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"wd_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wd_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    mineVC.tabBarItem.title = @"我的";
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    if ([LxmTool ShareTool].userModel.roleType.integerValue == -1) {
        self.viewControllers = @[nav1,nav2,nav4,nav5];
    } else {
        self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    }
    
}

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}


@end
