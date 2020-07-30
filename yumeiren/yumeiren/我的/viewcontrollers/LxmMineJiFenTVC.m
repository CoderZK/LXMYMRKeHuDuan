//
//  LxmMineJiFenTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/28.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineJiFenTVC.h"
#import "LxmJiFenOneCell.h"
#import "LxmJiFenTwoCell.h"
#import "LxmOrderDetailVC.h"
@interface LxmMineJiFenTVC ()
@property(nonatomic,strong)UIView *headV;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UILabel *LB1,*jifenLB;
@property (nonatomic, assign) NSInteger page,allPageNumber;

@property (nonatomic, strong) NSMutableArray <LxmHomeBannerModel *>*dataArr;



@end

@implementation LxmMineJiFenTVC

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _leftButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 12);
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _leftButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initHeadV];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmJiFenOneCell" bundle:nil] forCellReuseIdentifier:@"LxmJiFenOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LxmJiFenTwoCell" bundle:nil] forCellReuseIdentifier:@"LxmJiFenTwoCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
    
    
    
}


- (void)loadData {
        [SVProgressHUD show];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] = @(self.page);
        dict[@"pageSize"] = @10;
        [LxmNetworking networkingPOST:send_score_record_list parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self endRefrish];
            if ([responseObject[@"key"] intValue] == 1000) {
                self.allPageNumber = [responseObject[@"result"][@"allPageNumber"] intValue];
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                
                if (self.page <= self.allPageNumber) {
                    NSArray * arr = [LxmHomeBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
                    [self.dataArr addObjectsFromArray:arr];
                }
                self.page ++;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
}



- (void)initHeadV  {
    
    self.headV = [[UIView alloc] init];
    [self.view addSubview:self.headV];
    UIImageView * imgV = [[UIImageView alloc] init];
    [self.headV addSubview:imgV];
    imgV.image = [UIImage imageNamed:@"fff"];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@240);
    }];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.headV);
    }];
    [self.headV addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headV).offset(15);
        make.top.equalTo(self.headV).offset(StateBarH+2);
               make.width.height.equalTo(@40);
           }];
    
    [self.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.LB1 = [[UILabel alloc] init];
    self.LB1.font = [UIFont systemFontOfSize:16];
    self.LB1.textAlignment = NSTextAlignmentCenter;
    self.LB1.text = @"我的积分";
    self.LB1.textColor = [UIColor whiteColor];
    [self.headV addSubview:self.LB1];
    
    
   self.jifenLB = [[UILabel alloc] init];
   self.jifenLB.font = [UIFont systemFontOfSize:20 weight:0.3];
   self.jifenLB.textAlignment = NSTextAlignmentCenter;
   self.jifenLB.text = @"6666";
   self.jifenLB.textColor = [UIColor whiteColor];
   [self.headV addSubview:self.jifenLB];
    
    [self.LB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftButton.mas_bottom).offset(5);
        make.left.right.equalTo(self.headV);
        make.height.equalTo(@20);
    }];
    
    [self.jifenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LB1.mas_bottom).offset(5);
        make.left.right.equalTo(self.headV);
        make.height.equalTo(@30);
    }];
    
    self.jifenLB.text = [self.jifenStr getPriceStr];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 47;
    }else {
        return 73;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LxmJiFenTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"LxmJiFenTwoCell" forIndexPath:indexPath];
        
        return cell;
    }else {
        LxmJiFenOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"LxmJiFenOneCell" forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == 1) {
        
        LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
        vc.isHiddenBottom = YES;
        vc.orderID = self.dataArr[indexPath.row].info_id;
        vc.isHaoCai = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
