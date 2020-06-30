//
//  LxmJieDanPublishAlertView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/1.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmJieDanPublishCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface LxmJieDanPublishAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^selectTypeBlock)(LxmJieDanPublishModel *model);

@end

NS_ASSUME_NONNULL_END
