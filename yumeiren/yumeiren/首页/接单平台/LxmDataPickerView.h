//
//  LxmDataPickerView.h
//  buqiuren
//
//  Created by 李晓满 on 16/9/26.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmDataPickerViewDelegate;
@interface LxmDataPickerView : UIView

@property(nonatomic,assign)id<LxmDataPickerViewDelegate>delegate;



+ (LxmDataPickerView *)pickerView;
- (void)show;
- (void)dismiss;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@protocol LxmDataPickerViewDelegate <NSObject>

-(void)LxmDataPickerView:(LxmDataPickerView *)view currentData:(NSDate *)date;

@end
