//
//  LxmYearMonthPickerView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/13.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmYearMonthPickerView.h"
static const int loop = 20;

@interface LxmYearMonthPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong)  UIPickerView *pickerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) NSArray *monthsArr;   //月份的数组

@property (nonatomic,strong) NSArray *yearsArr;    //年份的数组

@property (nonatomic,strong) NSDateFormatter *formatter;

@property (nonatomic,strong) NSString *currentYear;

@property (nonatomic,strong) NSString *currentMonth;

@property (nonatomic,assign) BOOL isCurrentYear;

@property (nonatomic,strong) NSString *selectYear;

@property (nonatomic,strong) NSString *selectMonth;

@end

@implementation LxmYearMonthPickerView

- (NSDateFormatter*)formatter{
    if (_formatter==nil) {
        _formatter = [[NSDateFormatter alloc]init];
    }
    return _formatter;
}

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
        
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        //初始化
        self.monthsArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        
        [self.formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
        NSDate *currentDate = [NSDate date];
        
        [self.formatter setDateFormat:@"MM"];
        self.currentMonth = [self.formatter stringFromDate:currentDate];
        self.selectMonth = self.monthsArr[(self.currentMonth.integerValue-1)];
        
        [self.formatter setDateFormat:@"yyyy"];
        self.currentYear = [self.formatter stringFromDate:currentDate];
        self.selectYear = self.currentYear;
        
        NSMutableArray <NSString*>*yearsArr = [NSMutableArray array];
        [yearsArr addObject:self.currentYear];
        
        int nowYear = [self.currentYear intValue];
        for (int i=0; i<loop; i++) {
            nowYear = nowYear - 1;
            NSString *nowYearStr = [NSString stringWithFormat:@"%d",nowYear];
            [yearsArr insertObject:nowYearStr atIndex:0];
        }
        self.yearsArr = yearsArr;
        self.isCurrentYear = YES;
        [self.pickerView selectRow:(self.yearsArr.count-1) inComponent:0 animated:YES];
        [self.pickerView selectRow:(self.currentMonth.intValue-1) inComponent:1 animated:YES];
        [_contentView addSubview:_pickerView];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.yearsArr.count;
    }else if (component==1){
        if (self.isCurrentYear) {
            return self.currentMonth.integerValue;
        }else{
            return self.monthsArr.count;
        }
    }else{
        return 0;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        NSString *year = self.yearsArr[row];
        year = [year stringByAppendingString:@"年"];
        return year;
    }else if (component==1){
        NSString *month = self.monthsArr[row];
        month = [month stringByAppendingString:@"月"];
        return month;
    }else{
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0 && row==self.yearsArr.count-1) {
        self.isCurrentYear = YES;
        [self.pickerView reloadComponent:1];
        
        self.selectYear = self.yearsArr[row];
    }else if (component==0){
        self.isCurrentYear = NO;
        [self.pickerView reloadComponent:1];
        
        self.selectYear = self.yearsArr[row];
    }else if (component==1){
        self.selectMonth = self.monthsArr[row];
    }
}



-(void)bgBtnClick:(UIButton *)btn {
    if (btn.tag == 110) {
        [self dismiss];
    } else {
        if (btn.tag == 111) {
            [self dismiss];
        } else {
            if (self.sureBlock) {
                self.sureBlock(self.selectYear, self.selectMonth);
            }
            [self dismiss];
        }
    }
    
    
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
