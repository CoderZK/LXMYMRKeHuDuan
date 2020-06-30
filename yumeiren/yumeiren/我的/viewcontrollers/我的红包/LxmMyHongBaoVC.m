//
//  LxmMyHongBaoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyHongBaoVC.h"
#import "LxmJiaJiaAlertView.h"
#import "LxmZhuanYuEVC.h"

@interface LxmMyHongBaoHeaderView : UIView

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *titleLabel;//我的红包

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIButton *zyeButton;//转余额

@end

@implementation LxmMyHongBaoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.zyeButton];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(NavigationSpace + 10);
            make.centerX.equalTo(self);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        [self.zyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self);
            make.width.equalTo(@120);
            make.height.equalTo(@35);
        }];
    }
    return self;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImgView.image = [UIImage imageNamed:@"wdqb_bg"];
    }
    return _bgImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"我的红包";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = UIColor.whiteColor;
        _moneyLabel.font = [UIFont systemFontOfSize:25];
        _moneyLabel.text = @"115.60";
    }
    return _moneyLabel;
}

- (UIButton *)zyeButton {
    if (!_zyeButton) {
        _zyeButton = [UIButton new];
        [_zyeButton setTitle:@"转余额" forState:UIControlStateNormal];
        [_zyeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _zyeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _zyeButton.layer.borderColor = UIColor.whiteColor.CGColor;
        _zyeButton.layer.borderWidth = 0.5;
        _zyeButton.layer.cornerRadius = 5;
        _zyeButton.layer.masksToBounds = YES;
    }
    return _zyeButton;
}

@end


/**
 去视图
 */

@implementation LxmMyHongBaoSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@.5);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
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

@end



@implementation LxmMyHongBaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setContrains];
        [self setData];
    }
    return self;
}
/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setContrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        make.trailing.equalTo(self.moneyLabel.mas_leading);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = CharacterLightGrayColor;
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = CharacterDarkColor;
        _moneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setData {
    self.titleLabel.text = @"收到红包";
    self.timeLabel.text = @"2018-10-23 10:22";
    self.moneyLabel.text = @"+19.98";
}

- (void)setModel:(LxmMyHongBaoModel *)model {
    _model = model;
    self.titleLabel.text = _model.infoType.intValue == 1 ? @"收到红包":@"转至余额";
    if (_model.createTime.length > 10) {
        self.timeLabel.text = [[_model.createTime substringToIndex:10] getIntervalToZHXTime];
    } else {
        self.timeLabel.text = [_model.createTime getIntervalToZHXTime];
    }
    if (_model.getMoney.doubleValue == _model.getMoney.integerValue) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%ld", (_model.infoType.intValue == 1 ? @"+" : @"-"),_model.getMoney.integerValue];
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f", (_model.infoType.intValue == 1 ? @"+" : @"-"),_model.getMoney.doubleValue];
    }
}


- (void)setBaozhengjinModel:(LxmJiYiRecordModel *)baozhengjinModel {
    _baozhengjinModel = baozhengjinModel;

    self.titleLabel.text = _baozhengjinModel.content;
    if (_baozhengjinModel.createTime.length > 10) {
        self.timeLabel.text = [[_baozhengjinModel.createTime substringToIndex:10] getIntervalToZHXTime];
    } else {
        self.timeLabel.text = [_baozhengjinModel.createTime getIntervalToZHXTime];
    }
    if (_baozhengjinModel.changeMoney.doubleValue == _baozhengjinModel.changeMoney.integerValue) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%ld", (_baozhengjinModel.infoType.intValue == 1 ? @"+" : @"-"),_baozhengjinModel.changeMoney.integerValue];
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f", (_baozhengjinModel.infoType.intValue == 1 ? @"+" : @"-"),_baozhengjinModel.changeMoney.doubleValue];
    }
}

@end


@interface LxmMyHongBaoVC ()

@property (nonatomic, strong) LxmMyHongBaoHeaderView *headerView;

@property (nonatomic, strong) UIButton *backButton;//返回按钮

@property (nonatomic, strong) UIView *navView;//自定义导航

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMyHongBaoModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmMyHongBaoVC

- (LxmMyHongBaoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmMyHongBaoHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, NavigationSpace + 200)];
        [_headerView.zyeButton addTarget:self action:@selector(zhuanyueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
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
    
    void(^redMoneyBlock)(void) = ^(void){
        CGFloat f = [LxmTool ShareTool].userModel.redBalance.doubleValue;
        NSInteger d = [LxmTool ShareTool].userModel.redBalance.integerValue;
        if (f == d) {
            self.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%ld",(long)d];
        } else {
            self.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",f];
        }
    };
    
    redMoneyBlock();
    [LxmEventBus registerEvent:@"hongbaozhuanru" block:^(id data) {
        redMoneyBlock();
    }];
    
    
}

/**
 初始化子视图
 */
- (void)initNav {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.headerView];
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, StateBarH + 44)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 12);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:leftBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navView).offset(15);
        if (kDevice_Is_iPhoneX) {
            make.bottom.equalTo(self.navView).offset(-7);
        } else {
            make.bottom.equalTo(self.navView);
        }
        make.width.height.equalTo(@40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMyHongBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyHongBaoCell"];
    if (!cell) {
        cell = [[LxmMyHongBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyHongBaoCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LxmMyHongBaoSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LxmMyHongBaoSectionHeaderView"];
    if (!headerView) {
        headerView = [[LxmMyHongBaoSectionHeaderView alloc] initWithReuseIdentifier:@"LxmMyHongBaoSectionHeaderView"];
    }
    headerView.titleLabel.text = @"红包记录";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:red_balance_list parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page),@"pageSize" : @10} returnClass:LxmMyHongBaoRootModel.class success:^(NSURLSessionDataTask *task, LxmMyHongBaoRootModel *responseObject) {
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
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}


/**
 转余额金额
 */
- (void)zhuanyueClick:(UIButton *)btn {
    LxmZhuanYuEVC *vc = [[LxmZhuanYuEVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    LxmJiaJiaAlertView *alertView = [[LxmJiaJiaAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds type:LxmJiaJiaAlertView_type_zye];
//    WeakObj(self);
//    alertView.jiajiaBlock = ^(NSString *price) {
//        
//    };
//    [alertView show];
}



@end


