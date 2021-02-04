//
//  YMRPaiHangListTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/4.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRPaiHangListTVC.h"
#import "YMRRenWuTwoCell.h"
@interface YMRPaiHangListTVC ()
@property(nonatomic,strong)NSMutableArray<YMRXueXiModel *> *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面
@end

@implementation YMRPaiHangListTVC
- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前没有数据";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"排行榜";
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRRenWuTwoCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
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
        self.page ++;
        [self loadData];
    }];

    
}



- (void)loadData  {

    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    [LxmNetworking networkingPOST:user_card_score_list parameters:dict returnClass:LxmMyTeamListRootModel.class success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray<YMRXueXiModel *> * arr = [YMRXueXiModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
            self.emptyView.hidden = self.dataArr.count > 0;
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
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRRenWuTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    if (indexPath.row <3) {
        [cell.numberBt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dnegji%ld",indexPath.row]] forState:UIControlStateNormal];
        [cell.numberBt setTitle:@"" forState:UIControlStateNormal];
        cell.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"left%ld",indexPath.row]];
    }else {
        [cell.numberBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cell.imageV.image = [UIImage imageNamed:@""];
        [cell.numberBt setTitle:[NSString stringWithFormat:@"%ld",indexPath.row +1] forState:UIControlStateNormal];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

@end
