//
//  LxmOrderChaXunVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmOrderChaXunVC.h"
#import "LxmSubOrderChaXunVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubCaiGouAndXiaoShouVC.h"
#import "LxmShopCenterSelectedView.h"

@interface LxmOrderChaXunButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;//文字

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@end

@implementation LxmOrderChaXunButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.iconImgView.mas_leading).offset(-3);
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.textColor = UIColor.blackColor;
    }
    return _textLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"xuanze1"];
    }
    return _iconImgView;
}

@end



@interface LxmOrderChaXunVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@property (nonatomic, strong) LxmOrderChaXunButton *titleButton;

@property (nonatomic, strong) LxmShopCenterSelectedView *selectedView;

@property (nonatomic, assign) NSInteger titleIndex;

@end

@implementation LxmOrderChaXunVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (LxmOrderChaXunButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [[LxmOrderChaXunButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        _titleButton.textLabel.text = @"发货订单";
        [_titleButton addTarget:self action:@selector(titleSelectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (LxmShopCenterSelectedView *)selectedView {
    if (!_selectedView) {
        _selectedView = [LxmShopCenterSelectedView new];
        _selectedView.dataArr = @[@"发货订单", @"批发销售", @"批发采购"];
        WeakObj(self);
        _selectedView.didSelectedIndex = ^(NSInteger currentIndex) {
            [selfWeak didSelectedIndex:currentIndex];
        };
    }
    return _selectedView;
}

- (void)didSelectedIndex:(NSInteger)currentIndex {
    if (currentIndex == 0) {
        _tabBar.layout.cellWidth = floor(ScreenW/6.0);
        _tabBar.layout.cellSpacing = 0;
        self.titleArray = @[@"全部",@"待发货",@"待收货",@"待自提",@"已收货",@"已自提",@"已取消"];
        self.titleButton.textLabel.text = @"发货订单";
    } else if (currentIndex == 1) {
        _tabBar.layout.cellWidth = floor((ScreenW - 40)/3.0);
        _tabBar.layout.cellSpacing = 20;
        self.titleButton.textLabel.text = @"批发销售";
        self.titleArray = @[@"全部",@"待支付",@"已完成"];
    } else {
        _tabBar.layout.cellWidth = floor((ScreenW - 40)/3.0);
        _tabBar.layout.cellSpacing = 20;
        self.titleButton.textLabel.text = @"批发采购";
        self.titleArray = @[@"全部",@"待支付",@"已完成"];
    }
    self.titleIndex = currentIndex + 1;
    [self.tabBar reloadData];
    [self.pagerController reloadData];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        _tabBar.backgroundColor = UIColor.whiteColor;
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
        _tabBar.layout.adjustContentCellsCenter = YES;
        _tabBar.layout.progressColor = MainColor;
        _tabBar.layout.textColorProgressEnable = NO;
        _tabBar.layout.selectedTextColor = UIColor.blackColor;
        _tabBar.layout.normalTextColor = CharacterGrayColor;
        _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.progressVerEdging = 10;
        _tabBar.layout.progressHeight = 3;
        _tabBar.layout.progressWidth = 35;
        _tabBar.layout.cellWidth = floor(ScreenW/5.0);
        _tabBar.layout.cellSpacing = 0;
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
    self.navigationItem.titleView = self.titleButton;
    self.titleArray = @[@"全部",@"待发货",@"待收货",@"待自提",@"已收货",@"已自提",@"已取消"];
    [self initSubviews];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    self.titleIndex = 1;//发货订单
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
    if (self.selectedView.currentIndex == 0) {
        LxmSubOrderChaXunVC *vc = [[LxmSubOrderChaXunVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSubOrderChaXunVC_type_shopCenter];
        //@[@"全部",@"待发货",@"待收货",@"待自提",@"已收货",@"已自提",@"已取消"];
        if (index == 0) {
            vc.status = @0;
        } else if (index == 1){
            vc.status = @2;
        } else if (index == 2) {
            vc.status = @3;
        } else if (index == 3) {
            vc.status = @7;
        } else if (index == 4) {
            vc.status = @4;
        } else if (index == 5) {
            vc.status = @8;
        } else if (index == 6) {
            vc.status = @5;
        }
        return vc;
    }
    LxmSubCaiGouAndXiaoShouVC *vc = [[LxmSubCaiGouAndXiaoShouVC alloc] init];
    vc.type = @(self.titleIndex);
    if (index == 2) {
        vc.status = @4;
    }
    vc.status = @(index);
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
 导航栏titleview
 */
- (void)titleSelectClick {
    if (self.selectedView.superview) {
        [self.selectedView dismiss];
    } else {
        [self.selectedView showAtView:self.view];
    }
}

@end
