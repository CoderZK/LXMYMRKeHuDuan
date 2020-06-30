//
//  LxmPeiSongAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmPeiSongAlertView : UIView

@property (nonatomic, assign) NSInteger index1;

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^selectTypeBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
