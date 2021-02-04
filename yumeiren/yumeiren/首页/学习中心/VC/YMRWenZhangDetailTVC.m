//
//  YMRWenZhangDetailTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangDetailTVC.h"
#import "YMRFenXiangListCell.h"
#import "YMRGenDuTV.h"
//#import "LxmClassInfoTitleCell.h"
#import "LxmClassInfoDetailVC.h"
#import "YMRNoDaTaCell.h"
@interface YMRWenZhangDetailTVC ()
@property(nonatomic,strong)UIView * bottomV;
@property(nonatomic,strong)NSMutableArray<YMRXueXiModel *> *dataArr;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) LxmClassDetailModel *detailModel;
@end

@implementation YMRWenZhangDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRFenXiangListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
    [self initBottomView];
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
    [self getData];
    
}
//获取文章详情
- (void)getData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:course_detail parameters:@{@"token":SESSION_TOKEN, @"id":self.articleId} returnClass:LxmClassDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmClassDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            selfWeak.detailModel = responseObject.result.data;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadData  {

    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    dict[@"articleId"] = self.articleId;
    [LxmNetworking networkingPOST:article_work_list parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endRefrish];
        if ([responseObject[@"key"] intValue] == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray<YMRXueXiModel *> * arr = [YMRXueXiModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
          
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
    
    
}


- (void)initBottomView  {
    
    self.bottomV = [[UIView alloc] init];
    self.bottomV.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
    self.bottomV.layer.shadowOffset = CGSizeMake(0,-3);
        // 设置阴影透明度
    self.bottomV.layer.shadowOpacity = 0.08;
        // 设置阴影半径
    self.bottomV.layer.shadowRadius = 20;
    self.bottomV.clipsToBounds = NO;
    self.bottomV.backgroundColor = [UIColor whiteColor];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.frame = CGRectMake(15, 10, ScreenW - 30, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;

   
    [button setTitle:@"我要跟读" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomV addSubview:button];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomV];
    button.backgroundColor = RGB(234, 104, 118);
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@(60 + TableViewBottomSpace));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(60 + TableViewBottomSpace));
    }];
    
}
//点击跟读
- (void)clickAction:(UIButton *)button {
    
    YMRGenDuTV * vc =[[YMRGenDuTV alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
    vc.hidesBottomBarWhenPushed = YES;
    vc.articleId = self.articleId;
    vc.detailModel = self.detailModel;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        if (self.dataArr.count == 0) {
            return 1;
        }else {
            return self.dataArr.count;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.detailModel.titleH;
        }  else{
            return self.detailModel.contentH;
        }
    }else {
        if (self.dataArr.count == 0){
            return 300;
        }
        return 145;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"head"];
        
        UIView * lineV  = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, ScreenW, 0.5)];
        lineV.backgroundColor = LineColor;
        [view addSubview:lineV];
        
        UIView * bV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        bV.backgroundColor = BGGrayColor;
        [view addSubview:bV];
        UILabel * lb  = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, ScreenW - 30, 30)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = @"分享列表";
        [view addSubview:lb];
        view.backgroundColor = [UIColor whiteColor];
        view.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    view.clipsToBounds = YES;
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LxmClassInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoTitleCell"];
            if (!cell) {
                cell = [[LxmClassInfoTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoTitleCell"];
            }
            cell.detailModel = self.detailModel;
            return cell;
        } else {
            LxmClassInfoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoDetailCell"];
            if (!cell) {
                cell = [[LxmClassInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoDetailCell"];
            }
            cell.detailModel = self.detailModel;
            return cell;
        }
    }else {
        
        if (self.dataArr.count == 0) {
            YMRNoDaTaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YMRNoDaTaCell"];
            if (!cell) {
                cell = [[YMRNoDaTaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YMRNoDaTaCell"];
            }
            return cell;
        }else {
            YMRFenXiangListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.model = self.dataArr[indexPath.row];
            return cell;
        }
        
    }
   
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArr.count == 0) {
        return;
    }
    
}




@end
