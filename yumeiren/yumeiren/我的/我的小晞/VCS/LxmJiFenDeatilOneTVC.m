//
//  LxmJiFenDeatilOneTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenDeatilOneTVC.h"
#import "LxmJiFenDetailOneCell.h"
#import "LxmJiFenModel.h"
#import "LxmJiFenDetailTwoCell.h"
#import "LxmOrderDetailVC.h"
@interface LxmJiFenDeatilOneTVC ()
@property(nonatomic,strong)UILabel *typeLB,*moneyLB;
@property(nonatomic,strong)LxmJiFenModel *dataModel;
@end

@implementation LxmJiFenDeatilOneTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"明细详情";
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmJiFenDetailOneCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmJiFenDetailTwoCell" bundle:nil] forCellReuseIdentifier:@"LxmJiFenDetailTwoCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self addHeadV];
    
    [self loadData];
}

- (void)loadData {
    
    
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = self.ID;
    [LxmNetworking networkingPOST:score_record_detail parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            
            self.dataModel = [LxmJiFenModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            
            if (self.dataModel.second_type.intValue == 1) {
                   self.moneyLB.text = [NSString stringWithFormat:@"+%@",self.dataModel.score];
                self.typeLB.text = @"直属推荐奖励";
               }else if (self.dataModel.second_type.intValue == 2) {
                   self.moneyLB.text = [NSString stringWithFormat:@"-%@",self.dataModel.score];
                   self.typeLB.text = @"转出";
               }else if (self.dataModel.second_type.intValue == 3) {
                   self.moneyLB.text = [NSString stringWithFormat:@"+%@",self.dataModel.score];
                   self.typeLB.text = @"转入";
               }else if (self.dataModel.second_type.intValue == 4) {
                   self.moneyLB.text = [NSString stringWithFormat:@"-%@",self.dataModel.score];
                   self.typeLB.text = @"提取";
               }else if (self.dataModel.second_type.intValue == 5) {
                   self.moneyLB.text = [NSString stringWithFormat:@"+%@",self.dataModel.score];
                   self.typeLB.text = @"团队销售业绩收入";
               }else if (self.dataModel.second_type.intValue == 6) {
                   self.moneyLB.text = [NSString stringWithFormat:@"+%@",self.dataModel.score];
                    self.typeLB.text = @"转入";
               }else if (self.dataModel.second_type.intValue == 7) {
                   self.moneyLB.text = [NSString stringWithFormat:@"-%@",self.dataModel.score];
                   self.typeLB.text = @"转出";
               }else if (self.dataModel.second_type.intValue == 8) {
                   self.moneyLB.text = [NSString stringWithFormat:@"+%@",self.dataModel.score];
                    self.typeLB.text = @"提取";
               }

            [self.tableView reloadData];
            
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataModel == nil) {
        return 0;
    }else {
        if (self.dataModel.otherInfoList.count == 0) {
            return 1;
        }else {
            return 2;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataModel.second_type.intValue == 1) {
            return 4;
        }else if (self.dataModel.second_type.intValue == 2) {
            return 2;
        }else if (self.dataModel.second_type.intValue == 3) {
            return 2;
        }else if (self.dataModel.second_type.intValue == 4) {
            return 6;
        }else if (self.dataModel.second_type.intValue == 5) {
            return 3;
        }else if (self.dataModel.second_type.intValue == 6) {
            return 2;
        }else if (self.dataModel.second_type.intValue == 7) {
            return 2;
        }else if (self.dataModel.second_type.intValue == 8) {
            return 6;
        }
        return 6;
    }else {
        return self.dataModel.otherInfoList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 45;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if  (section == 0) {
        return 0.01;
    }else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    UIView * backV =[[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW -30 , 0.2)];
    backV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:backV];
    
    UILabel * lb =[[UILabel alloc] initWithFrame:CGRectMake(0, 1, ScreenW, 38)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"-直属分配小晞-";
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = CharacterGrayColor;
    [view addSubview:lb];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LxmJiFenDetailOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSInteger secondTyep = self.dataModel.second_type.intValue;
        [cell.detailBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self settitelWith:cell withType:secondTyep withRow:indexPath.row];
        return cell;
    }else {
        
        LxmJiFenDetailTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"LxmJiFenDetailTwoCell" forIndexPath:indexPath];
        cell.leftLB.text = self.dataModel.otherInfoList[indexPath.row].username;
        cell.rightLB.text = [self.dataModel.otherInfoList[indexPath.row].money getPriceStr];
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.otherInfoList[indexPath.row].userHead] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
        return cell;
    }
    
    
}

- (void)clickAction:(UIButton *)button {
    LxmOrderDetailVC *orderVC = [[LxmOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    orderVC.orderID = self.dataModel.order_id;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)settitelWith:(LxmJiFenDetailOneCell *)cell withType:(NSInteger)secondTyep  withRow:(NSInteger)row{
    
    
    if (secondTyep == 1) {
        cell.detailBt.hidden = YES;
        if (row == 0) {
            cell.leftLB.text = @"推荐直属";
            cell.rightLB.text = self.dataModel.by_name;
        }else if (row == 1) {
            cell.detailBt.hidden = NO;
            cell.leftLB.text = @"订单号";
            cell.rightLB.text = self.dataModel.order_code;
        }else if (row == 2) {
            cell.leftLB.text = @"小晞比例";
            cell.rightLB.text = [NSString stringWithFormat:@"%0.2f%%",self.dataModel.sale_rate.doubleValue * 100 ];
        }else if (row == 3) {
            cell.leftLB.text = @"时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];
        }
        
        
    }else if (secondTyep == 2 ) {
        if (row == 0) {
            cell.leftLB.text = @"来自";
            cell.rightLB.text = self.dataModel.by_name;
        }else if (row == 1) {
            cell.leftLB.text = @"转入时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];
        }
        
    }else if (secondTyep == 3) {
        if (row == 0) {
            cell.leftLB.text = @"转出";
            cell.rightLB.text = self.dataModel.by_name;
        }else if (row == 1) {
            cell.leftLB.text = @"转出时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];
        }
    }else if (secondTyep == 5) {
        if (row == 0) {
            cell.leftLB.text = @"销售业绩";
            cell.rightLB.text = self.dataModel.sale_money;
        }else if (row == 1) {
            cell.leftLB.text = @"小晞比例";
            cell.rightLB.text = [NSString stringWithFormat:@"%0.2f%%",self.dataModel.sale_rate.doubleValue * 100 ];
        }else if (row == 2) {
            cell.leftLB.text = @"收入时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];;
        }
    }else if (secondTyep == 6) {
        if (row == 0) {
            cell.leftLB.text = @"来自";
            cell.rightLB.text = self.dataModel.by_name;
        }else if (row == 1) {
            cell.leftLB.text = @"转入时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];
        }
    }else if (secondTyep == 7) {
        if (row == 0) {
            cell.leftLB.text = @"转出";
            cell.rightLB.text = self.dataModel.by_name;
        }else if (row == 1) {
            cell.leftLB.text = @"转出时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];
        }
    }else if (secondTyep == 8 || secondTyep == 4) {
        cell.rightLB.textColor = CharacterDarkColor;
        
        if (row == 0) {
            cell.leftLB.text = @"提取小晞";
            cell.rightLB.text = self.dataModel.score;
        }else if (row == 1) {
            cell.leftLB.text = @"提取时间";
            cell.rightLB.text = [self.dataModel.create_time getIntervalToZHXLongTime];;
        }else if (row == 2) {
            cell.leftLB.text = @"提取状态";
            
            
            if (self.dataModel.status.intValue == 1) {
                cell.rightLB.textColor = RGB(244, 150, 86);
                cell.rightLB.text = @"审核中";
            }else if (self.dataModel.status.intValue == 2) {
                cell.rightLB.textColor = CharacterDarkColor;
                cell.rightLB.text = @"提取成功";
            }else {
                cell.rightLB.textColor = CharacterDarkColor;
                cell.rightLB.text = @"失败";
            }
        }else if (row == 3) {
            cell.leftLB.text = @"提取方式";
            if (self.dataModel.info_type.intValue == 1) {
                cell.rightLB.text = @"银行卡";
                
            }else {
                cell.rightLB.text = @"支付宝";
            }
        }
        else if (row == 4) {
            cell.leftLB.text = @"姓名";
            
            if (self.dataModel.info_type.intValue == 1) {
                cell.rightLB.text = self.dataModel.bank_username;
            }else {
                cell.rightLB.text = self.dataModel.zhi_name;
            }
            
            
        }
        else if (row == 5) {
            cell.leftLB.text = @"账号";
            
            
            if (self.dataModel.info_type.intValue == 1) {
                cell.rightLB.text = self.dataModel.bank_code;
            }else {
                cell.rightLB.text = self.dataModel.zhi_account;
            }
            
            
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)addHeadV  {
    
    UIView * headV  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 180)];
    headV.backgroundColor  = [UIColor whiteColor];
    
    self.typeLB  = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 20)];
    self.typeLB.textAlignment = NSTextAlignmentCenter;
    self.typeLB.font = [UIFont systemFontOfSize:14];
    self.typeLB.textColor = CharacterDarkColor;
    self.typeLB.text = @"提现";
    [headV addSubview:self.typeLB];
    
    self.moneyLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, ScreenW, 30)];
    self.moneyLB.textAlignment = NSTextAlignmentCenter;
    self.moneyLB.font = [UIFont systemFontOfSize:16 weight:0.2];
    self.moneyLB.textColor = CharacterDarkColor;
    self.moneyLB.text = @"+30000";
    [headV addSubview:self.moneyLB];
    self.tableView.tableHeaderView = headV;
    UIView * backV =[[UIView alloc] initWithFrame:CGRectMake(0, 179.5, ScreenW, 0.5)];
    backV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headV addSubview:backV];
    
    
   
    
    
    
}



@end
