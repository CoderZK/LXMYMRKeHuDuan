//
//  LxmTouSuCenterVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTouSuCenterVC.h"
#import "LxmTouSuView.h"
#import "LxmPublishTouSuVC.h"
#import "LxmTouSuDetailVC.h"

@interface LxmTouSuCenterVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *tousuButton;//投诉

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmTouSuListModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmTouSuCenterVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您暂时无投诉!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

- (UIButton *)tousuButton {
    if (!_tousuButton) {
        _tousuButton = [[UIButton alloc] init];
        [_tousuButton setTitle:@"投诉" forState:UIControlStateNormal];
        [_tousuButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tousuButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _tousuButton.layer.cornerRadius = 5;
        _tousuButton.layer.masksToBounds = YES;
        _tousuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_tousuButton addTarget:self action:@selector(tousuButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tousuButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投诉中心";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.tousuButton];
    [self.view addSubview:self.emptyView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(64 + TableViewBottomSpace));
    }];
    [self.tousuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self.bottomView).offset(20);
        make.trailing.equalTo(self.bottomView).offset(-20);
        make.height.equalTo(@44);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        StrongObj(self);
        [self loadData];
    }];
    
    [LxmEventBus registerEvent:@"toususuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    [LxmEventBus registerEvent:@"detailTousuAction" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmTouSuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTouSuListCell"];
    if (!cell) {
        cell = [[LxmTouSuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTouSuListCell"];
    }
    cell.listModel = self.dataArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmTouSuDetailVC *vc = [[LxmTouSuDetailVC alloc] init];
    vc.ID = self.dataArr[indexPath.section].id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 投诉
 */
- (void)tousuButtonClick {
    LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPublishTouSuVC_type_tousu];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:complain_list parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page)} returnClass:LxmTouSuListRootModel.class success:^(NSURLSessionDataTask *task, LxmTouSuListRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.emptyView.hidden = self.dataArr.count > 0;
                self.page ++;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}


@end
