//
//  YMRAddMusicTVC.h
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMRAddMusicTVC : BaseTableViewController
@property(nonatomic,copy)void(^sendMusicBlock)(NSString * musicStr);
@end

NS_ASSUME_NONNULL_END
