//
//  LxmShengYuDaiZhuanJiFenListTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmShengYuDaiZhuanJiFenListTVC.h"
#import "LxmJiFenCYCell.h"
#import "LxmMineTeamJiFenMingXiTVC.h"
@interface LxmShengYuDaiZhuanJiFenListTVC ()

@property (nonatomic, strong) NSMutableArray <LxmMyTeamListModel *>*dataArr;
@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面
@property(nonatomic,assign)NSInteger type;
@property (nonatomic, assign) NSInteger page;

@end

@implementation LxmShengYuDaiZhuanJiFenListTVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前的等级没有直属成员噢~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"待转消息明细";
    [self.view addSubview:self.emptyView];
       [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.view);
       }];
    
    [self.tableView registerClass:[LxmJiFenCYCell class] forCellReuseIdentifier:@"cell"];
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

- (void)loadData  {

    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    [LxmNetworking networkingPOST:score_user_list parameters:dict returnClass:LxmMyTeamListRootModel.class success:^(NSURLSessionDataTask *task, LxmMyTeamListRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            self.page ++;
            self.emptyView.textLabel.text =  @"您当前没有待转小晞";
            self.emptyView.hidden = self.dataArr.count > 0;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LxmJiFenCYCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LxmMineTeamJiFenMingXiTVC * vc =[[LxmMineTeamJiFenMingXiTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
          vc.hidesBottomBarWhenPushed = YES;
    vc.jifenModel = self.dataArr[indexPath.row];
    vc.scoreType = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

