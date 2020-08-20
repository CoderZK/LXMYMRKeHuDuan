//
//  LxmMineTeamJiFenMingXiTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineTeamJiFenMingXiTVC.h"
#import "LxmMineJiFenMingXiOneCell.h"
#import "LxmJiFenModel.h"
#import "LxmYeJiKaoHeView.h"
@interface LxmMineTeamJiFenMingXiTVC ()
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJiFenModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@property(nonatomic,strong)UIView *headV;

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *timeLB,*tuanDuiYeJiLB;
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIButton *headBt;
@property(nonatomic,assign)NSInteger type,year,month;
@property(nonatomic,strong)NSString *montyStr;

@end

@implementation LxmMineTeamJiFenMingXiTVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前的等级没有直属成员噢~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setNave];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headV.mas_bottom);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmMineJiFenMingXiOneCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.montyStr = [dateFormatter stringFromDate:[NSDate date]];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        self.page = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        StrongObj(self);
        [self loadData];
    }];
    [self loadGroupData];
    [self setHeadSubViews];
    
    
}

- (void)setHeadSubViews {
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    self.headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = self.headView;
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = [UIFont systemFontOfSize:13];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.montyStr = [dateFormatter stringFromDate:[NSDate date]];
    self.timeLB.text = [dateFormatter stringFromDate:[NSDate date]];
    [self.headView addSubview:self.timeLB];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(15);
        make.centerY.equalTo(self.headView.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.imgV =[[UIImageView alloc] init];
    self.imgV.image = [UIImage imageNamed:@"kkback"];
    [self.headView addSubview:self.imgV];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLB.mas_right).offset(3);
        make.centerY.equalTo(self.headView.mas_centerY);
        make.height.equalTo(@6);
        make.width.equalTo(@(10.5));
    }];
    
    self.headBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW / 2, 45)];
    [self.headBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.headBt];
    
    
    
}



- (void)clickAction:(UIButton *)button {
    LxmYeJiKaoHeView * view  =[[LxmYeJiKaoHeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) withType:0];
    //        view.type = self.type;
    WeakObj(self);
    view.confirmBlock = ^(NSInteger year, NSInteger month, NSString * _Nonnull titleStr) {
        selfWeak.year = year;
        selfWeak.month = month;
        selfWeak.montyStr  = [NSString stringWithFormat:@"%ld-%02ld",year,(long)month+1];
        selfWeak.timeLB.text = titleStr;
        
        selfWeak.page = 1;
        [selfWeak loadData];
    };
    [view show];
}

- (void)setNave {
    
    self.headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, StateBarH + 44 + 200)];
    self.headV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headV];
    
    UIImageView * imageV  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, StateBarH + 44 + 120)];
    [self.headV addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"bg_jianbian11"];
    imageV.backgroundColor = [UIColor redColor];
    
    UILabel * lb  = [[UILabel alloc] initWithFrame:CGRectMake(50, StateBarH, ScreenW - 100, 44)];
    lb.text = @"团队小晞明细";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:18];
    lb.textColor = [UIColor whiteColor];
    [self.view addSubview:lb];
    
    UIButton * backBt  = [[UIButton alloc] initWithFrame:CGRectMake(10, StateBarH + 7, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];
    
    
    UIView * whiteV = [[UIView alloc] init];
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    whiteV.layer.shadowRadius = 5;
    whiteV.layer.shadowOpacity = 0.5;
    whiteV.layer.shadowOffset = CGSizeMake(0, 0);
    [self.headV addSubview:whiteV];
    [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headV).offset(20);
        make.bottom.right.equalTo(self.headV).offset(-20);
        make.top.equalTo(self.headV).offset(StateBarH + 44 + 20);
    }];
    
    UILabel * nameLB  =[[UILabel alloc] init];
    nameLB.font = [UIFont systemFontOfSize:20 weight:0.2];
    [whiteV addSubview:nameLB];
    
    UILabel * roleLB  =[[UILabel alloc] init];
    roleLB.textColor = MainColor;
    roleLB.layer.cornerRadius = 10;
    roleLB.clipsToBounds = YES;
    roleLB.font = [UIFont systemFontOfSize:14];
    roleLB.layer.borderColor = MainColor.CGColor;
    roleLB.layer.borderWidth = 0.5;
    [whiteV addSubview:roleLB];
    
    UILabel * leftOneLB = [[UILabel alloc] init];
    leftOneLB.textColor = CharacterLightGrayColor;
    leftOneLB.font = [UIFont systemFontOfSize:14];
    leftOneLB.text = @"剩余小晞 ";
    [whiteV addSubview:leftOneLB];
    
    UILabel * leftTwoLB = [[UILabel alloc] init];
    leftTwoLB.textColor = MainColor;
    leftTwoLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [whiteV addSubview:leftTwoLB];
    
    UILabel * rightOneLB = [[UILabel alloc] init];
    rightOneLB.textColor = CharacterLightGrayColor;
    rightOneLB.font = [UIFont systemFontOfSize:14];
    
    rightOneLB.text = @"本月业绩￥";
    [whiteV addSubview:rightOneLB];
    
    UILabel * rightTwoLB = [[UILabel alloc] init];
    rightTwoLB.textColor = MainColor;
    rightTwoLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [whiteV addSubview:rightTwoLB];
    
    UILabel * rightThreeLB = [[UILabel alloc] init];
    rightThreeLB.textColor = CharacterLightGrayColor;
    rightThreeLB.font = [UIFont systemFontOfSize:14];
    
    rightThreeLB.text = @"团队业绩￥";
    [whiteV addSubview:rightThreeLB];
    
    UILabel * rightFourLB = [[UILabel alloc] init];
    rightFourLB.textColor = MainColor;
    rightFourLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [whiteV addSubview:rightFourLB];
    self.tuanDuiYeJiLB = rightFourLB;
    
    
    UIButton * headBt  = [[UIButton alloc] init];
    headBt.layer.cornerRadius = 30;
    headBt.clipsToBounds = YES;
    [whiteV addSubview:headBt];
    headBt.clipsToBounds = YES;
    headBt.layer.cornerRadius = 30;
   
    
    UIImageView * sexImgV  =[[UIImageView alloc] init];
    sexImgV.image  = [UIImage imageNamed:@"nv"];
    [whiteV addSubview:sexImgV];
    if (self.jifenModel.sex.intValue == 2) {
        sexImgV.image = [UIImage imageNamed:@"nan"];
    }
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(whiteV).offset(20);
        make.height.equalTo(@30);
    }];
    [roleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLB);
        make.top.equalTo(nameLB.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    
    [leftOneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.left.equalTo(nameLB);
        make.bottom.equalTo(whiteV).offset(-40);
    }];
    
    [leftTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.equalTo(leftOneLB);
        make.left.equalTo(leftOneLB.mas_right).offset(5);
        
    }];
    
    [headBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteV).offset(-15);
        make.top.equalTo(whiteV).offset(15);
        make.width.height.equalTo(@60);
    }];
    
    [sexImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headBt);
        make.centerY.equalTo(headBt.mas_centerY).offset(12);
        make.height.width.equalTo(@12);
    }];
    
    [rightTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(leftOneLB);
        make.right.equalTo(whiteV).offset(-20);
        make.top.equalTo(leftOneLB.mas_bottom);
        
    }];
    
    [rightOneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.equalTo(rightTwoLB);
        make.right.equalTo(rightTwoLB.mas_left).offset(-5);
        
    }];
    
    [rightFourLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(leftOneLB);
        make.right.equalTo(whiteV).offset(-20);
        make.bottom.equalTo(leftOneLB.mas_top);
        
    }];
    
    [rightThreeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.equalTo(rightFourLB);
        make.right.equalTo(rightFourLB.mas_left).offset(-5);
        
    }];
    
    [self.headBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteV).offset(20);
        make.right.equalTo(whiteV).offset(-20);
        make.height.width.equalTo(@60);
    }];
    
    if ([self.jifenModel.role_type isEqualToString:@"0"]) {
        roleLB.text = @"  无身份  ";
    }else if ([self.jifenModel.role_type isEqualToString:@"1"]) {
        roleLB.text = @"  经理  ";
    }else if ([self.jifenModel.role_type isEqualToString:@"2"]) {
        roleLB.text = @"  总经理  ";
    }else if ([self.jifenModel.role_type isEqualToString:@"3"]) {
        roleLB.text = @"  董事  ";
    }
    nameLB.text = self.jifenModel.username;
    leftTwoLB.text = [self.jifenModel.group_score getPriceStr];
    rightTwoLB.text = [self.jifenModel.one_base_in_money getPriceStr];
    [headBt sd_setBackgroundImageWithURL:[NSURL URLWithString:self.jifenModel.user_head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    
    
    
}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadGroupData {
    
    
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] =  self.jifenModel.id;
  
    [LxmNetworking networkingPOST:my_group_total_sale parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            self.tuanDuiYeJiLB.text = [[NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"group_sale"]] getPriceStr];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
    
}

- (void)confirmScoreWithModel:(LxmJiFenModel *)model {
    
       [SVProgressHUD show];
       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       dict[@"token"] = SESSION_TOKEN;
       dict[@"infoType"] = @(self.scoreType);
       dict[@"id"] = model.ID;
       [LxmNetworking networkingPOST:confirm_score parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           [self endRefrish];
           if ([responseObject[@"key"] intValue] == 1000) {
               
               model.status = @"2";
               [self.tableView reloadData];
               
           } else {
               [UIAlertController showAlertWithmessage:responseObject[@"message"]];
           }
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           [self endRefrish];
       }];
    
    
}


- (void)loadData {
    
    
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    dict[@"scoreType"] = @(self.scoreType);
    dict[@"userId"] = self.jifenModel.id;
    dict[@"month"] = self.montyStr;
    [LxmNetworking networkingPOST:score_record_list parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:[LxmJiFenModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]]];
            self.emptyView.textLabel.text = @"暂无数据";
            self.emptyView.hidden = self.dataArr.count > 0;
            self.page ++;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LxmMineJiFenMingXiOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
