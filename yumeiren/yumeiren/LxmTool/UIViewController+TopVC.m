//
//  UIViewController+TopVC.m
//  54school
//
//  Created by 宋乃银 on 2018/9/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "UIViewController+TopVC.h"

@implementation UIViewController (TopVC)

+ (UIViewController *)topViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [UIViewController topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController *)rootViewController;
        return [UIViewController topViewControllerWithRootViewController:tabbarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.childViewControllers.lastObject];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [UIViewController topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)popSelfVC {
    NSMutableArray *arr = [NSMutableArray array];
    for (UIViewController *tmpvc in self.navigationController.viewControllers) {
        if (tmpvc != self) {
            [arr addObject:tmpvc];
        }
    }
    [self.navigationController setViewControllers:arr animated:YES];
}


@end
