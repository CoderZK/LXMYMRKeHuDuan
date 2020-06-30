//
//  LxmFenLeiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmFenLeiVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"

#import "LxmSubFenLeiVC.h"
#import "LxmPanButton.h"
#import "LxmPublishVC.h"

@interface LxmFenLeiVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmPanButton *publishButton;//发布

@property (nonatomic, strong) LxmSuCaiContentTypeRootModel *model;

@end

@implementation LxmFenLeiVC

- (LxmPanButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [[LxmPanButton alloc] init];
    }
    return _publishButton;
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:17];
        layout.selectedTextFont = [UIFont boldSystemFontOfSize:20];
        layout.normalTextColor = CharacterDarkColor;
        layout.selectedTextColor = UIColor.blackColor;
        layout.progressHeight = 4;
        layout.progressRadius = 2;
        layout.progressColor = MainColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.barStyle = TYPagerBarStyleProgressView;
        layout.animateDuration = 0.25;
        layout.progressVerEdging = 8;
        
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.layout = layout;
        _tabBar.autoScrollItemToCenter = YES;
        _tabBar.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tabBar.layout.cellWidth = floor(ScreenW/5.0);
        _tabBar.layout.progressWidth = 35;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商铺";
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    [self.view addSubview:self.publishButton];
    
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30);
        make.width.height.equalTo(@50);
    }];
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
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    WeakObj(self);
    self.publishButton.panBlock = ^{
        [selfWeak presentPubVC];
    };
    [self loadListData];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.model.result.list.count + 1;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.model.result.list.count + 1;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubFenLeiVC *vc = [[LxmSubFenLeiVC alloc] init];
    if (index == 0) {
        vc.type_id = @"0";
        vc.first_type_name = @"全部";
    } else {
        vc.type_id = self.model.result.list[index - 1].id;
        vc.first_type_name = self.model.result.list[index -1].title;
    }
    vc.index = self.barIndex;
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    if (index == 0) {
      return  [pagerTabBar cellWidthForTitle:@"全部"];
    } else {
       return [pagerTabBar cellWidthForTitle:self.model.result.list[index -1].title];
    }
    
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    if (index == 0) {
        cell.titleLabel.text = @"全部";
    } else {
        cell.titleLabel.text = self.model.result.list[index - 1].title;
    }
    
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

/**
 获取数据
 */
- (void)loadListData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:judge_type_list parameters:nil returnClass:LxmSuCaiContentTypeRootModel.class success:^(NSURLSessionDataTask *task, LxmSuCaiContentTypeRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.model = responseObject;
            [self.tabBar reloadData];
            [self.pagerController reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 模态出发布界面
 */
- (void)presentPubVC {
    LxmPublishVC *vc = [[LxmPublishVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

@end
