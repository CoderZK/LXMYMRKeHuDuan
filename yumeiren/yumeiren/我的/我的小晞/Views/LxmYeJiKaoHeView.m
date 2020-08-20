//
//  LxmYeJiKaoHeView.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmYeJiKaoHeView.h"

#define years 10

@interface LxmYeJiKaoHeView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,assign)NSInteger currentYear,selectYear,currentMonth,selectMonth;

@end

@implementation LxmYeJiKaoHeView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type{
    self =[super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.1];
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 220)];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.whiteV  = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 220)];
        self.whiteV.backgroundColor = [UIColor whiteColor];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.whiteV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = self.whiteV.bounds;
         maskLayer.path = maskPath.CGPath;
        self.whiteV.layer.mask = maskLayer;
        
        UIButton * cancelBt  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBt.tag = 100;
        cancelBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.whiteV addSubview:cancelBt];
        [cancelBt addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

        UIButton * confirmBt  = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 0, 80, 40)];
        [confirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBt setTitleColor:MainColor forState:UIControlStateNormal];
        confirmBt.tag = 100;
        confirmBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.whiteV addSubview:confirmBt];
        [confirmBt addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * backV =[[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 0.4)];
        backV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.whiteV addSubview:backV];
        
        
            // 获取当前日期
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//        NSDateFormatter * ff = [[NSDateFormatter alloc] init];
//        [ff setDateFormat:@"yyyy-MM-dd"];
//        NSDate * dt = [ff dateFromString:@"2020-03-20"];
        
         NSDate* dt = [NSDate date];
        
            // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        
         unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth ;
          // 获取不同时间字段的信息
         NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        self.currentMonth = comp.month;
        self.currentYear = comp.year;

        
        self.pickView  =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 180)];
        [self.whiteV addSubview:self.pickView];
        self.pickView.delegate =self;
        self.pickView.dataSource = self;
        
        
        self.selectYear = years - 1;
        if (type == 0) {
//            if (self.currentMonth == 1) {
//               self.selectYear = years - 2;
//               self.selectMonth = 11 ;
//            }else {
//                self.selectMonth = self.currentMonth - 2;
//            }
            self.selectMonth = self.currentMonth - 1;
        }else {
            self.selectMonth = self.currentMonth / 3 + (self.currentMonth%3>0?1:0) - 1;
//            if ((self.currentMonth -1) / 3 == 0) {
//                self.selectYear = years - 2;
//                self.selectMonth = 3;
//            }else {
//                self.selectMonth = (self.currentMonth -1) / 3 - 1;
//            }
        }
        [self.pickView selectRow:self.selectYear inComponent:0 animated:YES];
        [self.pickView selectRow:self.selectMonth inComponent:1 animated:YES];
        [self pickerView:self.pickView didSelectRow:self.selectYear inComponent:0];
        [self pickerView:self.pickView didSelectRow:self.selectMonth inComponent:1];

        
        
        
        
        
        
 
        [self addSubview:self.whiteV];
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
//        if ((self.type ==0 && self.currentMonth == 1) || (self.type == 1 && (self.currentMonth -1) / 3 == 0)) {
//            return years - 1;
//        }
        return years;
    }else {
        if (self.type == 0) {
            //按月
//            if (self.selectYear == years - 1) {
//                return self.currentMonth - 1;
//            }else {
//                return 12;
//            }
            return 12;
        }else {
            //按季度
            return 4;
//            if (self.selectYear == years - 1) {
//                return (self.currentMonth -1) / 3;
//            }else {
//                return 4;
//            }
            
        }
    }
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.type == 0) {
        return ScreenW / 2;
    }else {
        if (component == 0) {
            return ScreenW / 3;
        }else {
            return ScreenW / 3 * 2;
        }
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld",self.currentYear - years + 1+row];
    }else {
        if (self.type == 0) {
            return [NSString stringWithFormat:@"%ld",row+1];
        }else {
            return @[@"第一季度(1-3月)",@"第二季度(4-6月)",@"第三季度(7-9月)",@"第四季度(10-12月)"][row];
        }
    }
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectYear = row;
        [self.pickView reloadComponent:1];
//        if (row == years - 1) {
//            if (self.type == 0) {
//                if (self.selectMonth > self.currentMonth - 1) {
//                    self.selectMonth = self.currentMonth - 1;
//                }
//            }else {
//                if (self.selectMonth > (self.currentMonth -1) / 3 - 1) {
//                    self.selectMonth = (self.currentMonth -1) / 3 - 1;
//                }
//            }
//        }
    }else {
        self.selectMonth = row;
    }
    NSLog(@"%@",@"123456");

}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
           
           self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
           self.whiteV.mj_y  = ScreenH - 220;
           
       } completion:^(BOOL finished) {
          
       }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.whiteV.mj_y  = ScreenH;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

//点击确定
- (void)confirmAction {
    [self dismiss];
    NSInteger year = self.currentYear - years + self.selectYear + 1;
    NSInteger month = self.selectMonth ;
    NSString * str = @"";
    if (self.type == 0) {
        str = [NSString stringWithFormat:@"%ld年%ld月",year,month + 1];
    }else {
        str = [NSString stringWithFormat:@"%ld年%@",year,@[@"第一季度(1-3月)",@"第二季度(4-6月)",@"第三季度(7-9月)",@"第四季度(10-12月)"][self.selectMonth]];
    }
    if (self.confirmBlock != nil) {
        if (self.type == 1) {
           self.confirmBlock(year, month * 3 + 1, str);
        }else {
           self.confirmBlock(year, month, str);
        }
        
        
    }
    
    
}

@end

