//
//  LxmMyTeamVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyTeamVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubMyTeamVC.h"
#import "LxmTuanDuiSearchVC.h"
#import "LxmShopCenterView.h"


@interface LxmMyTeamVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) LxmMyTeamNavView *navView;//导航栏

@property (nonatomic, strong) LxmMyTeamTopView *topView;//顶部视图

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel * yejiLabel;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) LxmMyTeamModel *teamModel;

@end

@implementation LxmMyTeamVC

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

- (UILabel *)yejiLabel {
    if (!_yejiLabel) {
        _yejiLabel = [UILabel new];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"本月直属业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥1079872.00" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        _yejiLabel.attributedText = att;
    }
    return _yejiLabel;
}

- (LxmMyTeamNavView *)navView {
    if (!_navView) {
        _navView = [[LxmMyTeamNavView alloc] init];
        [_navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navView.rightButton addTarget:self action:@selector(sousuoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navView;
}

- (LxmMyTeamTopView *)topView {
    if (!_topView) {
        _topView = [[LxmMyTeamTopView alloc] initWithFrame:CGRectZero style:LxmMyTeamTopView_style_myTeam];
    }
    return _topView;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"直属成员",@"非直属成员"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.navView];
    
    
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.yejiLabel];
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 165));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
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
        make.height.equalTo(@(50 + TableViewBottomSpace));
    }];
    
    [self.yejiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(15);
        make.trailing.equalTo(self.bottomView).offset(-15);
    }];
    self.type = 1;
    [self loadData];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubMyTeamVC *vc = [[LxmSubMyTeamVC alloc] init];
    vc.type = @(index + 1);
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.titleArray[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
    self.type = index + 1;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:index == 0 ? @"本月直属业绩总计： " : @"本月非直属业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.teamModel.saleTotal.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.yejiLabel.attributedText = att;
    [self loadData];
}

#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArray[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    self.type = toIndex + 1;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:toIndex == 0 ? @"本月直属业绩总计： " : @"本月非直属业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.teamModel.saleTotal.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.yejiLabel.attributedText = att;
    [self loadData];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    self.type = toIndex + 1;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:toIndex == 0 ? @"本月直属业绩总计： " : @"本月非直属业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.teamModel.saleTotal.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    self.yejiLabel.attributedText = att;
    [self loadData];
}

/**
 返回
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 搜索
 */
- (void)sousuoClick {
    LxmTuanDuiSearchVC *vc = [[LxmTuanDuiSearchVC alloc] init];
    vc.type = @(self.type);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    if (!self.teamModel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:group_count_total parameters:@{@"token":SESSION_TOKEN,@"type":@(self.type)} returnClass:LxmMyTeamRootModel.class success:^(NSURLSessionDataTask *task, LxmMyTeamRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.teamModel = responseObject.result.map;
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.type == 1 ? @"本月直属业绩总计： " : @"本月非直属业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",selfWeak.teamModel.saleTotal.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            selfWeak.topView.bottomView.titleLabel.text = self.type == 1 ? [NSString stringWithFormat:@"本月新增直属:%ld ",selfWeak.teamModel.monthIn.integerValue] : [NSString stringWithFormat:@"本月新增非直属:%ld ",selfWeak.teamModel.monthIn.integerValue];
            selfWeak.yejiLabel.attributedText = att;
            selfWeak.topView.teamModel = selfWeak.teamModel;
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end

/**
 导航栏
 */
@interface LxmMyTeamNavView ()

@end
@implementation LxmMyTeamNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-8);
            make.width.height.equalTo(@40);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.leftButton);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self.leftButton);
            make.width.height.equalTo(@40);
        }];
    }
    return self;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _leftButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 12);
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"我的团队";
    }
    return _titleLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setImage:[UIImage imageNamed:@"sousuo_white"] forState:UIControlStateNormal];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightButton;
}

@end


@interface LxmTeamButton : UIButton

@property (nonatomic, strong) UILabel *numLabel;//人数

@property (nonatomic, strong) UILabel *textLabel;//说明

@end

@implementation LxmTeamButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.numLabel];
        [self addSubview:self.textLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-3);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(3);
        }];
    }
    return self;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.textColor = MainColor;
        _numLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _numLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = CharacterGrayColor;
    }
    return _textLabel;
}

@end


@interface LxmMyTeamDetailView ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) LxmTeamButton *leftButton;

@property (nonatomic, strong) LxmTeamButton *centerButton;

@property (nonatomic, strong) LxmTeamButton *rightButton;

@property (nonatomic, strong) LxmMyTeamModel *teamModel;//我的团队

@end

@implementation LxmMyTeamDetailView

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.leftButton];
    [self addSubview:self.centerButton];
    [self addSubview:self.rightButton];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self.mas_top).offset(40);
        make.height.equalTo(@0.5);
        
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.leading.bottom.equalTo(self);
        make.trailing.equalTo(self.centerButton.mas_leading);
        make.width.equalTo(self.centerButton);
    }];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self.rightButton.mas_leading);
        make.width.equalTo(self.rightButton);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.trailing.bottom.equalTo(self);
        make.width.equalTo(self.leftButton);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"本月新增直属:1";
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmTeamButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[LxmTeamButton alloc] init];
        _leftButton.numLabel.text = @"1116";
        _leftButton.textLabel.text = @"我的团队";
    }
    return _leftButton;
}

- (LxmTeamButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[LxmTeamButton alloc] init];
        _centerButton.numLabel.text = @"351";
        _centerButton.textLabel.text = @"直属";
    }
    return _centerButton;
}

- (LxmTeamButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[LxmTeamButton alloc] init];
        _rightButton.numLabel.text = @"584";
        _rightButton.textLabel.text = @"非直属";
    }
    return _rightButton;
}

- (void)setTeamModel:(LxmMyTeamModel *)teamModel {
    _teamModel = teamModel;
    _leftButton.numLabel.text = _teamModel.groupTotal;
    _centerButton.numLabel.text = _teamModel.firstT;
    _rightButton.numLabel.text = _teamModel.secondT;
}

@end



@interface LxmMyTeamTopView ()

@property (nonatomic, strong) UIImageView *topView;

@property (nonatomic, strong) UIView *bgbottomView;



@property (nonatomic, strong) LxmShopCenterTopView *bottomView1;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneylabel;//钱数

@property (nonatomic, assign) LxmMyTeamTopView_style style;

@end
@implementation LxmMyTeamTopView

- (instancetype)initWithFrame:(CGRect)frame style:(LxmMyTeamTopView_style)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.style = style;
        [self addSubview:self.topView];
        [self addSubview:self.bgbottomView];
        
        if (style == LxmMyTeamTopView_style_myTeam) {
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self);
                make.height.equalTo(@(NavigationSpace + 120));
            }];
            [self.bgbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-83);
                make.leading.equalTo(self).offset(18);
                make.trailing.equalTo(self).offset(-18);
                make.height.equalTo(@110);
            }];
            [self addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-85);
                make.leading.equalTo(self).offset(15);
                make.trailing.equalTo(self).offset(-15);
                make.height.equalTo(@120);
            }];
        } else if (style == LxmMyTeamTopView_style_otherInfo) {
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self);
                make.height.equalTo(@(NavigationSpace + 120));
            }];
            [self.bgbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-83);
                make.leading.equalTo(self).offset(18);
                make.trailing.equalTo(self).offset(-18);
                make.height.equalTo(@110);
            }];
            [self addSubview:self.bottomView1];
            [self.bottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-85);
                make.leading.equalTo(self).offset(15);
                make.trailing.equalTo(self).offset(-15);
                make.height.equalTo(@120);
            }];
        } else {
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self);
                make.height.equalTo(@(NavigationSpace + 170));
            }];
            [self.bgbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-83);
                make.leading.equalTo(self).offset(18);
                make.trailing.equalTo(self).offset(-18);
                make.height.equalTo(@110);
            }];
            [self addSubview:self.titleLabel];
            [self addSubview:self.moneylabel];
            [self addSubview:self.bottomView2];
            [self.bottomView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(-85);
                make.leading.equalTo(self).offset(15);
                make.trailing.equalTo(self).offset(-15);
                make.height.equalTo(@120);
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(NavigationSpace + 7);
                make.centerX.equalTo(self);
            }];
            [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
                make.centerX.equalTo(self);
            }];
        }
        
    }
    return self;
}

- (UIImageView *)topView {
    if (!_topView) {
        _topView = [UIImageView new];
        _topView.image = [UIImage imageNamed:@"bg_jianbian11"];
    }
    return _topView;
}

- (UIView *)bgbottomView {
    if (!_bgbottomView) {
        _bgbottomView = [UIView new];
        _bgbottomView.backgroundColor = UIColor.whiteColor;
        _bgbottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.4].CGColor;
        _bgbottomView.layer.shadowRadius = 5;
        _bgbottomView.layer.shadowOpacity = 0.5;
        _bgbottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bgbottomView;
}

- (LxmMyTeamDetailView *)bottomView {
    if (!_bottomView) {
        _bottomView = [LxmMyTeamDetailView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.masksToBounds = YES;
    }
    return _bottomView;
}

- (LxmShopCenterTopView *)bottomView1 {
    if (!_bottomView1) {
        _bottomView1 = [[LxmShopCenterTopView alloc] init];
        _bottomView1.backgroundColor = [UIColor whiteColor];
        _bottomView1.layer.cornerRadius = 5;
        _bottomView1.layer.masksToBounds = YES;
        _bottomView1.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _bottomView1.detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _bottomView1;
}

- (LxmQianBaoTopView *)bottomView2 {
    if (!_bottomView2) {
        _bottomView2 = [[LxmQianBaoTopView alloc] init];
        _bottomView2.backgroundColor = [UIColor whiteColor];
        _bottomView2.layer.cornerRadius = 5;
        _bottomView2.layer.masksToBounds = YES;
    }
    return _bottomView2;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"账户余额";
    }
    return _titleLabel;
}

- (UILabel *)moneylabel {
    if (!_moneylabel) {
        _moneylabel = [UILabel new];
        _moneylabel.textColor = UIColor.whiteColor;
        _moneylabel.font = [UIFont boldSystemFontOfSize:30];
        _moneylabel.text = @"115.60";
    }
    return _moneylabel;
}

/**
 我的钱包
 */
- (void)setInfoModel:(LxmUserInfoModel *)infoModel {
    _infoModel = infoModel;
    
    CGFloat f = _infoModel.balance.doubleValue;
    NSInteger d = _infoModel.balance.integerValue;
    if (f == d) {
        _moneylabel.text = [NSString stringWithFormat:@"¥%ld",(long)d];
    } else {
       _moneylabel.text = [NSString stringWithFormat:@"¥%.2f",f];
    }
    
    //市级及以上有 提现 转账按钮
    if ([LxmTool ShareTool].userModel.roleType.intValue < 2) {
        _bottomView2.leftButton.hidden = YES;
        _bottomView2.rightButton.hidden = YES;
        _bottomView2.centerButton.imgView.image = [UIImage imageNamed:@"wdqb_cz"];
        _bottomView2.centerButton.textLabel.text = @"充值";
    } else {
        _bottomView2.leftButton.hidden = NO;
        _bottomView2.rightButton.hidden = NO;
        _bottomView2.centerButton.imgView.image = [UIImage imageNamed:@"wdqb_tx"];
        _bottomView2.centerButton.textLabel.text = @"提现";
    }
    _bottomView2.rightButton.hidden = YES;
}

/**
 我的团队
 */
- (void)setTeamModel:(LxmMyTeamModel *)teamModel {
    _teamModel = teamModel;
    _bottomView.teamModel = _teamModel;
}
/**
 查看他人信息
 */
- (void)setOtherInfoModel:(LxmSeeOtherInfoModel *)otherInfoModel {
    _otherInfoModel = otherInfoModel;
    _bottomView1.nameLabel.text = _otherInfoModel.username;
    _bottomView1.detailLabel.text = [NSString stringWithFormat:@"手机号: %@ 授权码:%@",_otherInfoModel.telephone,_otherInfoModel.recommendCode];
    [_bottomView1.headerImgView sd_setImageWithURL:[NSURL URLWithString:_otherInfoModel.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    if ([_otherInfoModel.roleType isEqualToString:@"-0.5"]){
        [_bottomView1.roleButton setTitle:@"减肥单项-vip会员" forState:UIControlStateNormal];
    } else if ([_otherInfoModel.roleType isEqualToString:@"-0.4"]) {
        [_bottomView1.roleButton setTitle:@"减肥单项-高级会员" forState:UIControlStateNormal];
    } else if ([_otherInfoModel.roleType isEqualToString:@"-0.3"]) {
        [_bottomView1.roleButton setTitle:@"减肥单项-荣誉会员" forState:UIControlStateNormal];
    } else if ([_otherInfoModel.roleType isEqualToString:@"1.1"]) {
        [_bottomView1.roleButton setTitle:@"减肥单项-市服务商" forState:UIControlStateNormal];
    } else if ([_otherInfoModel.roleType isEqualToString:@"2.1"]) {
        [_bottomView1.roleButton setTitle:@"减肥单项-省服务商" forState:UIControlStateNormal];
    } else if ([_otherInfoModel.roleType isEqualToString:@"3.1"]) {
        [_bottomView1.roleButton setTitle:@"减肥单项-CEO" forState:UIControlStateNormal];
    } else {
        switch (_otherInfoModel.roleType.intValue) {
            case -1:
                [_bottomView1.roleButton setTitle:@"无" forState:UIControlStateNormal];
                break;
            case 0:
                [_bottomView1.roleButton setTitle:@"vip门店" forState:UIControlStateNormal];
                break;
            case 1:
                [_bottomView1.roleButton setTitle:@"高级门店" forState:UIControlStateNormal];
                break;
            case 2:
                [_bottomView1.roleButton setTitle:@"市服务商" forState:UIControlStateNormal];
                break;
            case 3:
                [_bottomView1.roleButton setTitle:@"省服务商" forState:UIControlStateNormal];
                break;
            case 4:
                [_bottomView1.roleButton setTitle:@"CEO" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    
}

@end
