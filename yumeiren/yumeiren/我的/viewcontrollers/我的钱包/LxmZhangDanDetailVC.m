//
//  LxmZhangDanDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmZhangDanDetailVC.h"

@interface LxmZhangDanDetailHeaderView : UIView

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end
@implementation LxmZhangDanDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.textLabel];
    [self addSubview:self.moneyLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textLabel.mas_top).offset(-15);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@35);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"cz_1"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"充值";
    }
    return _textLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:25];
        _moneyLabel.textColor = CharacterDarkColor;
        _moneyLabel.text = @"+3000";
    }
    return _moneyLabel;
}

@end

@interface LxmZhangDanDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmZhangDanDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
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
    [self addSubview:self.detailLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = CharacterDarkColor;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end



@interface LxmZhangDanDetailVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) LxmZhangDanDetailVC_type type;

@property (nonatomic, strong) LxmZhangDanDetailHeaderView *headerView;

@property (nonatomic, strong) LxmZhangDanDetailModel *detailModel;

@end

@implementation LxmZhangDanDetailVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmZhangDanDetailVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (LxmZhangDanDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmZhangDanDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 260)];
    }
    return _headerView;
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
    self.navigationItem.title = @"账单详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.tableView.tableHeaderView = self.headerView;
    switch (self.model.info_type.intValue) {
        case 3: {//充值 +
            self.headerView.iconImgView.image = [UIImage imageNamed:@"cz_1"];
            self.headerView.textLabel.text = @"充值";
            [self setMoney:YES];
        }
            break;
        case 4: {//转账 -
            self.headerView.iconImgView.image = [UIImage imageNamed:@"zz_1"];
            self.headerView.textLabel.text = @"转账";
            if (self.model.status.intValue == 41) {
                //转账-转出  -
                [self setMoney:NO];
            } else if (self.model.status.intValue == 42) {
                //转账-转入  +
                [self setMoney:YES];
            }
        }
            break;
        case 11: { //提现
            self.headerView.iconImgView.image = [UIImage imageNamed:@"htkk_1"];
            self.headerView.textLabel.text = @"提现";
            if (self.model.status.intValue == 111) {
                //提现中 -
                [self setMoney:NO];
            } else if (self.model.status.intValue == 112) {
                //提现成功-
                [self setMoney:NO];
            } else if (self.model.status.intValue == 113) {
                //提现失败 +
                [self setMoney:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self loadDetailData];
}

/**
 赋值moneylabel

 @param isadd + -
 */
- (void)setMoney:(BOOL)isadd {
    NSInteger d = self.model.info_money.integerValue;
    CGFloat f = self.model.info_money.doubleValue;
    if (d == f) {
        self.headerView.moneyLabel.text = [NSString stringWithFormat:@"%@ %ld", (isadd ? @"+" : @"-"),d];
    } else {
        self.headerView.moneyLabel.text = [NSString stringWithFormat:@"%@ %.2f", (isadd ? @"+" : @"-"),f];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmZhangDanDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmZhangDanDetailCell"];
    if (!cell) {
        cell = [[LxmZhangDanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmZhangDanDetailCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"创建时间";
        NSString *time = @"";
        if (self.type == LxmZhangDanDetailVC_type_chongzhi) {
            time = self.detailModel.create_time;
            
        } else if (self.type == LxmZhangDanDetailVC_type_tixian) {
            time = self.detailModel.create_time;
        } else if (self.type == LxmZhangDanDetailVC_type_zhuanzhang) {
           time = self.detailModel.time;
        }
        if (time.length > 10) {
            cell.detailLabel.text = [[time substringToIndex:10] getIntervalToZHXLongTime];
        } else {
            cell.titleLabel.text = [time getIntervalToZHXLongTime];
        }
        
    } else if (indexPath.row == 1) {
        if (self.type == LxmZhangDanDetailVC_type_chongzhi) {
            cell.titleLabel.text = @"支付方式";
            cell.detailLabel.text = self.detailModel.pay_type.intValue == 1 ? @"支付宝" : @"微信";
        } else if (self.type == LxmZhangDanDetailVC_type_tixian) {
            cell.titleLabel.text = @"状态";
            cell.detailLabel.text = self.detailModel.status.intValue == 1 ? @"审核中" : self.detailModel.status.intValue == 2 ? @"审核成功" : @"审核失败";
        } else if (self.type == LxmZhangDanDetailVC_type_zhuanzhang) {
            /** 1-转出，2：转入 */
            if (self.detailModel.type.intValue == 1) {
                cell.titleLabel.text = @"对方账户";
                cell.detailLabel.text = self.detailModel.toName;
            } else {
                cell.titleLabel.text = @"对方账户";
                cell.detailLabel.text = self.detailModel.fromName;
            }
        }
    } else {
        cell.titleLabel.text = @"第三方订单号";
        cell.detailLabel.text = self.detailModel.third_code;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == LxmZhangDanDetailVC_type_chongzhi) {
        return 50;
    } else  {
        if (indexPath.row == 2) {
            return 0.01;
        }
        return 50;
    }
}

/**
 详情
 */
- (void)loadDetailData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *url = nil;
    dict[@"token"] = SESSION_TOKEN;
    if (self.type == LxmZhangDanDetailVC_type_chongzhi) {
        url = money_in_detail;
        dict[@"trialId"] = self.model.info_id;
    } else if (self.type == LxmZhangDanDetailVC_type_tixian) {
        url = money_out_detail;
        dict[@"trialId"] = self.model.info_id;
    } else if (self.type == LxmZhangDanDetailVC_type_zhuanzhang) {
        url = give_money_detail;
        dict[@"trialId"] = self.model.id;
    }
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:url parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.detailModel = [LxmZhangDanDetailModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
