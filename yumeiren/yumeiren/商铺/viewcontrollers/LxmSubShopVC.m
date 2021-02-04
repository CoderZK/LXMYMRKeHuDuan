//
//  LxmSubShopVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubShopVC.h"
#import "LxmHomeView.h"
#import "LxmGoodsDetailVC.h"
#import "LxmShengJiVC.h"

#import "LxmRenZhengProtocolVC.h"
#import "LxmSafeAutherVC.h"

@interface LxmSubShopVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmHomeGoodsModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmSubShopVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake((ScreenW - 25)/2, (ScreenW - 25)/2 + 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ((ScreenW - 25)/2 + 50 + 5)*ceil(6/2.0) + 20) collectionViewLayout:layout];
        _collectionView.backgroundColor = BGGrayColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LxmHomeGoodsItem.class forCellWithReuseIdentifier:@"LxmHomeGoodsItem"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    WeakObj(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadData];
    }];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeGoodsItem *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeGoodsItem" forIndexPath:indexPath];
    itemCell.isHaoCai = self.isHaoCai;
    itemCell.goodsModel = self.dataArr[indexPath.item];
    WeakObj(self);
    itemCell.addCardClickBlock = ^(LxmHomeGoodsModel *goodsModel) {
        [selfWeak addCarClick:goodsModel];
    };
    return itemCell;
}

/**
 添加购物车 如果没有角色 需要先升级 最少是经理才能购买货物
 */
- (void)addCarClick:(LxmHomeGoodsModel *)goodModel {
    
    if (self.isHaoCai) {
        [self addCar:goodModel];
        return;
    }
    if (self.shengjiModel) {
        if ( ([self.roleType isEqualToString:@"-0.5"] || [self.roleType isEqualToString:@"-0.4"] || [self.roleType isEqualToString:@"-0.3"] || [self.roleType isEqualToString:@"1.1"] || [self.roleType isEqualToString:@"2.1"] || [self.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"不属于%@商品，无法购买",[LxmTool ShareTool].roleTypeName]];
            return;
        }
    } else {
        if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"不属于%@商品，无法购买",[LxmTool ShareTool].roleTypeName]];
            return;
        }
    }
    
    if (self.isAddLocolGoods) {//是否是添加到本地购物列表
        bool iscunzai = NO;
        for (LxmHomeGoodsModel *m in [LxmTool ShareTool].shengjiGoodsList) {
           if (m.id.integerValue == goodModel.id.integerValue) {
               iscunzai = YES;
               goodModel.num = m.num;
               break;
           }
        }
       if (!iscunzai) {
           goodModel.num = @"1";
       } else {
           goodModel.num = [NSString stringWithFormat:@"%ld",goodModel.num.integerValue + 1];
       }
       [SVProgressHUD showSuccessWithStatus:@"添加成功"];
       if (self.roleType.isValid) {
          [[LxmTool ShareTool] saveShengJiSubGoods:goodModel];
           NSLog(@"%@",[LxmTool ShareTool].shengjiGoodsList);
          [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
           return;
       } else {
           [[LxmTool ShareTool] saveSubGoods:goodModel];
           NSLog(@"%@",[LxmTool ShareTool].goodsList);
           [LxmEventBus sendEvent:@"localListUpdate" data:nil];
           return;
       }
    }

    if ([LxmTool ShareTool].userModel.roleType.intValue == -1) {//没有身份 不能进行购买商品
        if ([LxmTool ShareTool].userModel.shopStatus.intValue == 2 || [LxmTool ShareTool].userModel.shopStatus.intValue == 6 ) {
//            addCarBlock();
            [self addCar:goodModel];
        } else {
            if ([LxmTool ShareTool].userModel.idCode.isValid) {//已实名认证
                if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 1) {//已读
                    LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([LxmTool ShareTool].userModel.thirdStatus.intValue == 2){
                    //未读 跳转协议界面
                    LxmRenZhengProtocolVC *vc = [[LxmRenZhengProtocolVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isnext = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
//        addCarBlock();
        [self addCar:goodModel];
    }
}

- (void)addCar:(LxmHomeGoodsModel *)goodModel {
    
    
    
    WeakObj(self);
    void(^addCar)(void) = ^{
      
        NSMutableDictionary *dict = @{
                               @"token" : SESSION_TOKEN,
                               @"goodId" : goodModel.id,
                               @"num" : @1
        }.mutableCopy;
//        if ((LxmTool.ShareTool.userModel.roleType.intValue == 2 || LxmTool.ShareTool.userModel.roleType.intValue == 3) && self.isHaoCai == NO) {
//            dict[@"num"] = goodModel.buy_num;
//        }
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:add_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LxmEventBus sendEvent:@"addCarSuccess" data:nil];
                });
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    };
    
    if (self.isHaoCai) {
        addCar();
    }else {
        if (self.shengjiModel) {
            if ( ([self.roleType isEqualToString:@"-0.5"] || [self.roleType isEqualToString:@"-0.4"] || [self.roleType isEqualToString:@"-0.3"] || [self.roleType isEqualToString:@"1.1"] || [self.roleType isEqualToString:@"2.1"] || [self.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"不属于%@商品，无法购买",[LxmTool ShareTool].roleTypeName]];
                return;
            }
        } else {
            if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"不属于%@商品，无法购买",[LxmTool ShareTool].roleTypeName]];
                return;
            }
        }
        
        NSInteger shopStatus = LxmTool.ShareTool.userModel.shopStatus.intValue;
        if (shopStatus == 0 || shopStatus == 1 || shopStatus == 2 || shopStatus == 4 || shopStatus == 5) {//有升级中的状态 不能直接加入购物车 要提示进入升级通道
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"进入升级通道,下单更便宜哦!" message:@"是否进入升级通道?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
               vc.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:vc animated:YES];
            }]];
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
            
        } else {
            addCar();
        }
    }
    
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmGoodsDetailVC *vc = [[LxmGoodsDetailVC alloc] init];
    vc.shengjiModel = self.shengjiModel;
    vc.roleType = self.roleType;
    vc.goodsID = self.dataArr[indexPath.item].id;
    vc.isAddLocolGoods = self.isAddLocolGoods;
    vc.isHaoCai = self.isHaoCai;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 加载商品列表
 */
- (void)loadData {
    if (self.dataArr <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"good_type"] = self.type_id;
    dict[@"pageNum"] = @(self.page);
    dict[@"pageSize"] = @10;
    if (self.roleType.isValid) {
        dict[@"role_type"] = self.roleType;
    }
    if (self.isHaoCai) {
        dict[@"noVip"] = @"2";
    }else {
        dict[@"noVip"] = @"1";
    }
    
    if (self.shengjiModel.suType.length > 0) {
        dict[@"su_type"] = self.shengjiModel.suType;
    }
    
    WeakObj(self);
    [LxmNetworking networkingPOST:group_good_list parameters:dict returnClass:LxmShopListRootModel.class success:^(NSURLSessionDataTask *task, LxmShopListRootModel *responseObject) {
        StrongObj(self);
        [self endRefresh];
        if (responseObject.key.integerValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                 [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            self.page++;
            [self.collectionView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
    }];
}

- (void)endRefresh {
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

@end
