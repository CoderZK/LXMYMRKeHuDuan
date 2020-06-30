//
//  LxmSearchView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 店铺页面导航栏搜索栏
 */
@interface LxmSearchView : UIView

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UITextField *searchTF;//搜索栏

@end

/**
 搜索页面搜索栏
 */
@interface LxmSearchPageView : UIView

@property (nonatomic, strong) UIView *bgView;//背景按钮

@property (nonatomic, strong) UITextField *searchTF;//搜索栏

@end


@interface LxmTitleView : UIView

@property (nonatomic, strong) LxmSearchView *searchView;//搜索

- (CGSize)intrinsicContentSize;

@property (nonatomic, copy) void(^searchBlock)(void);

@end
