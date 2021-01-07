//
//  LxmSearchVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSearchVC.h"
#import "LxmSearchView.h"
#import "LxmHomeView.h"
#import "LxmGoodsDetailVC.h"
#import "LxmShengJiVC.h"

#import "LxmRenZhengProtocolVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmSubInfoClassVC.h"
#import "LxmClassInfoDetailVC.h"
/**
 大家都在搜
 */
@interface LxmSearchPageReusableView ()

@property (nonatomic, strong) UILabel *titleLabel;//大家都在搜

@end
@implementation LxmSearchPageReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"大家都在搜";
    }
    return _titleLabel;
}

@end


/**
 cell
 */
@interface LxmSearchPageReusableCell ()

@property (nonatomic, strong) UILabel *titleLabel;//大家都在搜

@end

@implementation LxmSearchPageReusableCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGGrayColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"专卖店";
    }
    return _titleLabel;
}

@end


@interface LxmSearchVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic, strong) LxmSearchPageView *serachView;//搜索栏

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionView *collectionView1;

@property (nonatomic, strong) UICollectionView *collectionView2;

@property (nonatomic, strong) NSArray <NSString *>*hotArr;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmHomeGoodsModel *>*dataArr1;

@property (nonatomic, strong) NSMutableArray <LxmClassGoodsModel *>*dataArr2;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSearchVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"换个关键词吧~没有结果呢";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.itemSize = CGSizeMake(floor((ScreenW - 60)/3.0), 30);
        layout.headerReferenceSize = CGSizeMake(ScreenW - 30, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmSearchPageReusableCell.class forCellWithReuseIdentifier:@"LxmSearchPageReusableCell"];
        [_collectionView registerClass:LxmSearchPageReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LxmSearchPageReusableView"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 15, 15);
    }
    return _collectionView;
}

- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake(floor((ScreenW - 25)/2.0), floor((ScreenW - 25)/2.0) + 50);
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView1.backgroundColor = BGGrayColor;
        _collectionView1.dataSource = self;
        _collectionView1.delegate = self;
        [_collectionView1 registerClass:LxmHomeGoodsItem.class forCellWithReuseIdentifier:@"LxmHomeGoodsItem"];
    }
    return _collectionView1;
}

- (UICollectionView *)collectionView2 {
    if (!_collectionView2) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake((ScreenW - 25)/2, (ScreenW - 25)/2 * 3/4 + 10 + 40 + 10 + 15 + 15);
        _collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ((ScreenW - 25)/2 * 3/4 + 10 + 40 + 10 + 15 + 15 + 5)*ceil(6/2.0) + 20) collectionViewLayout:layout];
        _collectionView2.backgroundColor = BGGrayColor;
        _collectionView2.dataSource = self;
        _collectionView2.delegate = self;
        _collectionView2.scrollEnabled = YES;
        [_collectionView2 registerClass:LxmSubClassInfoCell.class forCellWithReuseIdentifier:@"LxmSubClassInfoCell"];
        [_collectionView2 registerClass:LxmSubYuYinInfoCell.class forCellWithReuseIdentifier:@"LxmSubYuYinInfoCell"];
        
    }
    return _collectionView2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _collectionView) {
        return self.hotArr.count;
    } else if (collectionView == _collectionView1) {
        return self.dataArr1.count;
    }
    return self.dataArr2.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        LxmSearchPageReusableCell *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmSearchPageReusableCell" forIndexPath:indexPath];
        buttonItem.titleLabel.text = self.hotArr[indexPath.item];
        return buttonItem;

    } else if (collectionView == _collectionView1){
        LxmHomeGoodsItem *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeGoodsItem" forIndexPath:indexPath];
        buttonItem.isHaoCai = self.isHaoCai;
        buttonItem.goodsModel = self.dataArr1[indexPath.item];
        WeakObj(self);
        buttonItem.addCardClickBlock = ^(LxmHomeGoodsModel *goodsModel) {
            [selfWeak addCarClick:goodsModel];
        };
        return buttonItem;
    } else {
        LxmClassGoodsModel *model = self.dataArr2[indexPath.item];
        if (model.info_type.intValue == 1 || model.info_type.intValue == 3) {//
            LxmSubClassInfoCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmSubClassInfoCell" forIndexPath:indexPath];
            itemCell.model = model;
            return itemCell;
        } else {
            LxmSubYuYinInfoCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmSubYuYinInfoCell" forIndexPath:indexPath];
            itemCell.model = model;
            return itemCell;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        LxmSearchPageReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LxmSearchPageReusableView" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        _collectionView.hidden = YES;
        _emptyView.hidden = YES;
        _collectionView1.hidden = NO;
        self.keywords = [NSString stringWithFormat:@"%@", self.hotArr[indexPath.item]];
        self.serachView.searchTF.text = self.keywords;
        if (self.isClass) {
           self.page = 1;
           [self loadData1];
        } else {
            self.page = 1;
            [self loadData];
        }
    } else if (collectionView == _collectionView1){
        LxmGoodsDetailVC *vc = [[LxmGoodsDetailVC alloc] init];
        vc.roleType = self.roleType;
        vc.goodsID = self.dataArr1[indexPath.item].id;
        vc.isAddLocolGoods = self.isAddLocolGoods;
        vc.isHaoCai = self.isHaoCai;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LxmClassInfoDetailVC *vc = [LxmClassInfoDetailVC new];
        vc.classId = self.dataArr2[indexPath.row].id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (LxmSearchPageView *)serachView {
    if (!_serachView) {
        _serachView = [[LxmSearchPageView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 30, 30)];
        _serachView.searchTF.delegate = self;
    }
    return _serachView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _collectionView.hidden = NO;
    _emptyView.hidden = YES;
    if (self.isClass) {
        _collectionView2.hidden = YES;
    } else {
        _collectionView1.hidden = YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _collectionView.hidden = NO;
    _emptyView.hidden = YES;
    if (self.isClass) {
        _collectionView2.hidden = YES;
    } else {
        _collectionView1.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.serachView endEditing:YES];
    if (!textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容!"];
        return NO;
    }
    _collectionView.hidden = YES;
    _emptyView.hidden = YES;
    self.keywords = textField.text;
    self.page = 1;
    if (self.isClass) {
        _collectionView2.hidden = NO;
        [self loadData1];
    } else {
        _collectionView1.hidden = NO;
        [self loadData];
    }
    
    
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.serachView];
    [self.view addSubview:self.collectionView];
    if (self.isClass) {
        [self.view addSubview:self.collectionView2];
    } else {
       [self.view addSubview:self.collectionView1];
    }
    
    [self.view addSubview:self.emptyView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serachView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    if (self.isClass) {
        [self.collectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.serachView.mas_bottom).offset(15);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
        _collectionView2.hidden = YES;
    } else {
        [self.collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.serachView.mas_bottom).offset(15);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
        _collectionView1.hidden = YES;
    }
    
    _collectionView.hidden = NO;
    [self loadkeywords];
    
    WeakObj(self);
    if (selfWeak.isClass) {
        self.collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            selfWeak.page = 1;
            [selfWeak loadData1];
        }];
        self.collectionView2.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [selfWeak loadData1];
        }];
        self.dataArr2 = [NSMutableArray array];
    } else {
        self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            selfWeak.page = 1;
            [selfWeak loadData];
        }];
        self.collectionView1.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [selfWeak loadData];
        }];
        self.dataArr1 = [NSMutableArray array];
    }
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serachView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
}

/**
 热搜关键词
 */
- (void)loadkeywords {
    [SVProgressHUD show];
    WeakObj(self);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"infoType"] = self.isClass ? @2 : @1;
    
    [LxmNetworking networkingPOST:hot_words parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.hotArr = responseObject[@"result"][@"list"];
            [selfWeak.collectionView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 加载商品列表
 */
- (void)loadData {
    if (self.dataArr1 <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"good_type"] = @0;
    dict[@"pageNum"] = @(self.page);
    dict[@"pageSize"] = @10;
    dict[@"role_type"] = self.roleType.isValid ? self.roleType : [LxmTool ShareTool].userModel.roleType;
    if (self.keywords.isValid) {
        dict[@"keyword"] = self.keywords;
    }
    if (self.isHaoCai) {
        dict[@"noVip"] = @"2";
    }else {
        dict[@"noVip"] = @"1";
    }
    if (self.shengjiModel.suType.length > 0) {
        dict[@"su_type"] = self.shengjiModel.suType;
    }else {
        dict[@"su_type"] = [LxmTool ShareTool].userModel.suType;
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:group_good_list parameters:dict returnClass:LxmShopListRootModel.class success:^(NSURLSessionDataTask *task, LxmShopListRootModel *responseObject) {
        StrongObj(self);
        [self endRefresh];
        if (responseObject.key.integerValue == 1000) {
            if (self.page == 1) {
                [self.dataArr1 removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                [self.dataArr1 addObjectsFromArray:responseObject.result.list];
            }
            self.emptyView.hidden = self.dataArr1.count > 0;
            self.page++;
            [self.collectionView1 reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
    }];
}

- (void)endRefresh {
    [SVProgressHUD dismiss];
    [self.collectionView1.mj_header endRefreshing];
    [self.collectionView1.mj_footer endRefreshing];
}

- (void)endRefresh1 {
    [SVProgressHUD dismiss];
    [self.collectionView2.mj_header endRefreshing];
    [self.collectionView2.mj_footer endRefreshing];
}


- (void)loadData1 {
    if (self.dataArr2 <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    if (self.info_type != 100) {
        dict[@"info_type"] = @(self.info_type);
    }
    if (self.keywords.isValid) {
        dict[@"keyword"] = self.keywords;
    }
    dict[@"pageNum"] = @(self.page);
    dict[@"pageSize"] = @10;
    
    WeakObj(self);
    [LxmNetworking networkingPOST:course_list parameters:dict returnClass:LxmClassRootModel.class success:^(NSURLSessionDataTask *task, LxmClassRootModel *responseObject) {
        StrongObj(self);
        [self endRefresh1];
        if (responseObject.key.integerValue == 1000) {
            if (self.page == 1) {
                [self.dataArr2 removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                 [self.dataArr2 addObjectsFromArray:responseObject.result.list];
            }
            self.page++;
            [self.collectionView2 reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh1];
    }];
}

/**
 添加购物车 如果没有角色 需要先升级 最少是经理才能购买货物
 */
- (void)addCarClick:(LxmHomeGoodsModel *)goodModel {
    if (self.shengjiModel) {
        if ( ([self.roleType isEqualToString:@"-0.5"] || [self.roleType isEqualToString:@"-0.4"] || [self.roleType isEqualToString:@"-0.3"] || [self.roleType isEqualToString:@"1.1"] || [self.roleType isEqualToString:@"2.1"] || [self.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:@"不属于小红包系列商品，无法购买"];
            return;
        }
    } else {
        if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) && goodModel.special_type.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:@"不属于小红包系列商品，无法购买"];
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

    if (self.isHaoCai) {
        [self addCar:goodModel];
    }else {
        if ([LxmTool ShareTool].userModel.roleType.intValue == -1) {//没有身份 不能进行购买商品
                   if ([LxmTool ShareTool].userModel.shopStatus.intValue == 2 || [LxmTool ShareTool].userModel.shopStatus.intValue == 6 ) {
                       [self addCar:goodModel];
        //               addCarBlock();
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
                   [self addCar:goodModel];
        //           addCarBlock();
               }
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
    
    if (selfWeak.isHaoCai) {
        //耗材
        addCar();
    }else {
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


@end

