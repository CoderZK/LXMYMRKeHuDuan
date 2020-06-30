//
//  LxmKuCunJiLuVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmKuCunJiLuVC.h"

@interface LxmKuCunJiLuCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *numLabel;//数量

@property (nonatomic, strong) UILabel *orderlabel;//订单编号

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmShopCenterModel *model;

@end
@implementation LxmKuCunJiLuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.orderlabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@60);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.greaterThanOrEqualTo(self.numLabel.mas_leading);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.orderlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderlabel.mas_bottom).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont boldSystemFontOfSize:18];
        _numLabel.textColor = CharacterDarkColor;
    }
    return _numLabel;
}

- (UILabel *)orderlabel {
    if (!_orderlabel) {
        _orderlabel = [[UILabel alloc] init];
        _orderlabel.font = [UIFont boldSystemFontOfSize:15];
        _orderlabel.textColor = CharacterDarkColor;
    }
    return _orderlabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = CharacterLightGrayColor;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setData {
    
    _iconImgView.layer.cornerRadius = 30;
    _iconImgView.layer.masksToBounds = YES;
    _titleLabel.text = @"采购入库";
    _numLabel.text = @"+2";
    _orderlabel.text = @"订单编号:BB20190620223439255";
    _timeLabel.text = @"2019-06-20 17:30:38  库存: 28";
}

- (void)setModel:(LxmShopCenterModel *)model {
    _model = model;
    
    _orderlabel.text = [NSString stringWithFormat:@"订单编号:%@",_model.order_code];
   
    if (_model.create_time.length > 10) {
         _timeLabel.text = [NSString stringWithFormat:@"%@  库存: %@",[[_model.create_time substringToIndex:10] getIntervalToZHXTime], _model.good_num];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@  库存: %@",[_model.create_time getIntervalToZHXTime], _model.good_num];
    }
    switch (_model.info_type.integerValue) {
        case 1: {
            _iconImgView.image = [UIImage imageNamed:@"cgrk"];
            _titleLabel.text = @"采购入库";
            _numLabel.text = [NSString stringWithFormat:@"+%@",_model.num];
        }
            break;
        case 2: {
            _iconImgView.image = [UIImage imageNamed:@"fhck"];
            _titleLabel.text = @"销售出库";
            _numLabel.text = [NSString stringWithFormat:@"-%@",_model.num];
        }
            break;
        case 3: {
            _iconImgView.image = [UIImage imageNamed:@"fhck"];
            _titleLabel.text = @"发货出库";
            _numLabel.text = [NSString stringWithFormat:@"-%@",_model.num];
        }
            break;
        case 4: {
            _iconImgView.image = [UIImage imageNamed:@"cgrk"];
            _titleLabel.text = @"后台入库";
            _numLabel.text = [NSString stringWithFormat:@"+%@",_model.num];
        }
            break;
        case 5: {
            _iconImgView.image = [UIImage imageNamed:@"fhck"];
            _titleLabel.text = @"后台扣除";
            _numLabel.text = [NSString stringWithFormat:@"-%@",_model.num];
        }
            break;
            
        default:
            break;
    }
}


@end

#import "LxmOrderDetailVC.h"
@interface LxmKuCunJiLuVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmKuCunJiLuVC
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"库存记录";
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmKuCunJiLuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmKuCunJiLuCell"];
    if (!cell) {
        cell = [[LxmKuCunJiLuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmKuCunJiLuCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger info = self.dataArr[indexPath.row].info_type.integerValue;
    if (info == 1 || info == 2 || info == 3) {
        LxmOrderDetailVC *orderVC = [[LxmOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        orderVC.orderID = self.dataArr[indexPath.row].order_id;
        [self.navigationController pushViewController:orderVC animated:YES];
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
        if (self.goodID) {
            dict[@"goodId"] = self.goodID;
        }
        
        [LxmNetworking networkingPOST:stock_change_list parameters:dict returnClass:LxmShopCenterRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterRootModel *responseObject) {
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

