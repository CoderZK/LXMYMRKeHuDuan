//
//  LxmJiaoYIRecordVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJiaoYIRecordVC.h"

#import "LxmZhangDanDetailVC.h"

#import "LxmOrderDetailVC.h"
#import "LxmMyHongBaoVC.h"

#import "LxmJieDanMyPublishDetailVC.h"

#import "LxmJieDanMyAcceptDetailVC.h"

#import "LxmBuHuoDetailVC.h"

@interface LxmJiaoYIRecordVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJiYiRecordModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmJiaoYIRecordVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂无交易记录哦~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
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
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJiaoYIRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJiaoYIRecordCell"];
    if (!cell) {
        cell = [[LxmJiaoYIRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJiaoYIRecordCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmJiYiRecordModel *model = self.dataArr[indexPath.row];
    switch (model.info_type.intValue) {
        case 1: {//批发采购
               LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
               vc.iscaiGouandXiaoshou = YES;
               vc.orderID = model.info_id;
               [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {//批发销售
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.iscaiGouandXiaoshou = YES;
                vc.orderID = model.info_id;
                [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
        }
                break;
        case 3: {//充值 +
            LxmZhangDanDetailVC *vc = [[LxmZhangDanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmZhangDanDetailVC_type_chongzhi];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {//转账 -
            LxmZhangDanDetailVC *vc = [[LxmZhangDanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmZhangDanDetailVC_type_zhuanzhang];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {//红包
            LxmMyHongBaoVC *vc = [[LxmMyHongBaoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {//我接受的
            LxmJieDanListModel *m = [LxmJieDanListModel new];
            LxmJieDanMyAcceptDetailVC *vc = [[LxmJieDanMyAcceptDetailVC alloc] init];
            m.id = model.info_id;
            vc.model = m;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7: {//我发的单
            LxmJieDanListModel *m = [LxmJieDanListModel new];
            m.id = model.info_id;
            LxmJieDanMyPublishDetailVC *vc = [[LxmJieDanMyPublishDetailVC alloc] init];
            vc.model = m;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11: { //提现
            LxmZhangDanDetailVC *vc = [[LxmZhangDanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmZhangDanDetailVC_type_tixian];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13: { //提现
            if (model.status.intValue == 131) {//跳转补货订单详情
                LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
                vc.orderID = model.info_id;
                [self.navigationController pushViewController:vc animated:YES];
            } else {//跳转购进订单详情
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.iscaiGouandXiaoshou = YES;
                vc.orderID = model.info_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        dict[@"type"] = @1;
        [LxmNetworking networkingPOST:trial_list parameters:dict returnClass:LxmJiYiRecordRootModel.class success:^(NSURLSessionDataTask *task, LxmJiYiRecordRootModel *responseObject) {
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
                self.emptyView.hidden = self.dataArr.count > 0;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}

@end


@interface LxmJiaoYIRecordCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *stateLabel;//状态

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmJiaoYIRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self initSubviews];
        [self setContrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setContrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@35);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        make.trailing.equalTo(self.moneyLabel.mas_leading);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.timeLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
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

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:10];
        _stateLabel.textColor = CharacterLightGrayColor;
    }
    return _stateLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmJiYiRecordModel *)model {
    _model = model;
    if (_model.create_time.length > 10) {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[[_model.create_time substringToIndex:10] getIntervalToZHXLongTime]];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[_model.create_time getIntervalToZHXLongTime]];
    }
    switch (_model.info_type.intValue) {
        case 1: {
            self.titleLabel.text = @"批发采购";
            self.iconImgView.image = [UIImage imageNamed:@"pfcg_1"];
            [self setMoney:NO];
            if (_model.status.intValue == 11) {
                //批发采购结算中  -
                self.stateLabel.text = @"结算中";
                self.stateLabel.textColor = MainColor;
            } else if (_model.status.intValue == 12) {
                //批发采购已完成 -
                self.stateLabel.text = @"已完成";
                self.stateLabel.textColor = CharacterGrayColor;
            }
        }
            break;
        case 2: {
            self.titleLabel.text = @"批发销售";
            self.iconImgView.image = [UIImage imageNamed:@"pfxs_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 3: {
            self.titleLabel.text = @"充值";
            self.iconImgView.image = [UIImage imageNamed:@"cz_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 4: {
            self.titleLabel.text = @"转账";
            self.iconImgView.image = [UIImage imageNamed:@"zz_1"];
            if (_model.status.intValue == 41) {
                //转账-转出  -
                [self setMoney:NO];
                self.stateLabel.text = @"转出";
                self.stateLabel.textColor = CharacterGrayColor;
            } else if (_model.status.intValue == 42) {
                //转账-转入  +
                [self setMoney:YES];
                self.stateLabel.text = @"转入";
                self.stateLabel.textColor = CharacterGrayColor;
            }
        }
            break;
        case 5: {
            self.titleLabel.text = @"红包";
            self.iconImgView.image = [UIImage imageNamed:@"wdhb_1"];
            if (_model.status.intValue == 52) {
                //红包转入 -
                [self setMoney:NO];
                self.stateLabel.text = @"转出";
                self.stateLabel.textColor = CharacterGrayColor;
            } else if (_model.status.intValue == 51) {
                //红包转入 +
                [self setMoney:YES];
                self.stateLabel.text = @"转入";
                self.stateLabel.textColor = CharacterGrayColor;
            }
            
        }
            break;
        case 6: {
            self.titleLabel.text = @"接单收入";
            self.iconImgView.image = [UIImage imageNamed:@"jdsr_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 7: {
            self.titleLabel.text = @"接单退回";
            self.iconImgView.image = [UIImage imageNamed:@"jdth_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 8: {
            self.titleLabel.text = @"公司返款";
            self.iconImgView.image = [UIImage imageNamed:@"gsfk_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 9: {
            
            self.iconImgView.image = [UIImage imageNamed:@"bzj_1"];
            if (_model.status.intValue == 92) {
                //92：保证金减-
                self.titleLabel.text = @"保证金";
                [self setMoney:NO];
                self.stateLabel.text = @"减少";
                self.stateLabel.textColor = CharacterGrayColor;
            } else if (_model.status.intValue == 91) {
                //91:保证金加 +
                self.titleLabel.text = @"保证金";
                [self setMoney:YES];
                self.stateLabel.text = @"增加";
                self.stateLabel.textColor = CharacterGrayColor;
            } else if (_model.status.intValue == 93) {
                //93:保证金退到余额 +
                self.titleLabel.text = @"保证金退到余额";
                [self setMoney:YES];
                self.stateLabel.text = @"增加";
                self.stateLabel.textColor = CharacterGrayColor;
            }
        }
            break;
        case 10: {
            self.titleLabel.text = @"后台充值";
            self.iconImgView.image = [UIImage imageNamed:@"htcz_1"];
            [self setMoney:YES];
            self.stateLabel.text = @"增加";
            self.stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 11: {
            self.titleLabel.text = @"提现";
            self.iconImgView.image = [UIImage imageNamed:@"htkk_1"];
            
            if (_model.status.intValue == 111) {
                //提现中 -
                self.stateLabel.text = @"提现中";
                self.stateLabel.textColor = MainColor;
                [self setMoney:NO];
            } else if (_model.status.intValue == 112) {
                //提现成功-
                self.stateLabel.text = @"提现成功";
                self.stateLabel.textColor = CharacterGrayColor;
                [self setMoney:NO];
            } else if (_model.status.intValue == 113) {
                //提现失败 +
                self.stateLabel.text = @"提现失败";
                self.stateLabel.textColor = CharacterGrayColor;
                [self setMoney:YES];
            }
        }
            break;
        case 12: {
            self.titleLabel.text = @"后台扣款";
            self.iconImgView.image = [UIImage imageNamed:@"htkk_1"];
            self.stateLabel.text = @"扣款已完成";
            self.stateLabel.textColor = CharacterGrayColor;
            [self setMoney:NO];
        }
            break;
        case 13: {
            self.titleLabel.text = @"订单超时退回";
            self.iconImgView.image = [UIImage imageNamed:@"htcz_1"];
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = CharacterGrayColor;
            [self setMoney:YES];
        }
            break;
            
        default:
            break;
    }
}


- (void)setMoney:(BOOL)isadd {
    NSInteger d = self.model.info_money.integerValue;
    CGFloat f = self.model.info_money.doubleValue;
    if (d == f) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@ %ld", (isadd ? @"+" : @"-"),d];
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@ %.2f", (isadd ? @"+" : @"-"),f];
    }
}


@end
