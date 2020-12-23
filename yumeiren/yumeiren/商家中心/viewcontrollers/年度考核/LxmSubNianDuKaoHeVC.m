//
//  LxmSubNianDuKaoHeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/4/22.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmSubNianDuKaoHeVC.h"

@interface LxmSubNianDuKaoHeVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmNianDuKaoHeModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubNianDuKaoHeVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您暂时没有团队业绩";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSubNianDuKaoHeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubNianDuKaoHeCell"];
    if (!cell) {
        cell = [[LxmSubNianDuKaoHeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubNianDuKaoHeCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    headerView.contentView.backgroundColor = BGGrayColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:year_group_list parameters:@{@"token":SESSION_TOKEN, @"type" : self.type, @"pageNum" : @(self.page)} returnClass:LxmNianDuKaoHeListRootModel.class success:^(NSURLSessionDataTask *task, LxmNianDuKaoHeListRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.emptyView.hidden = self.dataArr.count > 0;
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




@end


//
@interface LxmSubNianDuKaoHeCell ()

@property (nonatomic, strong) UIImageView *headerImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *roleLabel;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIImageView *jinDuImgView;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmSubNianDuKaoHeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.roleLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.bgImgView];
    [self addSubview:self.jinDuImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
}

- (void)setConstrains {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.size.equalTo(@40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.top.equalTo(self.headerImgView);
    }];
    [self.roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(8);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.roleLabel);
    }];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@15);
    }];
    [self.jinDuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self.bgImgView);
        make.leading.equalTo(self.bgImgView).offset(ScreenW *0.5);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.jinDuImgView);
        make.centerY.equalTo(self.jinDuImgView);
        make.size.equalTo(@21);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(10);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 20;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UILabel *)roleLabel {
    if (!_roleLabel) {
        _roleLabel = [UILabel new];
        _roleLabel.font = [UIFont systemFontOfSize:13];
        _roleLabel.layer.borderColor = MainColor.CGColor;
        _roleLabel.layer.borderWidth = 0.5;
        _roleLabel.layer.cornerRadius = 3;
        _roleLabel.layer.masksToBounds = YES;
        _roleLabel.textColor = MainColor;
    }
    return _roleLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textColor = MainColor;
    }
    return _stateLabel;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"progress"];
        _bgImgView.layer.cornerRadius = 7.5;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}


- (UIImageView *)jinDuImgView {
    if (!_jinDuImgView) {
        _jinDuImgView = [UIImageView new];
        _jinDuImgView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _jinDuImgView.layer.cornerRadius = 7.5;
        _jinDuImgView.layer.masksToBounds = YES;
    }
    return _jinDuImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = CharacterDarkColor;
        _moneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = CharacterGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmNianDuKaoHeModel *)model {
    _model = model;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.userHead] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = _model.username;
    if (_model.yearMoney.doubleValue != 0) {
        if (_model.in_money.doubleValue > _model.yearMoney.doubleValue) {
            [self.jinDuImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.top.bottom.equalTo(self.bgImgView);
                make.leading.equalTo(self.bgImgView.mas_trailing);
            }];
        } else {
            double bilv = 1 - _model.in_money.doubleValue / _model.yearMoney.doubleValue;
            CGFloat w = (ScreenW - 80) * bilv;
            [self.jinDuImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.top.bottom.equalTo(self.bgImgView);
                make.leading.equalTo(self.bgImgView.mas_trailing).offset(-w);
            }];
        }
    }
    
    if (!_model.in_money) {
        _moneyLabel.text = @" 金额 0 ";
    } else {
        _moneyLabel.text = [NSString stringWithFormat:@" 金额 %@ ", _model.in_money];
    }
    
    NSDate * begin_date = [NSDate dateWithTimeIntervalSince1970:_model.begin_day.doubleValue/1000];
    NSDate * end_date = [NSDate dateWithTimeIntervalSince1970:_model.end_day.doubleValue/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日"];
    NSString * beginStr = [df stringFromDate:begin_date];
    NSString * endStr = [df stringFromDate:end_date];
    _timeLabel.text = [NSString stringWithFormat:@"年度考核计算周期: %@-%@", beginStr, endStr];
    _stateLabel.text = _model.in_money.doubleValue >= _model.yearMoney.doubleValue ? @"已完成" : @"未完成";
    _iconImgView.image = [UIImage imageNamed:_model.in_money.doubleValue >= _model.yearMoney.doubleValue ? @"jiesuo_y" : @"jiesuo_n"];
   
    if ([_model.roleType isEqualToString:@"-0.5"]) {
        _roleLabel.text = @"   小红包系列-vip会员   ";
    } else if ([_model.roleType isEqualToString:@"-0.4"]) {
        _roleLabel.text = @"   小红包系列-高级会员   ";
    } else if ([_model.roleType isEqualToString:@"-0.3"]) {
        _roleLabel.text = @"   小红包系列-荣誉会员   ";
    } else if ([_model.roleType isEqualToString:@"1.1"]) {
        _roleLabel.text = @"   小红包系列-市服务商   ";
    } else if ([_model.roleType isEqualToString:@"2.1"]) {
        _roleLabel.text = @"   小红包系列-省服务商   ";
    } else if ([_model.roleType isEqualToString:@"3.1"]) {
        _roleLabel.text = @"   小红包系列-CEO   ";
    } else {
        switch (_model.roleType.intValue) {
            case -1:
                _roleLabel.text = @"   无身份   ";
                break;
            case 0:
                 _roleLabel.text = @"   vip门店   ";
                break;
            case 1:
                _roleLabel.text = @"   高级门店   ";
                break;
            case 2:
                _roleLabel.text = @"   市服务商   ";
                break;
            case 3:
                _roleLabel.text = @"   省服务商   ";
                break;
            case 4:
                _roleLabel.text = @"   CEO   ";
                break;
                
            default:
                break;
        }
    }
    
}


@end
