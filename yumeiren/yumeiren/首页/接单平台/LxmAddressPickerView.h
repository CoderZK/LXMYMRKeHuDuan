//
//  LxmAddressPickerView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/29.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LxmAddressPickerViewDelegate <NSObject>

/** 取消按钮点击事件*/
- (void)cancelBtnClick;

/**
 *  完成按钮点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area;

@end


@interface LxmAddressPickerView : UIView

- (void)show;

- (void)hide;

/** 实现点击按钮代理*/
@property (nonatomic ,weak) id<LxmAddressPickerViewDelegate> delegate;

@end


