//
//  LxmYeJiKaoHeView.h
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmYeJiKaoHeView : UIView
- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;
- (void)show;
- (void)dismiss;
@property(nonatomic,assign)NSInteger type; // 0 月 1 季
@property(nonatomic,copy)void(^confirmBlock)(NSInteger year ,NSInteger month , NSString * titleStr);
@end

NS_ASSUME_NONNULL_END
