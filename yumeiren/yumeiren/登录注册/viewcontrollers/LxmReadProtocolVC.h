//
//  LxmReadProtocolVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmReadProtocolVC : BaseViewController

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, copy) void(^yiduXiyiBlock)(void);

@end

NS_ASSUME_NONNULL_END
