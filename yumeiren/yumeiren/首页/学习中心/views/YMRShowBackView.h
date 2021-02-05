//
//  YMRShowBackView.h
//  yumeiren
//
//  Created by zk on 2021/2/5.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRShowBackView : UIView
- (void)show;
- (void)diss;
@property(nonatomic,copy)void(^clickGoBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
