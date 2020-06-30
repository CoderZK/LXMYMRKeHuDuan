//
//  LxmYeJiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmYeJiVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LxmSubYeJiVC.h"

@interface LxmYeJiVC()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UILabel *rankLabel;//同级别业绩排行

@property (nonatomic, strong) LxmYeJiTopView *yejiView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *titleArray;//顶部标题数组

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel * yejiLabel;

@property (nonatomic, strong) NSString *currentTime;//当前年月

@property (nonatomic, assign) NSInteger currentIndex;//当前type 团队业绩 还是 推荐业绩

@property (nonatomic, strong) LxmMyYeJiModel *yejiModel;//当前页面业绩model

@end

@implementation LxmYeJiVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.font = [UIFont systemFontOfSize:12];
        _rankLabel.textColor = CharacterGrayColor;
    }
    return _rankLabel;
}

- (LxmYeJiTopView *)yejiView {
    if (!_yejiView) {
        _yejiView = [LxmYeJiTopView new];
    }
    return _yejiView;
}

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
    }
    return _yejiLabel;
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
    self.navigationItem.title = @"我的业绩";
    self.titleArray = @[@"团队业绩",@"推荐业绩"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.rankLabel];
    [self.view addSubview:self.yejiView];
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.yejiLabel];
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.leading.equalTo(self.view).offset(15);
    }];
    if (LxmTool.ShareTool.userModel.roleType.intValue >= 3) {
        self.rankLabel.hidden = NO;
        [self.yejiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rankLabel.mas_bottom).offset(12);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@120);
        }];
    } else {
        [self.yejiView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.rankLabel.hidden = YES;
            make.top.equalTo(self.lineView.mas_bottom).offset(12);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@120);
        }];
    }
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yejiView.mas_bottom);
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
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    
    self.currentIndex = 1;
    self.currentTime = [dateFormatter stringFromDate:[NSDate date]];
    [self loadDateAtIndex:self.currentIndex];
    WeakObj(self);
    self.yejiView.selectYearAndMonth = ^(NSString *yearMonth) {
        selfWeak.currentTime = yearMonth;
        [selfWeak loadDateAtIndex:selfWeak.currentIndex];
        LxmSubYeJiVC *vc = (LxmSubYeJiVC *)[selfWeak.pagerController controllerForIndex:selfWeak.pagerController.curIndex];;
        vc.page = 1;
        vc.currentTime = yearMonth;
        [vc loadData];
    };
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArray.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LxmSubYeJiVC *vc = [[LxmSubYeJiVC alloc] init];
    vc.currentTime = self.currentTime;
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
    [self loadDateAtIndex:self.currentIndex];
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
    [self loadDateAtIndex:self.currentIndex];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    self.currentIndex = toIndex + 1;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

/**
 加载数据 我的业绩-汇总
 */
- (void)loadDateAtIndex:(NSInteger)index {
    NSArray *arr = [self.currentTime componentsSeparatedByString:@"-"];
    if (arr.count == 2) {
        NSString *fomaMonth = [NSString stringWithFormat:@"%02ld",[arr.lastObject integerValue]];
        self.currentTime = [NSString stringWithFormat:@"%@-%@",arr.firstObject,fomaMonth];
    }
    if (!self.yejiModel) {
        [SVProgressHUD show];
    }
    WeakObj(self);
    [LxmNetworking networkingPOST:sale_count_total parameters:@{@"token":SESSION_TOKEN,@"type":@(index),@"month":self.currentTime} returnClass:LxmMyYeJiRootModel.class success:^(NSURLSessionDataTask *task, LxmMyYeJiRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000 && index == selfWeak.currentIndex) {
            selfWeak.yejiModel = responseObject.result.map;
            selfWeak.rankLabel.text = [NSString stringWithFormat: @"同级别业绩排行: %@名", selfWeak.yejiModel.rank];
                       selfWeak.yejiView.model = selfWeak.yejiModel;
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:selfWeak.currentIndex == 1 ? @"本月团队业绩总计： " : @"本月推荐业绩总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",selfWeak.yejiModel.groupTotal.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
            [att appendAttributedString:str];
            _yejiLabel.attributedText = att;
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end

@interface LxmYeJiTopButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIView *lineView;//分割线

@end

@implementation LxmYeJiTopButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.lineView];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-2);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(2);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.trailing.equalTo(self);
            make.width.equalTo(@1);
            
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = CharacterGrayColor;
    }
    return _textLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:16];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmYeJiTopMonthView : UIControl

@property (nonatomic, strong) UIButton *leftButon;

@property (nonatomic, strong) UIImageView *leftImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *rightButon;

@property (nonatomic, strong) UIImageView *rightImgView;

@end
@implementation LxmYeJiTopMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftButon];
        [self.leftButon addSubview:self.leftImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightButon];
        [self.rightButon addSubview:self.rightImgView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@100);
            make.top.bottom.equalTo(self);
        }];
        [self.leftButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self);
            make.trailing.equalTo(self.titleLabel.mas_leading);
        }];
        [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.titleLabel.mas_leading);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.rightButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self);
            make.leading.equalTo(self.titleLabel.mas_trailing);
        }];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIButton *)leftButon {
    if (!_leftButon) {
        _leftButon = [UIButton new];
    }
    return _leftButon;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [UIImageView new];
        _leftImgView.image = [UIImage imageNamed:@"ico_jiantou1"];
    }
    return _leftImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"2019年6月";
    }
    return _titleLabel;
}

- (UIButton *)rightButon {
    if (!_rightButon) {
        _rightButon = [UIButton new];
    }
    return _rightButon;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [UIImageView new];
        _rightImgView.image = [UIImage imageNamed:@"ico_jiantou"];
    }
    return _rightImgView;
}

@end


/**
 头视图
 */
#import "LxmYearMonthPickerView.h"
@interface LxmYeJiTopView ()

@property (nonatomic, strong) LxmYeJiTopMonthView *monthView;

@property (nonatomic, strong) LxmYeJiTopButton *leftButton;

@property (nonatomic, strong) LxmYeJiTopButton *centerButton;

@property (nonatomic, strong) LxmYeJiTopButton *rightButton;

@property (nonatomic, strong) UIView *bgTopView;

@property (nonatomic, strong) UIView *topView;//

@property (nonatomic, strong) LxmYearMonthPickerView *dataPicker;

@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic, strong) NSString *selectTime;

@property (nonatomic, assign) NSInteger count;

@end
@implementation LxmYeJiTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubviews];
        [self setConstrains];
        self.count = 0;
    }
    return self;
}


- (void)initSubviews {
    [self addSubview:self.bgTopView];
    [self addSubview:self.topView];
    [self.topView addSubview:self.monthView];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.centerButton];
    [self.topView addSubview:self.rightButton];
}

- (void)setConstrains {
    [self.bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.topView);
        make.height.equalTo(@40);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthView.mas_bottom);
        make.leading.bottom.equalTo(self.topView);
        make.trailing.equalTo(self.centerButton.mas_leading);
        make.width.equalTo(self.centerButton);
    }];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthView.mas_bottom);
        make.bottom.equalTo(self.topView);
        make.trailing.equalTo(self.rightButton.mas_leading);
        make.width.equalTo(self.rightButton);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthView.mas_bottom);
        make.trailing.bottom.equalTo(self.topView);
        make.leading.equalTo(self.centerButton.mas_trailing);
        make.width.equalTo(self.leftButton);
    }];
}

- (UIView *)bgTopView {
    if (!_bgTopView) {
        _bgTopView = [UIView new];
        _bgTopView.backgroundColor = [UIColor whiteColor];
        _bgTopView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bgTopView.layer.shadowRadius = 5;
        _bgTopView.layer.shadowOpacity = 0.5;
        _bgTopView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bgTopView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.whiteColor;
        _topView.layer.cornerRadius = 5;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (LxmYeJiTopMonthView *)monthView {
    if (!_monthView) {
        _monthView = [[LxmYeJiTopMonthView alloc] init];
        [_monthView addTarget:self action:@selector(calendarClick) forControlEvents:UIControlEventTouchUpInside];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        self.selectTime = [dateFormatter stringFromDate:[NSDate date]];
        _monthView.titleLabel.text = self.selectTime;
    }
    return _monthView;
}

- (LxmYeJiTopButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[LxmYeJiTopButton alloc] init];
        _leftButton.textLabel.text = @"本月销售(元)";
    }
    return _leftButton;
}

- (LxmYeJiTopButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[LxmYeJiTopButton alloc] init];
        _centerButton.textLabel.text = @"本月进货(元)";
    }
    return _centerButton;
}

- (LxmYeJiTopButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[LxmYeJiTopButton alloc] init];
        _rightButton.textLabel.text = @"本月利润(元)";
    }
    return _rightButton;
}

- (LxmYearMonthPickerView *)dataPicker {
    if (!_dataPicker) {
        _dataPicker = [[LxmYearMonthPickerView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        WeakObj(self);
        _dataPicker.sureBlock = ^(NSString *year, NSString *month) {
            selfWeak.selectTime = [NSString stringWithFormat:@"%@-%@",year,month];
            selfWeak.monthView.titleLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
            if (selfWeak.selectYearAndMonth) {
                selfWeak.selectYearAndMonth(selfWeak.selectTime);
            }
        };
    }
    return _dataPicker;
}

- (void)calendarClick {
    self.count ++;
    [self.dataPicker show];
}

/**
 我的业绩-汇总
 */
- (void)setModel:(LxmMyYeJiModel *)model {
    _model = model;
    _leftButton.moneyLabel.text = _model.monthSaleMoney;
    _centerButton.moneyLabel.text = _model.monthSaleIn;
    _rightButton.moneyLabel.text = _model.monthSaleLi;
}

@end

