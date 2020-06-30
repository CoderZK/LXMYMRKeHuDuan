//
//  LxmSuCaiTabBarVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmSuCaiTabBarVC : UITabBarController

@property (nonatomic, copy) void(^readBlock)(void);

@end

NS_ASSUME_NONNULL_END
