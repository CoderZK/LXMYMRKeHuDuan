//
//  LxmDingDanMessageVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDingDanMessageVC.h"
#import "LxmOrderDetailVC.h"
#import "LxmBuHuoDetailVC.h"

@interface LxmDingDanMessageVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMsgModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmDingDanMessageVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单消息";
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
    LxmDingDanMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmDingDanMessageCell"];
    if (!cell) {
        cell = [[LxmDingDanMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmDingDanMessageCell"];
    }
    cell.msgModel = self.dataArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArr[indexPath.section].cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

/**
 跳转订单详情
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMsgModel *model = self.dataArr[indexPath.section];
    NSInteger index = model.second_type.intValue;
    if (index == 51 || index == 52) {//批量购进 批量销售
        LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
        vc.isHiddenBottom = YES;
        vc.iscaiGouandXiaoshou = YES;
        WeakObj(self);
        vc.readBlock = ^{
            [selfWeak readorno:model];
        };
        vc.orderID = self.dataArr[indexPath.section].info_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 53) {//补货单相关
        LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
        vc.isHiddenBottom = YES;
        vc.orderID = self.dataArr[indexPath.section].info_id;
        WeakObj(self);
        vc.readBlock = ^{
            [selfWeak readorno:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)readorno:(LxmMsgModel *)model {
    if (model.read_status.intValue == 1) {
        [SVProgressHUD show];
        WeakObj(self);
        [LxmNetworking networkingPOST:look_notice parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           [SVProgressHUD dismiss];
           if ([responseObject[@"key"] integerValue] == 1000) {
               [SVProgressHUD showSuccessWithStatus:@"已阅读!"];
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
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:shop_notice_list parameters:@{@"token":SESSION_TOKEN,@"infoType": @5,@"pageNum" : @(self.page)} returnClass:LxmMsgRootModel.class success:^(NSURLSessionDataTask *task, LxmMsgRootModel *responseObject) {
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


@end

@interface LxmDingDanMessageCell ()

@property (nonatomic, strong) UIView *shaowView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *redView;//红点

@property (nonatomic, strong) UILabel *detailLabel;//详细信息

@property (nonatomic, strong) UIButton *seeButton;//查看订单

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *seeOrderLabel;//查看订单

@end

@implementation LxmDingDanMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
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
    [self.bgView addSubview:self.redView];
    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.seeButton];
    [self.seeButton addSubview:self.lineView];
    [self.seeButton addSubview:self.seeOrderLabel];
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
    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.bgView);
        make.height.equalTo(@40);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.seeButton).offset(15);
        make.trailing.equalTo(self.seeButton).offset(-15);
        make.top.equalTo(self.seeButton);
        make.height.equalTo(@1);
    }];
    [self.seeOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.seeButton).offset(15);
        make.centerY.equalTo(self.seeButton);
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
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = MainColor;
        _redView.layer.cornerRadius = 3;
        _redView.layer.masksToBounds = YES;
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

- (UIButton *)seeButton {
    if (!_seeButton) {
        _seeButton = [UIButton new];
    }
    return _seeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)seeOrderLabel {
    if (!_seeOrderLabel) {
        _seeOrderLabel = [UILabel new];
        _seeOrderLabel.font = [UIFont systemFontOfSize:13];
        _seeOrderLabel.textColor = CharacterGrayColor;
        _seeOrderLabel.text = @"查看订单";
    }
    return _seeOrderLabel;
}

- (void)setData {
    self.timeLabel.text = @"2018-10-23 10:22";
    self.titleLabel.text = @"余额增加";
    self.detailLabel.text = @"您的账户收入金额2409元,收入类型:批发销售,请注意查看余额变动";
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
}

@end
