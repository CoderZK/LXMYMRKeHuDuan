//
//  LxmFullScreenViewController.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/3.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmFullScreenViewController : UIViewController

@property (nonatomic, strong) UIView *player;

@property (nonatomic, copy) dispatch_block_t dismissBlock;;

- (void)close;

@end

NS_ASSUME_NONNULL_END
