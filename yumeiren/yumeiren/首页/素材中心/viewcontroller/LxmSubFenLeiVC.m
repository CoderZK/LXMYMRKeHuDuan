

//
//  LxmSubFenLeiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubFenLeiVC.h"
#import "LxmFenLeiView.h"
#import "LxmPlayerManager.h"
@interface LxmSubFenLeiVC ()

@property (nonatomic, assign) BOOL iszhankai;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmSuCaiListModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubFenLeiVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.iszhankai = NO;
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    if (self.index == 0) {
        self.emptyView.textLabel.text = [NSString stringWithFormat:@"暂无%@下%@类别素材,赶紧去发布吧~!",@"分类",self.first_type_name];
    } else if (self.index == 1) {
        self.emptyView.textLabel.text = [NSString stringWithFormat:@"暂无%@的%@类别素材!",@"推荐",self.first_type_name];
    } else {
        self.emptyView.textLabel.text = [NSString stringWithFormat:@"您暂没发布%@类别素材,赶紧去发布吧~!",self.first_type_name];
    }
    
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

    [LxmEventBus registerEvent:@"countAdd" block:^(id data) {
        StrongObj(self);
        [self.tableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *arr = [self.tableView visibleCells];
    for (LxmFenLeiVedioCell *cell in arr) {
        if ([cell isKindOfClass:LxmFenLeiVedioCell.class]) {
            [cell stopPlayer];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmFenLeiUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiUserInfoCell"];
        if (!cell) {
            cell = [[LxmFenLeiUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiUserInfoCell"];
        }
        cell.stateLabel.hidden = self.index != 2;
        cell.deleteButton.hidden = self.index != 2;
        cell.tuijianImgView.hidden = self.dataArr[indexPath.section].recommend.integerValue == 2;
        cell.model = self.dataArr[indexPath.section];
        WeakObj(self);
        cell.deleteSuCaiBlock = ^(LxmSuCaiListModel *model) {
            [selfWeak deleteSuCai1:model];
        };
        return cell;
    } else if (indexPath.row == 1) {
        LxmFenLeiContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiContentCell"];
        if (!cell) {
            cell = [[LxmFenLeiContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiContentCell"];
        }
        cell.model = self.dataArr[indexPath.section];
        cell.indexP = indexPath;
        return cell;
    } else if (indexPath.row == 2) {
        LxmFenLeiButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiButtonCell"];
        if (!cell) {
            cell = [[LxmFenLeiButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiButtonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LxmSuCaiListModel *model = self.dataArr[indexPath.section];
        cell.stateLabel.text = model.iszhankai ? @"收缩" : @"展开";
        cell.model = model;
        return cell;
    } else if (indexPath.row == 3) {
        if ([self.dataArr[indexPath.section].video_url isValid]) {
            LxmFenLeiVedioCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiVedioCell"];
            if (!cell) {
                cell = [[LxmFenLeiVedioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiVedioCell"];
            }
            cell.model = self.dataArr[indexPath.section];
            return cell;
        } else {
            LxmFenLeiImgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiImgCell"];
            if (!cell) {
                cell = [[LxmFenLeiImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiImgCell"];
            }
            cell.model = self.dataArr[indexPath.section];
            return cell;
        }
    } else if (indexPath.row == 4){
        LxmFenLeiBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiBottomCell"];
        if (!cell) {
            cell = [[LxmFenLeiBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiBottomCell"];
        }
        cell.lineView.hidden = self.type_id.integerValue == 0;
        cell.model = self.dataArr[indexPath.section];
        return cell;
    } else {
        LxmFenLeiBiaoShiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFenLeiBiaoShiCell"];
        if (!cell) {
            cell = [[LxmFenLeiBiaoShiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFenLeiBiaoShiCell"];
        }
        cell.statelabel.text = [NSString stringWithFormat:@"  %@  ",self.dataArr[indexPath.section].type_name];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath  {
    if ([cell isKindOfClass:LxmFenLeiVedioCell.class]) {
        [(LxmFenLeiVedioCell *)cell stopPlayer];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSuCaiListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 1) {
        NSString *str = model.title;
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 100, 9999) withFontSize:14].height;
        if (h >= 53) {
            return model.iszhankai ? h : 50;
        } else {
            return h;
        }
    } else if (indexPath.row == 2) {
        NSString *str = model.title;
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 100, 9999) withFontSize:14].height;
        return h < 53 ? 0.01 : 20;
    } else if (indexPath.row == 3) {
        if ([self.dataArr[indexPath.section].video_url isValid]) {
            return 180;
        } else {
            NSArray *tempArr = [self.dataArr[indexPath.section].content componentsSeparatedByString:@","];
            CGFloat h = ceil(tempArr.count/3.0) * (floor((ScreenW-120)/3) + 10) + 10;
            return h;
        }
    } else if (indexPath.row == 4){
        return self.type_id.integerValue == 0  ? 25 : 44;
    } else {
        return self.type_id.integerValue == 0  ? 44 : 0.01 ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        LxmSuCaiListModel *model = self.dataArr[indexPath.section];
        model.iszhankai = !model.iszhankai;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
}


/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
//            [SVProgressHUD show];
        }
        NSString *str = @"";
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.index == 0 || self.index == 1) {//分类 推荐
            str = good_judge_list;
            dict[@"recommend"] = self.index == 1 ? @1 : @2;
            dict[@"pageNum"] = @(self.page);
        } else {//我发布的
           str = user_good_judge_list;
            dict[@"token"] = SESSION_TOKEN;
            dict[@"pageNum"] = @(self.page);
        }
        dict[@"type_id"] = self.type_id;
        [LxmNetworking networkingPOST:str parameters:dict returnClass:LxmSuCaiListRootModel.class success:^(NSURLSessionDataTask *task, LxmSuCaiListRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.page ++;
                self.emptyView.hidden = self.dataArr.count > 0;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}

/**
 确定删除素材
 */
- (void)deleteSuCai1:(LxmSuCaiListModel *)model {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除此条素材吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak deleteSuCai:model];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 删除素材
 */
- (void)deleteSuCai:(LxmSuCaiListModel *)model {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:del_judge parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除"];
            [self.dataArr removeObject:model];
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
