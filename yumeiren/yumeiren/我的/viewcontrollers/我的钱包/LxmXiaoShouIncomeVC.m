//
//  LxmXiaoShouIncomeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmXiaoShouIncomeVC.h"

@interface LxmXiaoShouIncomeVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJiYiRecordModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmXiaoShouIncomeVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂无销售收入哦~";
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
    self.navigationItem.title = @"销售收入";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
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
    LxmXiaoShouIncomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmXiaoShouIncomeCell"];
    if (!cell) {
        cell = [[LxmXiaoShouIncomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmXiaoShouIncomeCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        dict[@"type"] = @2;
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


@interface LxmXiaoShouIncomeCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *orderNumLabel;//订单编号

@property (nonatomic, strong) UILabel *stateLabel;//状态

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmXiaoShouIncomeCell

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
    [self addSubview:self.orderNumLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setContrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.height.equalTo(@40);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.iconImgView);
        make.trailing.equalTo(self.moneyLabel.mas_leading);
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.orderNumLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.orderNumLabel.mas_bottom).offset(5);
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

- (UILabel *)orderNumLabel {
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
        _orderNumLabel.font = [UIFont systemFontOfSize:10];
        _orderNumLabel.textColor = CharacterDarkColor;
    }
    return _orderNumLabel;
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
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",_model.order_code];
    if (_model.create_time.length > 10) {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[[_model.create_time substringToIndex:10] getIntervalToZHXTime]];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[_model.create_time getIntervalToZHXTime]];
    }
    switch (_model.info_type.intValue) {
        case 1: {
            self.titleLabel.text = @"批发采购";
            self.iconImgView.image = [UIImage imageNamed:@"pfcg_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
            if (_model.status.intValue == 11) {
                //批发采购结算中  -
                self.stateLabel.text = @"结算中";
            } else if (_model.status.intValue == 12) {
                //批发采购已完成 -
                self.stateLabel.text = @"已完成";
            }
        }
            break;
        case 2: {
            self.titleLabel.text = @"批发销售";
            self.iconImgView.image = [UIImage imageNamed:@"pfxs_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"已完成";
        }
            break;
        case 3: {
            self.titleLabel.text = @"充值";
            self.iconImgView.image = [UIImage imageNamed:@"cz_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"已完成";
        }
            break;
        case 4: {
            self.titleLabel.text = @"转账";
            self.iconImgView.image = [UIImage imageNamed:@"zz_1"];
            if (_model.status.intValue == 41) {
                //转账-转出  -
                self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"转出中";
            } else if (_model.status.intValue == 42) {
                //转账-转入  +
                self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"转入中";
            }
        }
            break;
        case 5: {
            self.titleLabel.text = @"红包";
            self.iconImgView.image = [UIImage imageNamed:@"wdhb_1"];
            if (_model.status.intValue == 52) {
                //红包转入 -
                self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"转出中";
            } else if (_model.status.intValue == 51) {
                //红包转入 +
                self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"转入中";
            }
            
        }
            break;
        case 6: {
            self.titleLabel.text = @"接单收入";
            self.iconImgView.image = [UIImage imageNamed:@"jdsr_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"已完成";
        }
            break;
        case 7: {
            self.titleLabel.text = @"接单退回";
            self.iconImgView.image = [UIImage imageNamed:@"jdth_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"已完成";
        }
            break;
        case 8: {
            self.titleLabel.text = @"公司返款";
            self.iconImgView.image = [UIImage imageNamed:@"gsfk_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"已完成";
        }
            break;
        case 9: {
            self.titleLabel.text = @"保证金";
            self.iconImgView.image = [UIImage imageNamed:@"bzj_1"];
            if (_model.status.intValue == 92) {
                //92：保证金减-
                self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"减少";
            } else if (_model.status.intValue == 91) {
                //91:保证金加 +
                self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
                self.stateLabel.text = @"增加";
            }
        }
            break;
        case 10: {
            self.titleLabel.text = @"后台充值";
            self.iconImgView.image = [UIImage imageNamed:@"htcz_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"增加";
        }
            break;
        case 11: {
            self.titleLabel.text = @"提现";
            self.iconImgView.image = [UIImage imageNamed:@"htkk_1"];
            
            if (_model.status.intValue == 92) {
                //提现成功 -
                self.stateLabel.text = @"提现成功";
                self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
            } else if (_model.status.intValue == 91) {
                //提现失败-
                self.stateLabel.text = @"提现失败";
                self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",_model.info_money.doubleValue];
            }
        }
            break;
        case 12: {
            self.titleLabel.text = @"后台扣款";
            self.iconImgView.image = [UIImage imageNamed:@"htkk_1"];
            self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",_model.info_money.doubleValue];
            self.stateLabel.text = @"扣款已完成";
        }
            break;
            
            
        default:
            break;
    }
}


@end



