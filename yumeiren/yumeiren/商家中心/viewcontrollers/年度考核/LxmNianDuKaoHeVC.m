//
//  LxmNianDuKaoHeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/4/22.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmNianDuKaoHeVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubNianDuKaoHeVC.h"
#import "LxmShopCenterView.h"

@interface LxmNianDuKaoHeVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) LxmNianDuKaoHeHeaderView *headerView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@property (nonatomic, assign) NSInteger currentIndex;//当前type 团队业绩 还是 推荐业绩

@property (nonatomic, strong) LxmNianDuKaoHeModel *mapModel;

@end

@implementation LxmNianDuKaoHeVC

- (LxmNianDuKaoHeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmNianDuKaoHeHeaderView alloc] init];
    }
    return _headerView;
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        _tabBar.backgroundColor = UIColor.whiteColor;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
       
        _tabBar.layout.progressColor = MainColor;
        _tabBar.layout.textColorProgressEnable = NO;
        _tabBar.layout.selectedTextColor = UIColor.blackColor;
        _tabBar.layout.normalTextColor = CharacterGrayColor;
        _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:14];
        _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:14];
        _tabBar.layout.progressVerEdging = 10;
        _tabBar.layout.progressHeight = 3;
        _tabBar.layout.progressWidth = 35;
        _tabBar.layout.cellWidth = floor((ScreenW - 20)/2.0);
        _tabBar.layout.cellSpacing = 20;
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    }
    return _tabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        TYPagerController *pagerController = [[TYPagerController alloc]init];
        pagerController.layout.prefetchItemCount = 0;
        //pagerController.layout.autoMemoryCache = NO;
        // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
        pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        pagerController.dataSource = self;
        pagerController.delegate = self;
        _pagerController = pagerController;
    }
    return _pagerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"年度考核";
    
    
    [self initSubViews];
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    [self loadNianDuData];
}

- (void)initSubViews {
    [self.view addSubview:self.headerView];
    NSString *str = @"年度考核计算周期: 2020年12月30日-2020年12月30日";
    NSString *str1 = @"";
    
    CGFloat hh = 0;
    CGFloat hh1 = 0;
    
    if ([self.shopInfoModel.roleType isEqualToString:@"2.1"] || [self.shopInfoModel.roleType isEqualToString:@"3"]) {
        str1 = @"说明:年度业绩目标六十万元，业绩不达标系统将自动降级并扣除保证金！";
        hh1 = [str1 getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height + 20;
    } else {
        str1 = @"";
        hh1 = 10;
    }
    
    hh = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0.5);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(hh + hh1 + 140));
    }];
    
    //市代有直属没有非直属，省代和ceo有直属和非直属
    if ([self.shopInfoModel.roleType isEqualToString:@"3.1"] || [self.shopInfoModel.roleType isEqualToString:@"2.1"] || [self.shopInfoModel.roleType isEqualToString:@"3"] || [self.shopInfoModel.roleType isEqualToString:@"4"]) {
        self.titleArray = @[@"直属成员",@"非直属成员"];
        self.tabBar.layout.adjustContentCellsCenter = YES;
        [self initSubView];
    } else if ([self.shopInfoModel.roleType isEqualToString:@"1.1"] || [self.shopInfoModel.roleType isEqualToString:@"2"]) {
        self.titleArray = @[@"直属成员"];
         self.tabBar.layout.adjustContentCellsCenter = NO;
        [self initSubView];
    }
}

- (void)initSubView {
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0.5);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubNianDuKaoHeVC *vc = [[LxmSubNianDuKaoHeVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.type = @(index + 1);
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.titleArray[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    self.currentIndex = index + 1;
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArray[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    self.currentIndex = toIndex + 1;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    self.currentIndex = toIndex + 1;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

//我的年度考核
- (void)loadNianDuData {
    if (!self.mapModel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:year_my parameters:@{@"token" : SESSION_TOKEN} returnClass:LxmNianDuKaoHeRootModel.class success:^(NSURLSessionDataTask *task, LxmNianDuKaoHeRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            selfWeak.mapModel = responseObject.result.map;
            selfWeak.headerView.model = selfWeak.mapModel;
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
