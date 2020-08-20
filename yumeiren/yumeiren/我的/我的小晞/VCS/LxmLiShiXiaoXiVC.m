//
//  LxmLiShiXiaoXiVC.m
//  yumeiren
//
//  Created by zk on 2020/7/30.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmLiShiXiaoXiVC.h"

@interface LxmLiShiXiaoXiVC ()
@property(nonatomic,strong)UILabel *centerLB;
@property(nonatomic,assign)int month;

@property(nonatomic,strong)UIView *headViewOne;
@property(nonatomic,strong)UILabel *numberLB,*LB1,*LB2,*LB3,*LB4,*JifenLB;
@property(nonatomic,strong)UIButton  *tixianBt,*mineJiFenBt,*shengYujiFenBt,*liShiXiaoXiBt;
@property(nonatomic,strong)UIImageView *imgV1,*imgV2;
@property(nonatomic,strong)UIView  *redV;
@property(nonatomic,strong)UIView *btView;


@end

@implementation LxmLiShiXiaoXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.month = 0;
    self.navigationItem.title = @"历史小晞";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * leftBt  = [[UIButton alloc] init];
    leftBt.tag = 100;
    [leftBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBt];
    [leftBt setImage:[UIImage imageNamed:@"kkzuo"] forState:UIControlStateNormal];
    
    
    UIButton * rightBt  = [[UIButton alloc] init];
    rightBt.tag = 101;
    [rightBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBt];
    [rightBt setImage:[UIImage imageNamed:@"kkyou"] forState:UIControlStateNormal];
    
    
    self.centerLB = [[UILabel alloc] init];
    self.centerLB.font = [UIFont systemFontOfSize:13];
    self.centerLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.centerLB];
    
    [self.centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@150);
    }];
    
    [leftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerLB.mas_left).offset(-10);
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.centerLB);
    }];
    
    [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLB.mas_right).offset(10);
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.centerLB);
    }];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM"];
    
    
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    self.centerLB.text = currentDateString;
    
    
    [self addHeadViewOne];
    

    [self getData];

    
}

- (void)getData  {
    
    [SVProgressHUD show];
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = [LxmTool ShareTool].session_token;
    dict[@"month"] = self.centerLB.text;
    [LxmNetworking networkingPOST:month_total_group_score
                       parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]]  isEqualToString:@"<null>"]) {
                self.LB1.text = @"0";
                self.LB2.text = @"0";
                return;
            }
            
            if (responseObject[@"result"][@"data"] != nil && ![[NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]]  isEqualToString:@"<null>"]&& [[responseObject[@"result"][@"data"] allKeys] containsObject:@"groupScore"]) {
                self.LB1.text = [[NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"][@"groupScore"]] getPriceStr];;
            }else {
                self.LB1.text = @"0";
            }
            
            
            if (responseObject[@"result"][@"data"] != nil && ![[NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]]  isEqualToString:@"<null>"]&& [[responseObject[@"result"][@"data"] allKeys] containsObject:@"myScore"]) {
                    self.LB2.text = [[NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"][@"myScore"]] getPriceStr];
                }else {
                    self.LB2.text = @"0";
                }
            
           
            
            
        } else {
          
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
         [SVProgressHUD dismiss];
        
    }];
    
    
    
    
    
}


- (void)clickAction:(UIButton *)button {
    if (button.tag == 100) {
        self.month--;
    }else {
        self.month++;
    }
    self.centerLB.text = [self beforeDate:self.month];
    [self getData];
    
}

- (NSString *)beforeDate:(NSInteger)n {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *nowDateStr = [formatter stringFromDate:currentDate];
    NSLog(@"当前日期：%@",nowDateStr);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:n];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *beforeDateStr = [formatter stringFromDate:newdate];
    
    return beforeDateStr;
    
}




- (void)addHeadViewOne {
    
    self.headViewOne = [[UIView alloc] init];
    self.headViewOne.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headViewOne];
    
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"kkjifenback"];
    imageV.userInteractionEnabled = YES;
    [self.headViewOne addSubview:imageV];
    
    
    
    UILabel * jiFenLB  = [[UILabel alloc] init];
    jiFenLB.font = [UIFont systemFontOfSize:20 weight:0.2];
    //        jiFenLB.text = [[NSString stringWithFormat:@"%0.2f",self.jifenModel.my_score.doubleValue]  getPriceStr];
    jiFenLB.text = @"55525";
    jiFenLB.textAlignment = NSTextAlignmentCenter;
    jiFenLB.textColor = [UIColor whiteColor];
    [imageV  addSubview:jiFenLB];
    self.LB1 = jiFenLB;
    
    
    
    UIButton  * mingXiBt = [[UIButton alloc] init];
    [mingXiBt setTitle:@"团队小晞" forState:UIControlStateNormal];
    [mingXiBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mingXiBt.titleLabel.font = [UIFont systemFontOfSize:13];
    mingXiBt.userInteractionEnabled = NO;
    [imageV addSubview:mingXiBt];
    
    
    
    UILabel * jiFenLBTwo  = [[UILabel alloc] init];
    jiFenLBTwo.font = [UIFont systemFontOfSize:20 weight:0.2];
    //        jiFenLBTwo.text = [[NSString stringWithFormat:@"%@", @(self.jifenModel.group_score.doubleValue).stringValue] getPriceStr] ;
    jiFenLBTwo.text = @"82552";
    jiFenLBTwo.textAlignment = NSTextAlignmentCenter;
    jiFenLBTwo.textColor = [UIColor whiteColor];
    [imageV  addSubview:jiFenLBTwo];
    self.LB2 = jiFenLBTwo;
    
    
    UIButton  * mingXiBtTwo = [[UIButton alloc] init];
    [mingXiBtTwo setTitle:@"我的小晞" forState:UIControlStateNormal];
    [mingXiBtTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mingXiBtTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    [imageV addSubview:mingXiBtTwo];
    mingXiBtTwo.userInteractionEnabled = NO;
    
    
    
    
    
    UIView * lineVOne = [[UIView alloc] init];
    lineVOne.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:lineVOne];
    
    
    [self.headViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@180);
        make.top.equalTo(self.view).offset(50);
        
    }];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@180);
        make.width.equalTo(@(ScreenW - 30));
        make.centerX.equalTo(self.headViewOne);
        make.top.equalTo(self.headViewOne).offset(0);
    }];
    
    
    [lineVOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageV).offset(65);
        make.bottom.equalTo(imageV).offset(-65);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(imageV);
    }];
    
    [jiFenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(15);
        make.width.equalTo(@((ScreenW - 51)/ 2));
        make.top.equalTo(imageV).offset(65);
        make.height.equalTo(@25);
    }];
    [mingXiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiFenLB);
        make.width.equalTo(jiFenLB.mas_width);
        make.height.equalTo(@20);
        make.top.equalTo(jiFenLB.mas_bottom).offset(5);
    }];
    
    
    [jiFenLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineVOne);
        make.top.equalTo(jiFenLB);
        make.width.equalTo(@((ScreenW - 51)/ 2));
        make.height.equalTo(@25);
    }];
    [mingXiBtTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiFenLBTwo.mas_left);
        make.width.equalTo(jiFenLBTwo.mas_width);
        make.height.equalTo(@20);
        make.top.equalTo(mingXiBt);
    }];
    
    
    
    
}



@end
