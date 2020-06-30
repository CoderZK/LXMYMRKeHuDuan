//
//  LxmDataPickerView.m
//  buqiuren
//
//  Created by 李晓满 on 16/9/26.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "LxmDataPickerView.h"

@interface LxmDataPickerView ()

@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong)  UIDatePicker *pickerView;

@end

@implementation LxmDataPickerView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton * bgBtn =[[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bgBtn.tag = 110;
        [self addSubview:bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 200 - TableViewBottomSpace, frame.size.width, 200 + TableViewBottomSpace)];
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIView * accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 39.5)];
        accView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:accView];
        
        UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 111;
        [leftBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [accView addSubview:leftBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, frame.size.width - 120, 40)];
        self.titleLabel.textColor = CharacterDarkColor;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [accView addSubview:self.titleLabel];
        
        UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 60, 0, 60, 39.5)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag = 112;
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [accView addSubview:rightBtn];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenW, 0.5)];
        lineView.backgroundColor = BGGrayColor;
        [accView addSubview:lineView];
        
        
        _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        _pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        [_contentView addSubview:_pickerView];
    }
    return self;
}

-(void)bgBtnClick:(UIButton *)btn
{
    if (btn.tag == 110) {
        [self dismiss];
    } else {
        if (btn.tag == 111) {
            [self dismiss];
        } else {
            if ([self.delegate respondsToSelector:@selector(LxmDataPickerView:currentData:)]) {
                [self.delegate LxmDataPickerView:self currentData:_pickerView.date];
            }
        }
    }
    
    
}

+(LxmDataPickerView *)pickerView {
    // 选择框
    LxmDataPickerView *pickerView = [[LxmDataPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 显示选中框
    return pickerView;
}


- (void)show {
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGRect rect = _contentView.frame;
    rect.origin.y = self.bounds.size.height;
    _contentView.frame = rect;
    
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.frame.size.height;
        selfWeak.contentView.frame = rect;
        
    } completion:nil];
}
-(void)dismiss {
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = self.bounds.size.height;
        selfWeak.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
