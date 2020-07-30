//
//  LxmGoodsDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmGoodsDetailVC.h"
#import "SDCycleScrollView.h"
#import "LxmShopView.h"
#import "LxmGoodsDetailShareAlertView.h"
#import "MLYPhotoBrowserView.h"
#import "LxmShopCarVC.h"
#import "LxmShengJiVC.h"
#import "LxmPayVC.h"
#import "WXApi.h"
#import "LxmYiJianBuHuoVC1.h"
#import "LxmShengjiGouWuVC.h"
#import "LxmShengjiGouWuVC.h"

#import "LxmRenZhengProtocolVC.h"
#import "LxmSafeAutherVC.h"

@interface LxmGoodsDetailVC ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate,MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) SDCycleScrollView *headerView;

@property (nonatomic, strong) UILabel *numLabel;//数量

@property (nonatomic, strong) LxmGoodsDetailModel1 *detailModel;

@property (nonatomic, strong) NSMutableArray <LxmGoodsDetailTuPianModel *>*tupianArr;//图片数组

@property (nonatomic, strong) NSMutableArray <LxmGoodsDetailTuPianModel *>*bannerArr;//banner数组

@property (nonatomic, strong) LxmGoodsDetailBottomView *bottomView;

@end

@implementation LxmGoodsDetailVC
- (LxmGoodsDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmGoodsDetailBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.textColor = CharacterGrayColor;
        _numLabel.font = [UIFont systemFontOfSize:15];
    }
    return _numLabel;
}

- (SDCycleScrollView *)headerView {
    if (!_headerView) {
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW) delegate:self placeholderImage:[UIImage imageNamed:@"tupian"]];
        _headerView.localizationImageNamesGroup = @[@"tupian",@"tupian",@"tupian"];
        _headerView.showPageControl = NO;
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    [self initHeaderView];
    [self initNav];
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(50 + TableViewBottomSpace));
    }];
    
    self.tupianArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    [self loadDetailData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        [self loadDetailData];
    }];
    self.bottomView.bottomActionBlock = ^(NSInteger index) {
        [selfWeak bottomButtonClickAtIndex:index];
    };
}

- (void)initNav {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

/**
 初始化头视图
 */
- (void)initHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headerView).offset(-25);
        make.bottom.equalTo(self.headerView).offset(-10);
    }];
    self.numLabel.text = @"1/3";
    WeakObj(self);
    self.headerView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        selfWeak.numLabel.text = [NSString stringWithFormat:@"%ld/%lu", currentIndex + 1,(unsigned long)selfWeak.bannerArr.count];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.tupianArr.count + 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmGoodsDetailPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodsDetailPriceCell"];
        if (!cell) {
            cell = [[LxmGoodsDetailPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodsDetailPriceCell"];
        }
        cell.detailModel = self.detailModel.good;
        return cell;
    } else if (indexPath.section == 1) {
        LxmGoodsDetailPeiSongCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodsDetailPeiSongCell"];
        if (!cell) {
            cell = [[LxmGoodsDetailPeiSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodsDetailPeiSongCell"];
        }
        cell.detailModel = self.detailModel;
        return cell;
    } else {
        if (indexPath.row == 0) {
            LxmGoodsDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodsDetailTopCell"];
            if (!cell) {
                cell = [[LxmGoodsDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodsDetailTopCell"];
            }
            return cell;
        } else if (indexPath.row == 1) {
            LxmGoodsDetailTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodsDetailTextCell"];
            if (!cell) {
                cell = [[LxmGoodsDetailTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodsDetailTextCell"];
            }
            cell.model = self.detailModel.good;
            return cell;
        } else {
            LxmGoodsDetailImgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodsDetailImgCell"];
            if (!cell) {
                cell = [[LxmGoodsDetailImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodsDetailImgCell"];
            }
            cell.tupianModel = self.tupianArr[indexPath.row - 2];
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.detailModel.good.titleH;
    } else if (indexPath.section == 1) {
        if (self.detailModel.postMoney.isValid) {
            return 50;
        }
        return 0.001;
    } else {
        if (indexPath.row == 0) {
            if (self.detailModel.good.content.isValid || self.tupianArr.count > 0) {
                return 50;
            }
            return 0.001;
        } else if (indexPath.row == 1) {
            if (self.detailModel.good.content.isValid) {
                CGFloat h = [self.detailModel.good.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withBoldFontSize:13].height + 15;
                return h > 15 ? h : 0;
            }
            return 0.001;
        } else {
            LxmGoodsDetailTuPianModel *model = self.tupianArr[indexPath.row - 2];
            if (model.width > ScreenW) {
                return ScreenW*model.height/model.width;
            }else {
                return model.height;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    if (self.detailModel.postMoney.isValid) {
        return 10;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row >= 2) {
            MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
            mlyView.dataSource = self;
            mlyView.currentIndex = indexPath.row - 2;
            [mlyView showWithItemsSpuerView:nil];
        }
    }
}

/**
 分享
 */
- (void)rightClick {
    LxmGoodsDetailShareAlertView *alertView = [[LxmGoodsDetailShareAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    WeakObj(self);
    alertView.didSelectShareItemBlock = ^(NSInteger index) {
        [selfWeak shareAtIndex:index];
    };
    [alertView show];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}
/**
 商品详情
 */
- (void)loadDetailData {
    if (!self.detailModel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = SESSION_TOKEN;
    dic[@"id"] = self.goodsID;
    if (self.roleType.isValid) {
        dic[@"role_type"] = self.roleType;
    }
    [LxmNetworking networkingPOST:good_detail parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        StrongObj(self);
        [self endRefrish];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.detailModel = nil;
            [selfWeak.bannerArr removeAllObjects];
            [selfWeak.tupianArr removeAllObjects];
            
            self.detailModel = [LxmGoodsDetailModel1 mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            if (self.roleType.isValid) {
                LxmGoodsDetailModel *temp = self.detailModel.good;
                LxmHomeGoodsModel *goodModel = [LxmHomeGoodsModel new];
                goodModel.id = temp.id;
                goodModel.good_name = temp.goodName;
                goodModel.good_price = temp.goodPrice;
                goodModel.proxy_price = temp.proxyPrice;
                goodModel.list_pic = temp.listPic;
                goodModel.num = temp.num;
                goodModel.up_num = temp.upNum;
                goodModel.com_num = temp.comNum;
                LxmHomeGoodsModel *mm = goodModel;
                bool iscunzai = NO;
                for (LxmHomeGoodsModel *model in [LxmTool ShareTool].shengjiGoodsList) {
                    if ([model.id isEqualToString:goodModel.id]) {
                        iscunzai = YES;
                        mm.num = model.num;
                        mm.up_num = temp.upNum;
                        mm.com_num = temp.comNum;
                        mm = model;
                        break;
                    }
                }
                self.bottomView.carButton.num = iscunzai ? mm.num : @"0";
            } else {
                self.bottomView.carButton.num = self.detailModel.cartNum;
            }
            NSMutableArray *temp = [NSMutableArray array];
            NSArray *tempArr0 = [self.detailModel.good.mainPic mj_JSONObject];
            for (NSDictionary *dict in tempArr0) {
                LxmGoodsDetailTuPianModel *model = [LxmGoodsDetailTuPianModel mj_objectWithKeyValues:dict];
                [temp addObject:model.url];
                [self.bannerArr addObject:model];
            }
            self.numLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)temp.count];
            self.headerView.imageURLStringsGroup = (NSArray *)temp;
            
            NSArray *tempArr = [self.detailModel.good.detailPic mj_JSONObject];
            for (NSDictionary *dict in tempArr) {
                LxmGoodsDetailTuPianModel *model = [LxmGoodsDetailTuPianModel mj_objectWithKeyValues:dict];
                [self.tupianArr addObject:model];
            }
            [self.tableView reloadData ];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.tupianArr.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    LxmGoodsDetailTuPianModel *model = self.tupianArr[index];
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:model.url];
    return photo;
}

/**
 分享
 */
- (void)shareAtIndex:(NSInteger)index {
    switch (index) {
         case 0: {
                   [self shareWXPYQTitle:self.detailModel.good.goodName content:self.detailModel.good.goodName pic:self.detailModel.good.listPic url:[NSString stringWithFormat:@"%@/shareGood.html?good_id=%@",Base_URL,self.detailModel.good.id] ok:nil error:nil];
               }
                   break;
               case 1:{
                   [self shareWeChatTitle:self.detailModel.good.goodName content:self.detailModel.good.goodName pic:self.detailModel.good.listPic url:[NSString stringWithFormat:@"%@/shareGood.html?good_id=%@",Base_URL,self.detailModel.good.id] ok:nil error:nil];
               }
                   break;
               case 2:{
                   [self shareQQTitle:self.detailModel.good.goodName content:self.detailModel.good.goodName pic:self.detailModel.good.listPic url:[NSString stringWithFormat:@"%@/shareGood.html?good_id=%@",Base_URL,self.detailModel.good.id] ok:nil error:nil];
               }
                   break;
               case 3:{
                   [self shareQQZoneitle:self.detailModel.good.goodName content:self.detailModel.good.goodName pic:self.detailModel.good.listPic url:[NSString stringWithFormat:@"%@/shareGood.html?good_id=%@",Base_URL,self.detailModel.good.id] ok:nil error:nil];
               }
                   break;
               case 4:{//复制链接
                   [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@/shareGood.html?good_id=%@",Base_URL,self.detailModel.good.id];
               }
            break;
            
        default:
            break;
    }
}

/**
 底部操作按钮

 @param index 400 401 402
 */
- (void)bottomButtonClickAtIndex:(NSInteger)index {
    if (index == 400) {//购物车
        if (self.isAddLocolGoods) {
            if (self.roleType.isValid) {
                LxmShengjiGouWuVC *vc = [LxmShengjiGouWuVC  new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                WeakObj(self);
                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LxmYiJianBuHuoVC1 class]]) {
                       [selfWeak.navigationController popToViewController:vc animated:YES];
                   }
               }
            }
        } else {
            LxmShopCarVC *vc = [[LxmShopCarVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.isHaoCai = self.isHaoCai;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (index == 401) {//加入购物车
        [self addCarClick];
    } else {//立即购买
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_zjgm];
        vc.zhijieGoumaiMoney = self.detailModel.good.goodPrice;
        vc.shiFuJiFen = self.detailModel.good.scorePrice;
        vc.isHaoCai = self.isHaoCai;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 添加购物车 如果没有角色 需要先升级 最少是高级门店才能购买货物
 */
- (void)addCarClick {
    
    if (self.isHaoCai) {
         [self addgoodsAction];
        return;
    }
    
    
    if (self.shengjiModel) {
        if (([self.roleType isEqualToString:@"-0.5"] || [self.roleType isEqualToString:@"-0.4"] || [self.roleType isEqualToString:@"-0.3"] || [self.roleType isEqualToString:@"1.1"] || [self.roleType isEqualToString:@"2.1"] || [self.roleType isEqualToString:@"3.1"]) && self.detailModel.good.specialType.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:@"不属于减肥单项商品，无法购买"];
            return;
        } else {
            
        }
    } else {
        if (([LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.5"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.4"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"-0.3"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"1.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"2.1"] || [LxmTool.ShareTool.userModel.roleType isEqualToString:@"3.1"]) && self.detailModel.good.specialType.intValue != 2) {
            [SVProgressHUD showErrorWithStatus:@"不属于减肥单项商品，无法购买"];
            return;
        }
    }

    if (self.isAddLocolGoods) {
        LxmGoodsDetailModel *temp = self.detailModel.good;
        LxmHomeGoodsModel *goodModel = [LxmHomeGoodsModel new];
        goodModel.id = temp.id;
        goodModel.good_name = temp.goodName;
        goodModel.good_price = temp.goodPrice;
        goodModel.proxy_price = temp.proxyPrice;
        goodModel.list_pic = temp.listPic;
        goodModel.num = temp.num;
        goodModel.up_num = temp.upNum;
        goodModel.com_num = temp.comNum;
        goodModel.special_type = temp.specialType;
        
        if (self.roleType.isValid) {
            LxmHomeGoodsModel *mm = goodModel;
            bool iscunzai = NO;
            for (LxmHomeGoodsModel *model in [LxmTool ShareTool].shengjiGoodsList) {
                if ([model.id isEqualToString:goodModel.id]) {
                    iscunzai = YES;
                    mm.num = model.num;
                    mm.up_num = temp.upNum;
                    mm.com_num = temp.comNum;
                    mm = model;
                    break;
                }
            }
            
                if (!iscunzai) {
                    mm.num = @"1";
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [[LxmTool ShareTool] saveShengJiSubGoods:mm];
                    [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
                    return;
                } else {
                        mm.num = [NSString stringWithFormat:@"%d",mm.num.integerValue + 1];
                        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                        [[LxmTool ShareTool] saveShengJiSubGoods:mm];
                        [LxmEventBus sendEvent:@"localListUpdate1" data:nil];
                    NSLog(@"%@",[LxmTool ShareTool].shengjiGoodsList);
                self.bottomView.carButton.num = [NSString stringWithFormat:@"%ld",(long)mm.num.integerValue];
            return;
        }
        
    } else {
            bool iscunzai = NO;
            for (LxmHomeGoodsModel *m in [LxmTool ShareTool].goodsList) {
                if (m.id.integerValue == goodModel.id.integerValue) {
                    iscunzai = YES;
                    break;
                }
            }
            if (!iscunzai) {
                goodModel.num = @"1";
            } else {
                goodModel.num = [NSString stringWithFormat:@"%d",goodModel.num.integerValue + 1];
            }
            [[LxmTool ShareTool] saveSubGoods:goodModel];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            NSLog(@"%@",[LxmTool ShareTool].goodsList);
            self.bottomView.carButton.num = [NSString stringWithFormat:@"%lu",(unsigned long)[LxmTool ShareTool].goodsList.count];
            [LxmEventBus sendEvent:@"localListUpdate" data:nil];
            return;
        }
    }
    
    if ([LxmTool ShareTool].userModel.roleType.intValue == -1) {//没有身份 不能进行购买商品
        if ([LxmTool ShareTool].userModel.shopStatus.intValue == 2 || [LxmTool ShareTool].userModel.shopStatus.intValue == 6 ) {
            [self addGouWuCar];
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
        [self addGouWuCar];
    }
}

- (void)addGouWuCar {
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
        
    }  else {
        [self addgoodsAction];
    }
}

- (void)addgoodsAction {
    
    NSMutableDictionary *dict = @{
        @"token" : SESSION_TOKEN,
        @"goodId" : self.detailModel.good.id,
        @"num" : @1
    }.mutableCopy;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:add_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        StrongObj(self);
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
            NSInteger num = self.detailModel.cartNum.integerValue;
            num++;
            self.detailModel.cartNum = @(num).stringValue;
            self.bottomView.carButton.num = self.detailModel.cartNum;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LxmEventBus sendEvent:@"addCarSuccess" data:nil];
            });
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}


@end


@implementation LxmGoodsDetailButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.carNumLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(2);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(5);
            make.centerX.equalTo(self);
        }];
        [self.carNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView).offset(-5);
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(-5);
            make.height.equalTo(@14);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"car"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"购物车";
    }
    return _textLabel;
}

- (UILabel *)carNumLabel {
    if (!_carNumLabel) {
        _carNumLabel = [UILabel new];
        _carNumLabel.layer.cornerRadius = 7;
        _carNumLabel.layer.masksToBounds = YES;
        _carNumLabel.textColor = UIColor.whiteColor;
        _carNumLabel.font = [UIFont systemFontOfSize:10];
        _carNumLabel.backgroundColor = MainColor;
        _carNumLabel.layer.masksToBounds = YES;
        _carNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _carNumLabel;
}

- (void)setNum:(NSString *)num {
    _num = num;
    _carNumLabel.text = num;
    _carNumLabel.hidden = _num.intValue == 0;
    CGFloat w = [num getSizeWithMaxSize:CGSizeMake(ScreenW * 0.25, 14) withFontSize:10].width + 6;
    w = w > 14 ? w : 14;
    [self.carNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(-5);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(-5);
        make.height.equalTo(@14);
        make.width.equalTo(@(w));
    }];
}


@end



@interface LxmGoodsDetailBottomView ()

@property (nonatomic, strong) UIButton *addCarButton;/* 加入购物车 */

@property (nonatomic, strong) UIButton *lijiGoumaiButton;/* 立即购买 */

@end
@implementation LxmGoodsDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.addCarButton];
    [self addSubview:self.carButton];
//    [self addSubview:self.lijiGoumaiButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.carButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self);
        make.width.equalTo(self.addCarButton);
        make.height.equalTo(@50);
    }];
    [self.addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.carButton.mas_trailing);
        make.top.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
//    [self.lijiGoumaiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.trailing.bottom.equalTo(self);
//        make.leading.equalTo(self.addCarButton.mas_trailing);
//    }];
}

- (LxmGoodsDetailButton *)carButton {
    if (!_carButton) {
        _carButton = [LxmGoodsDetailButton new];
        [_carButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _carButton.tag = 400;
    }
    return _carButton;
}

- (UIButton *)addCarButton {
    if (!_addCarButton) {
        _addCarButton = [UIButton new];
        [_addCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addCarButton setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        _addCarButton.titleLabel.font = [UIFont systemFontOfSize:15];
         [_addCarButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateNormal];
        _addCarButton.tag = 401;
        [_addCarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCarButton;
}

- (UIButton *)lijiGoumaiButton {
    if (!_lijiGoumaiButton) {
        _lijiGoumaiButton = [UIButton new];
        [_lijiGoumaiButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_lijiGoumaiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _lijiGoumaiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lijiGoumaiButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _lijiGoumaiButton.tag = 402;
        [_lijiGoumaiButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lijiGoumaiButton;
}

- (void)btnClick:(UIButton *)btn {
    if (self.bottomActionBlock) {
        self.bottomActionBlock(btn.tag);
    }
}

@end
