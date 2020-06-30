

//
//  LxmSubBuHuoCaiGouAndXiaoShouVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubCaiGouAndXiaoShouVC.h"
#import "LxmSubBuHuoOrderVC.h"
#import "LxmJieSuanView.h"
#import "LxmOrderDetailVC.h"
#import "LxmPayVC.h"

@interface LxmSubCaiGouAndXiaoShouVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubCaiGouAndXiaoShouVC

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
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
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
    [LxmEventBus registerEvent:@"jiesuanSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    [LxmEventBus registerEvent:@"tuihuoSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    [LxmEventBus registerEvent:@"cancelSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    _emptyView.textLabel.text = self.type.integerValue == 2 ? @"暂无批发销售订单哦~" : @"暂无批发采购订单哦~";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LxmShopCenterOrderModel *model = self.dataArr[section];
    return model.sub2.count + 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmSubBuHuoOrderTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderTopCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderTopCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 2) {
        LxmSubBuHuoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 1){
        LxmSubBuHuoOrderButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        if (self.dataArr[indexPath.section].status.integerValue == 1) {
            cell.leftButton.hidden = NO;
            
        } else {
            cell.leftButton.hidden = YES;
        }
        WeakObj(self);
        cell.gotobuhuoBlock = ^{//1 待支付 4已完成
            [selfWeak buttonAction:selfWeak.dataArr[indexPath.section]];
        };
        cell.tuidanBlock = ^{
            [selfWeak tuidan:selfWeak.dataArr[indexPath.section]];
        };
        return cell;
    } else {
        LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section].sub2[indexPath.row - 1];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 2) {
        return 44;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 1) {
        if (self.dataArr[indexPath.section].status.intValue == 1) {//去支付
            if (self.type.intValue == 2) {//批发销售
                return 0.01;
            }
            return 60;
        }
        return 0.01;
    } else {
         return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCenterOrderModel *model = self.dataArr[indexPath.section];
    LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
    vc.iscaiGouandXiaoshou = YES;
    vc.orderID = model.id;
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        if (self.status.intValue == 2) {//批发采购和批发销售已完成传4
            if (self.type.intValue == 2  || self.type.intValue == 3) {
                dict[@"status"] = @4;
            } else {
                dict[@"status"] = self.status;
            }
        } else {
            dict[@"status"] = self.status;
        }
        dict[@"type"] = self.type;
        [LxmNetworking networkingPOST:order_list parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
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


- (void)buttonAction:(LxmShopCenterOrderModel *)model {
    if (model.status.integerValue == 1) {//去支付
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_ddcx];
        vc.orderID = model.id;
        vc.shifuMoney = model.total_money;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//退单
- (void)tuidan:(LxmShopCenterOrderModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要退单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:return_buy_order parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject.key.integerValue == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"退单成功!"];
                [self.dataArr removeObject:model];
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 去支付
 */
- (void)gotoPay {
    LxmPayVC *vc = [[LxmPayVC alloc] init];
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}

@end
