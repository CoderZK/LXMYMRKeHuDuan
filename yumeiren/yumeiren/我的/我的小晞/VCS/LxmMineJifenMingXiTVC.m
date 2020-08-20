//
//  LxmMineJifenMingXiTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineJifenMingXiTVC.h"
#import "LxmMineJiFenMingXiOneCell.h"
#import "LxmYeJiKaoHeView.h"
#import "LxmJiFenDeatilOneTVC.h"
@interface LxmMineJifenMingXiTVC ()
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *timeLB;
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIButton *headBt;
@property(nonatomic,assign)NSInteger type,year,month;
@property(nonatomic,strong)NSString *montyStr;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJiFenModel *>*dataArr;
@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面
@property(nonatomic,strong)UIView *bottomV;
@property(nonatomic,strong)UILabel *allXiaoXiLB,*monthXiaoXiLB;



@end

@implementation LxmMineJifenMingXiTVC

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的小晞明细";
    
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    self.headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = self.headView;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmMineJiFenMingXiOneCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setHeadSubViews];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.montyStr = [dateFormatter stringFromDate:[NSDate date]];
    self.dataArr = [NSMutableArray array];
    
    if (self.scoreType == 1) {
        self.navigationItem.title = @"我的直属小晞";
        [self initBottomV];
        [self getJiFenData];
    }
    
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
    
    
    
}

- (void)getJiFenData  {
    
    [SVProgressHUD show];
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = [LxmTool ShareTool].session_token;
    dict[@"month"] = self.montyStr;
    [LxmNetworking networkingPOST:month_total_direct_score

                       parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            
            self.allXiaoXiLB.text = [[NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"totalGet"]] getPriceStr];;
            self.monthXiaoXiLB.text =[[NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"totalOut"]] getPriceStr];
            
            
        } else {
          
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
         [SVProgressHUD dismiss];
        
    }];
    
    
    
    
    
}



- (void)initBottomV {
    
    self.bottomV = [[UIView alloc] init];
    self.bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomV];
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (StateBarH >20) {
            make.bottom.equalTo(self.view).offset(-34);
        }else {
            make.bottom.equalTo(self.view);
        }
        make.height.equalTo(@50);
    }];
    self.bottomV.layer.shadowColor = CharacterDarkColor.CGColor;
    self.bottomV.layer.shadowOpacity = 0.1;
    self.bottomV.layer.shadowRadius = 3;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomV.mas_top);
    }];
    
    UILabel * lb1  =[[UILabel alloc] init];
    lb1.font = [UIFont systemFontOfSize:13];
    lb1.text = @"当月总小晞: ";
    lb1.textColor = CharacterDarkColor;
    [self.bottomV addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.left.equalTo(self.bottomV).offset(15);
    }];
    
    
    UILabel * lb2  =[[UILabel alloc] init];
    lb2.font = [UIFont systemFontOfSize:14];
    lb2.text = @"2000";
    lb2.textColor = MainColor;
    [self.bottomV addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.left.equalTo(lb1.mas_right).offset(15);
    }];
    self.allXiaoXiLB = lb2;
    
    
    
    
    
    UILabel * lb4  =[[UILabel alloc] init];
    lb4.font = [UIFont systemFontOfSize:14];
    lb4.text = @"2000";
    lb4.textColor = MainColor;
    [self.bottomV addSubview:lb4];
    [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.right.equalTo(self.bottomV).offset(-15);
    }];
    self.monthXiaoXiLB = lb4;
    
    
    UILabel * lb3  =[[UILabel alloc] init];
    lb3.font = [UIFont systemFontOfSize:13];
    lb3.text = @"当月提取小晞: ";
    lb3.textColor = CharacterDarkColor;
    [self.bottomV addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.right.equalTo(self.monthXiaoXiLB.mas_left).offset(-10);
    }];
    
    
}


- (void)setHeadSubViews {
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = [UIFont systemFontOfSize:13];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.montyStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
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

//点击月份
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
        [selfWeak getJiFenData];
    };
    [view show];
}

- (void)loadData {
    
    
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    dict[@"scoreType"] = @(self.scoreType);
    dict[@"month"] = self.montyStr;
    [LxmNetworking networkingPOST:score_record_list parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            
            [self.dataArr addObjectsFromArray:[LxmJiFenModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]]];
            self.page ++;
            self.emptyView.textLabel.text = @"暂无数据";
            self.emptyView.hidden = self.dataArr.count > 0;
            [self.tableView reloadData];
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
    cell.type = 1;
    cell.model = self.dataArr[indexPath.row];
    
    if([cell.typeBt.titleLabel.text isEqualToString:@"确认"]) {
        cell.typeBt.userInteractionEnabled = YES;
        cell.typeBt.tag = indexPath.row;
        [cell.typeBt addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.typeBt.userInteractionEnabled = NO;
        
    }
    return cell;
    
}

- (void)confirmAction:(UIButton *)button {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要确认" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self confirmScoreWithModel:self.dataArr[button.tag]];
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [ac addAction:action1];
    [ac addAction:action2];
    [self.navigationController presentViewController:ac animated:YES completion:nil];
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    LxmJiFenDeatilOneTVC * vc =[[LxmJiFenDeatilOneTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ID = self.dataArr[indexPath.row].ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
