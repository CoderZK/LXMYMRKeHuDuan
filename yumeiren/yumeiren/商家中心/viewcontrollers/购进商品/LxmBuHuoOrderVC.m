//
//  LxmBuHuoOrderVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmBuHuoOrderVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubBuHuoOrderVC.h"
//#import "LxmYiJianBuHuoVC.h"

#import "LxmYiJianBuHuoVC1.h"

@interface LxmBuHuoOrderVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmBuHuoOrderBottomView *bottomView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@end

@implementation LxmBuHuoOrderVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmBuHuoOrderBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmBuHuoOrderBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        WeakObj(self);
        _bottomView.yijianClickBlock = ^{
            [selfWeak buhuoClick];
        };
    }
    return _bottomView;
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        _tabBar.backgroundColor = UIColor.whiteColor;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
        _tabBar.layout.cellWidth = ScreenW/5.0;
        _tabBar.layout.adjustContentCellsCenter = YES;
        _tabBar.layout.progressColor = MainColor;
        _tabBar.layout.textColorProgressEnable = NO;
        _tabBar.layout.selectedTextColor = UIColor.blackColor;
        _tabBar.layout.normalTextColor = CharacterGrayColor;
        _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.cellSpacing = 1;
        _tabBar.layout.progressVerEdging = 10;
        _tabBar.layout.progressHeight = 3;
        _tabBar.layout.progressWidth = 35;
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    }
    return _tabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        TYPagerController *pagerController = [[TYPagerController alloc]init];
        pagerController.layout.prefetchItemCount = 1;
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
    self.navigationItem.title = @"补货订单";
    self.titleArray = @[@"全部",@"待补货",@"待支付",@"已完成",@"已过期"];
    [self initSubviews];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    [self.view addSubview:self.bottomView];
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    
    [self.view addSubview:self.lineView];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 60));
    }];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubBuHuoOrderVC *vc = [[LxmSubBuHuoOrderVC alloc]init];
    if (index == 0) {
        vc.status = @0;
    } else {
        vc.status = @(index + 8);
    }
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.titleArray[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArray[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

/**
 一键补货
 */
- (void)buhuoClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @1;
    dict[@"pageSize"] = @10;
    dict[@"status"] = @9;
    WeakObj(self);
    [LxmNetworking networkingPOST:back_order_list parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (responseObject.result.list.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"您暂无待补货的订单!"];
            } else {
                LxmYiJianBuHuoVC1 *vc = [[LxmYiJianBuHuoVC1 alloc] init];
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
   
}

@end

/// 一键补货
@interface LxmBuHuoOrderBottomView ()

@property (nonatomic, strong) UIButton *yijianBuhuoButton;

@end
@implementation LxmBuHuoOrderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yijianBuhuoButton];
        [self.yijianBuhuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@200);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

- (UIButton *)yijianBuhuoButton {
    if (!_yijianBuhuoButton) {
        _yijianBuhuoButton = [UIButton new];
        [_yijianBuhuoButton setTitle:@"一键补货" forState:UIControlStateNormal];
        [_yijianBuhuoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_yijianBuhuoButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_yijianBuhuoButton addTarget:self action:@selector(buhuoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _yijianBuhuoButton.layer.cornerRadius = 20;
        _yijianBuhuoButton.layer.masksToBounds = YES;
    }
    return _yijianBuhuoButton;
}

- (void)buhuoButtonClick {
    if (self.yijianClickBlock) {
        self.yijianClickBlock();
    }
}

@end
