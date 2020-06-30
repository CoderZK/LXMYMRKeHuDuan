//
//  LxmQianBaoMessageVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmQianBaoMessageVC.h"
#import "LxmWebViewController.h"
#import "LxmQianBaoVC.h"
#import "LxmJieDanMyPublishDetailVC.h"

#import "LxmTouSuDetailVC.h"
#import "LxmSuCaiTabBarVC.h"
#import "LxmHongBaoAlertView.h"

#import "LxmJieDanMyAcceptDetailVC.h"

#import "LxmJieDanListViewController.h"

#import "LxmSeeOtherInfoVC.h"

#import "LxmBuHuoDetailVC.h"

#import "LxmOrderDetailVC.h"

#import "LxmMyBaoZhengJinVC.h"

@interface LxmQianBaoMessageVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMsgModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;


@end

@implementation LxmQianBaoMessageVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self setNavTitle];
    
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
}

- (void)setNavTitle {
    switch (self.infoType.intValue) {
        case 1:
            self.navigationItem.title = @"系统通知";
            break;
        case 2:
            self.navigationItem.title = @"代理变动";
            break;
        case 3:
            self.navigationItem.title = @"钱包消息";
            break;
        case 4:
            self.navigationItem.title = @"接单消息";
            break;
        case 6:
            self.navigationItem.title = @"投诉消息";
            break;
        case 7:
            self.navigationItem.title = @"素材消息";
            break;
        default:
            break;
    }
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmQianBaoMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmQianBaoMessageCell"];
    if (!cell) {
        cell = [[LxmQianBaoMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmQianBaoMessageCell"];
    }
    cell.msgModel = self.dataArr[indexPath.section];
    WeakObj(self);
    cell.hongbaoxiaoxiBlock = ^(LxmMsgModel *msgModel) {
        [selfWeak hongBaoClik:msgModel];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArr[indexPath.section].cellH1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMsgModel *model = self.dataArr[indexPath.section];
    [self pageTo:model];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:shop_notice_list parameters:@{@"token":SESSION_TOKEN,@"infoType": self.infoType, @"pageNum" : @(self.page)} returnClass:LxmMsgRootModel.class success:^(NSURLSessionDataTask *task, LxmMsgRootModel *responseObject) {
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
 是否已读

 @param model 1-未读，2-已读
 */
- (void)readorno:(LxmMsgModel *)model isChai:(BOOL)isChai view:(LxmHongBaoAlertView *)view {
    if (model.read_status.intValue == 1) {
        [SVProgressHUD show];
        WeakObj(self);
        [LxmNetworking networkingPOST:look_notice parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                if (isChai) {
                    [selfWeak loadMyUserInfoWithOkBlock:nil];
                    NSString *str = @"";
                    if ([responseObject[@"result"] isKindOfClass:NSDictionary.class]) {
                        str = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]];
                    }
                    [view setConstrains:YES money:str];
                    
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"已阅读!"];
                }
                model.read_status = @"2";
                [selfWeak.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }

}

/**
 已读消息 界面跳转

 @param model 1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
 */
- (void)pageTo:(LxmMsgModel *)model {
    WeakObj(self);
    NSInteger status = model.second_type.integerValue;
    if (status == 41) {//42-进我发布的订单详情
        LxmJieDanListModel *m = [LxmJieDanListModel new];
        m.id = model.info_id;
        LxmJieDanMyPublishDetailVC *vc = [[LxmJieDanMyPublishDetailVC alloc] init];
        vc.model = m;
        vc.readBlock = ^{
            [selfWeak readorno:model isChai:NO view:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (status == 42) {//42-进我接的订单详情
        LxmJieDanListModel *m = [LxmJieDanListModel new];
        m.id = model.info_id;
        LxmJieDanMyAcceptDetailVC *vc = [[LxmJieDanMyAcceptDetailVC alloc] init];
        vc.model = m;
        vc.readBlock = ^{
            [selfWeak readorno:model isChai:NO view:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (status == 43) {//43-有可接订单，进接单大厅列表
        LxmJieDanListViewController *vc = [[LxmJieDanListViewController alloc] init];
        vc.navigationItem.title = @"接单平台";
        vc.readBlock = ^{
            [selfWeak readorno:model isChai:NO view:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    switch (model.info_type.intValue) {
        case 1: {//系统消息
            if (model.info_url.isValid) {
                LxmWebViewController *vc = [[LxmWebViewController alloc] init];
                vc.navigationItem.title = @"系统消息";
                vc.readBlock = ^{
                    [selfWeak readorno:model isChai:NO view:nil];
                };
                vc.loadUrl = [NSURL URLWithString:model.info_url];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2: {//2-代理变动
            LxmMyTeamListModel *m = [LxmMyTeamListModel new];
            m.id = model.info_id;
            LxmSeeOtherInfoVC *vc = [[LxmSeeOtherInfoVC alloc] init];
            vc.model = m;
            vc.readBlock = ^{
                [selfWeak readorno:model isChai:NO view:nil];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {//3-钱包消息
            if (model.second_type.intValue == 38) {//跳转补货订单详情
                LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
                vc.orderID = model.info_id;
                vc.readBlock = ^{
                    [selfWeak readorno:model isChai:NO view:nil];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else if (model.second_type.intValue == 39) {//跳转购进订单详情
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.iscaiGouandXiaoshou = YES;
                vc.orderID = model.info_id;
                vc.readBlock = ^{
                    [selfWeak readorno:model isChai:NO view:nil];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else if (model.second_type.intValue == 40) {//保证金退回到余额
                LxmMyBaoZhengJinVC *vc = [[LxmMyBaoZhengJinVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                vc.readBlock = ^{
                    [selfWeak readorno:model isChai:NO view:nil];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                LxmQianBaoVC *vc = [[LxmQianBaoVC alloc] init];
                vc.readBlock = ^{
                    [selfWeak readorno:model isChai:NO view:nil];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 6: {//6-投诉消息
            LxmTouSuDetailVC *vc = [[LxmTouSuDetailVC alloc] init];
            vc.ID = model.info_id;
            vc.readBlock = ^{
                [selfWeak readorno:model isChai:NO view:nil];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7: {//7-素材消息
            if (model.read_status.intValue == 2) {
                LxmSuCaiTabBarVC *vc = [[LxmSuCaiTabBarVC alloc] init];
                vc.navigationItem.title = @"分类";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 红包消息
 */
- (void)hongBaoClik:(LxmMsgModel *)msgModel {
    if (msgModel.info_type.integerValue == 7 && msgModel.read_status.intValue == 2) {
        LxmSuCaiTabBarVC *vc = [[LxmSuCaiTabBarVC alloc] init];
        vc.navigationItem.title = @"分类";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    } else {
        //先拆红包 再读消息
        LxmHongBaoAlertView *alerView = [[LxmHongBaoAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        WeakObj(self);
        alerView.chaiHongBaoBlock = ^(LxmHongBaoAlertView * _Nonnull view) {
            [selfWeak readorno:msgModel isChai:YES view:view];
        };
        [alerView show];
    }
}


@end


@interface LxmQianBaoMessageButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;

@end
@implementation LxmQianBaoMessageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"请注意"];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"查收" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName:MainColor}];
        [att appendAttributedString:str];
        self.textLabel.attributedText = att;
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel;
}

@end




@interface LxmQianBaoMessageCell ()

@property (nonatomic, strong) UIView *shaowView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *redView;//红点

@property (nonatomic, strong) UILabel *detailLabel;//详细信息

@property (nonatomic, strong) LxmQianBaoMessageButton *seeButton;//收到红包 请及时查看

@end
@implementation LxmQianBaoMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.shaowView];
    [self addSubview:self.bgView];
    [self addSubview:self.timeLabel];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.seeButton];
    [self.bgView addSubview:self.redView];
    [self.bgView addSubview:self.detailLabel];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.shaowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(45);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.bgView).offset(15);
        make.trailing.equalTo(self.redView.mas_leading);
    }];
    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.trailing.equalTo(self.redView.mas_leading).offset(-5);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(15);
        make.width.height.equalTo(@6);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.bgView).offset(15);
        make.trailing.equalTo(self.bgView).offset(-15);
    }];
}

- (UIView *)shaowView {
    if (!_shaowView) {
        _shaowView = [UIView new];
        _shaowView.backgroundColor = [UIColor whiteColor];
        _shaowView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _shaowView.layer.shadowRadius = 5;
        _shaowView.layer.shadowOpacity = 0.5;
        _shaowView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _shaowView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = CharacterGrayColor;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = MainColor;
        _redView.layer.cornerRadius = 3;
        _redView.clipsToBounds = YES;
    }
    return _redView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (LxmQianBaoMessageButton *)seeButton {
    if (!_seeButton) {
        _seeButton = [LxmQianBaoMessageButton new];
        [_seeButton addTarget:self action:@selector(seeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeButton;
}


- (void)setMsgModel:(LxmMsgModel *)msgModel {
    _msgModel = msgModel;
    if (_msgModel.create_time.length > 10) {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[[_msgModel.create_time substringToIndex:10] getIntervalToZHXTime]];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[_msgModel.create_time getIntervalToZHXTime]];
    }
    self.titleLabel.text = _msgModel.title;
    self.detailLabel.text = _msgModel.des;
    self.redView.hidden = _msgModel.read_status.intValue == 2;
    self.seeButton.hidden = _msgModel.info_type.integerValue != 7;
    if (_msgModel.info_type.integerValue == 7 && _msgModel.read_status.intValue == 2) {
        self.seeButton.hidden = YES;
    }
}

- (void)seeClick {
    if (self.msgModel.info_type.integerValue == 7) {
        if (self.hongbaoxiaoxiBlock) {
            self.hongbaoxiaoxiBlock(self.msgModel);
        }
    }
}


@end
