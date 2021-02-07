//
//  YMRWenZhangYiWanChengListTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangYiWanChengListTVC.h"
#import "YMRFenXiangListCell.h"
@interface YMRWenZhangYiWanChengListTVC ()
@property(nonatomic,strong)NSMutableArray<YMRXueXiModel *> *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面
@end

@implementation YMRWenZhangYiWanChengListTVC
- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前没有数据";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ALCAudioTool shareTool] pauaseMp3];
    
    for (YMRXueXiModel * mm in self.dataArr) {
        mm.leftIsPlaying = mm.rightIsPlaying = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已完成任务";
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRFenXiangListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
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
    [LxmNetworking networkingPOST:finish_work_list parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    return 145;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRFenXiangListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.leftView.actionBt.tag = (indexPath.row+1);
    cell.rightView.actionBt.tag = -(indexPath.row+1);
    [cell.leftView.actionBt addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightView.actionBt addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}


- (void)playAction:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag < 0) {
        tag = -tag;
    }
    YMRXueXiModel * model = self.dataArr[tag-1];
    for (YMRXueXiModel * modelNei in self.dataArr) {
        if ([model isEqual:modelNei]) {
            if (button.tag < 0) {
                // 点击的右边
                
                if (model.rightIsPlaying == NO) {
                    YMRXueXiModel * rightM = [YMRXueXiModel mj_objectWithKeyValues:[model.two_work mj_JSONObject]];
                    [[ALCAudioTool shareTool] palyMp3WithNSSting:rightM.url isLocality:YES];
              
                }else {
                    [[ALCAudioTool shareTool] pauaseMp3];
                }
                model.rightIsPlaying = !model.rightIsPlaying;
                model.leftIsPlaying = NO;
            }else {
                // 点击的左边
                if (model.leftIsPlaying == NO) {
                    YMRXueXiModel * leftM = [YMRXueXiModel mj_objectWithKeyValues:[model.one_work mj_JSONObject]];
                    [[ALCAudioTool shareTool] palyMp3WithNSSting:leftM.url isLocality:YES];
                   
                }else {
                    [[ALCAudioTool shareTool] pauaseMp3];
                }
                model.leftIsPlaying = !model.leftIsPlaying;
                model.rightIsPlaying = NO;
            }
        }else {
            modelNei.leftIsPlaying = modelNei.rightIsPlaying = NO;
        }
    }
    [self.tableView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


@end
