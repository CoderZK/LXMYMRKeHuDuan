//
//  YMRTiShiShowView.h
//  yumeiren
//
//  Created by zk on 2020/11/23.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRTiShiShowView : UIView
- (void)show;
- (void)diss;
@property(nonatomic,strong)NSString *desStr;
@property(nonatomic,copy)void(^clickShengJiBlock)(void);
@end

NS_ASSUME_NONNULL_END
