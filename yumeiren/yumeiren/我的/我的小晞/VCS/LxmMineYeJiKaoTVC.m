//
//  LxmMineYeJiKaoTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineYeJiKaoTVC.h"
#import "LxmMineYeJiKaoCell.h"
#import "LxmYeJiKaoHeView.h"
#import "LxmJiFenModel.h"
@interface LxmMineYeJiKaoTVC ()
@property(nonatomic,strong)UIView *yjView;
@property(nonatomic,strong)UIButton *leftBt,*rightBt;
@property(nonatomic,assign)NSInteger type,year,month,jiMonth;
@property(nonatomic,strong)UILabel *titelLB ;
@property(nonatomic,strong)NSString *yueStr,*jiStr;
@property(nonatomic,strong)LxmJiFenModel *dataModel;
@end

@implementation LxmMineYeJiKaoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"业绩考核";
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmMineYeJiKaoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 40;
    self.type = 0;
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
            self.month = comp.month;
            self.jiMonth = comp.month;
            self.year = comp.year;
      NSInteger fromMonth = (self.jiMonth / 3  + (self.jiMonth % 3 > 0 ? 1 : 0) - 1) * 3 + 1;
    NSInteger ji = self.jiMonth / 3 + (self.jiMonth % 3 > 0 ? 1:0) - 1;
     self.jiStr = [NSString stringWithFormat:@"%ld%@",self.year,@[@"第一季度(1-3月)",@"第二季度(4-6月)",@"第三季度(7-9月)",@"第四季度(10-12月)"][ji]];
    [self getData];
    [self addHeadV];
    
}

- (void)getData {
    
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"infoType"]= @(self.type+1);
    dict[@"year"] = @(self.year);
    dict[@"token"] = SESSION_TOKEN;
    if (self.type == 1) {
        //季
        
        NSInteger fromMonth = (self.jiMonth / 3  + (self.jiMonth % 3 > 0 ? 1 : 0) - 1) * 3 + 1;
        
        dict[@"fromMonth"] = @(fromMonth);
        dict[@"endMonth"] = @(fromMonth + 2);
    }else {
        //
        dict[@"fromMonth"] = @(self.month);
    }
    [LxmNetworking networkingPOST:check_detail parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
              [SVProgressHUD dismiss];
              if ([responseObject[@"key"] integerValue] == 1000) {
                  self.dataModel = [LxmJiFenModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
                  [self.tableView reloadData];
              }  else {
                  [UIAlertController showAlertWithmessage:responseObject[@"message"]];
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              [SVProgressHUD dismiss];
          }];
    
    
}

- (void)addHeadV {
    
    UIView * headV  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    headV.backgroundColor = [UIColor whiteColor];
    UILabel * LB1  =[[UILabel alloc] init];
    LB1.text = @"当前为";
    LB1.font = [UIFont systemFontOfSize:14];
    [headV addSubview:LB1];
    
    UILabel * LB2  =[[UILabel alloc] init];
    LB2.font = [UIFont systemFontOfSize:14];
    [headV addSubview:LB2];
    NSDateFormatter * forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy年MM月"];
    LB2.text = [forMatter stringFromDate:[NSDate date]];
    self.yueStr =  [forMatter stringFromDate:[NSDate date]];

    
    self.titelLB = LB2;
    LB2.textColor = MainColor;
    
    UIImageView * imageV  =[[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"kkxia"];
    [headV addSubview:imageV];
    
    self.yjView = [[UIView alloc] init];
    self.yjView.layer.cornerRadius = 10;
    self.yjView.clipsToBounds = YES;
    [headV addSubview:self.yjView];
    
    self.leftBt = [[UIButton alloc] init];
    self.leftBt.tag = 100;
    [self.leftBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.leftBt setTitle:@"月" forState:UIControlStateNormal];
    [self.yjView addSubview:self.leftBt];
    
    self.rightBt = [[UIButton alloc] init];
    self.rightBt.tag = 101;
    [self.rightBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rightBt setTitle:@"季" forState:UIControlStateNormal];
    [self.yjView addSubview:self.rightBt];
    
    UILabel * yueLB  =[[UILabel alloc] init];
    yueLB.backgroundColor = MainColor;
    yueLB.textColor = [UIColor whiteColor];
    yueLB.font = [UIFont systemFontOfSize:12];
    yueLB.textAlignment = NSTextAlignmentCenter;
    yueLB.layer.cornerRadius = 10;
    yueLB.clipsToBounds = YES;
    yueLB.text = @"月";
    [headV addSubview:yueLB];
    
    
    self.yjView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"yjleft"]];
    [self.leftBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
    
    
    UIButton * bt = [[UIButton alloc] init];
    bt.tag = 102;
    [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:bt];
    
    [LB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headV).offset(15);
        make.centerY.equalTo(headV);
        make.height.equalTo(@20);
    }];
    
    [LB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LB1.mas_right);
        make.centerY.equalTo(headV);
        make.height.equalTo(@20);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LB2.mas_right).offset(5);
        make.centerY.equalTo(headV);
        make.height.width.equalTo(@12);
    }];
    
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headV);
        make.height.equalTo(@40);
        make.left.equalTo(LB1.mas_left);
        make.right.equalTo(imageV.mas_right);
    }];
    
    [self.yjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headV).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.centerY.equalTo(headV);
    }];
    
    [yueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headV).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.centerY.equalTo(headV);
    }];
    
    
    [self.leftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.yjView);
        make.width.equalTo(@25);
    }];
    [self.rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.yjView);
        make.width.equalTo(@25);
    }];
    
    if (self.isJingLi) {
        self.yjView.hidden = YES;
        yueLB.hidden = NO;
    }else {
        self.yjView.hidden = NO;
        yueLB.hidden = YES;
    }
    
    self.tableView.tableHeaderView = headV;
}

- (void)clickAction:(UIButton *)sender {
    if (sender.tag == 100) {
        self.type = sender.tag - 100;
        self.yjView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"yjleft"]];
        [self.leftBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
       
        [self getData];
        self.titelLB.text = self.yueStr;
        
        
    }else if (sender.tag == 101){
        self.type = sender.tag - 100;
        self.yjView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"yjright"]];
        [self.rightBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBt setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
       self.titelLB.text = self.jiStr;
        
        [self getData];
        
    }else if (sender.tag  == 102) {
        //点击选择时间
        
        LxmYeJiKaoHeView * view  =[[LxmYeJiKaoHeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) withType:self.type];
//        view.type = self.type;
        WeakObj(self);
        view.confirmBlock = ^(NSInteger year, NSInteger month, NSString * _Nonnull titleStr) {
            if (selfWeak.type == 0) {
                //月
                selfWeak.year = year;
                selfWeak.month = month+1;
                selfWeak.yueStr = titleStr;
                selfWeak.titelLB.text = titleStr;
            }else {
                selfWeak.year = year;
                selfWeak.jiMonth = month;
                selfWeak.jiStr = titleStr;
                selfWeak.titelLB.text = titleStr;
            }
            [selfWeak getData];
        };
        [view show];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LxmMineYeJiKaoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.type = self.type + 100;
    
    cell.leftTwoLB.text = [[NSString stringWithFormat:@"%0.2f",self.dataModel.finishMoney + self.dataModel.inviteToBox * self.dataModel.inviteUserNum] getPriceStr];
    cell.rightTwoLB.text = [[NSString stringWithFormat:@"%0.2f",self.dataModel.targetMoney] getPriceStr];
    cell.numberOneLB.text = [[NSString stringWithFormat:@"%0.2f",self.dataModel.finishMoney] getPriceStr];
    cell.numberTwoLB.text = [[NSString stringWithFormat:@"%0.2f",self.dataModel.inviteUserNum] getPriceStr];
    cell.desLB.text = [NSString stringWithFormat:@"总完成箱数 = 完成箱数+新增统计直属 (1个同级直属 = %ld箱)",(long)self.dataModel.inviteToBox];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isJingLi = self.isJingLi;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
