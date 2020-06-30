//
//  LxmSuCaiTabBarVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSuCaiTabBarVC.h"
#import "LxmFenLeiVC.h"

@interface LxmSuCaiTabBarVC ()<UITabBarControllerDelegate>

@end

@implementation LxmSuCaiTabBarVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.delegate = self;
    
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
    LxmFenLeiVC *fenleiVC = [[LxmFenLeiVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    fenleiVC.barIndex = 0;
    fenleiVC.tabBarItem.image = [[UIImage imageNamed:@"fl_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fenleiVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"fl_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [fenleiVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [fenleiVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    fenleiVC.tabBarItem.title = @"分类";
//    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:fenleiVC];
    
    LxmFenLeiVC *tuijianVC = [[LxmFenLeiVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    tuijianVC.barIndex = 1;
    tuijianVC.tabBarItem.image = [[UIImage imageNamed:@"tj_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tuijianVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tj_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tuijianVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [tuijianVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    tuijianVC.tabBarItem.title = @"推荐";
//    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:tuijianVC];
    
    LxmFenLeiVC *myPublishVC = [[LxmFenLeiVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    myPublishVC.barIndex = 2;
    myPublishVC.tabBarItem.image = [[UIImage imageNamed:@"wdfb_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myPublishVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wdfb_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [myPublishVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [myPublishVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color_n} forState:UIControlStateNormal];
    myPublishVC.tabBarItem.title = @"我发布的";
//    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:myPublishVC];
    self.viewControllers = @[fenleiVC,tuijianVC,myPublishVC];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
    leftItem.tintColor = CharacterDarkColor;
        //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)baseLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        tabBarController.navigationItem.title = @"分类";
    } else if (tabBarController.selectedIndex == 1) {
        tabBarController.navigationItem.title = @"推荐";
    } else {
        tabBarController.navigationItem.title = @"我的发布";
    }
}
@end
