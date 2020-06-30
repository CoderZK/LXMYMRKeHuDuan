//
//  LxmSeeOtherKuCunVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSeeOtherKuCunVC.h"

@interface LxmSeeOtherKuCunVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel * kucunLabel;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmSeeOtherKuCunVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
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

- (UILabel *)kucunLabel {
    if (!_kucunLabel) {
        _kucunLabel = [UILabel new];
        _kucunLabel.textColor = CharacterDarkColor;
        _kucunLabel.font = [UIFont systemFontOfSize:13];
        _kucunLabel.text = @"库存共13种商品 57件";
    }
    return _kucunLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@的库存",self.model.username];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    [self loadHuiZongData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
        [self loadHuiZongData];
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
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.kucunLabel];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(50 + TableViewBottomSpace));
    }];
    [self.kucunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(20);
        make.trailing.equalTo(self.bottomView).offset(-20);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSeeOtherKuCunCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSeeOtherKuCunCell"];
    if (!cell) {
        cell = [[LxmSeeOtherKuCunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSeeOtherKuCunCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
        dict[@"pageNum"] = @(self.page);
        if (self.model.id) {
            dict[@"userId"] = self.model.id;
        }
        
        [LxmNetworking networkingPOST:stock_list parameters:dict returnClass:LxmShopCenterRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterRootModel *responseObject) {
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
 我的仓库-汇总
 */
- (void)loadHuiZongData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:stock_count parameters:@{@"token":SESSION_TOKEN,@"userId":self.model.id} returnClass:LxmMyCangKuContentRootModel.class success:^(NSURLSessionDataTask *task, LxmMyCangKuContentRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            _kucunLabel.text = [NSString stringWithFormat:@"库存共%@种商品 %@件",responseObject.result.map.goodNum,responseObject.result.map.stockNum];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end


@interface LxmSeeOtherKuCunCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *kucunLabel;//库存

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@end
@implementation LxmSeeOtherKuCunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.kucunLabel];
    [self addSubview:self.moneyLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self.kucunLabel.mas_leading);
    }];
    [self.kucunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImgView).offset(-10);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.kucunLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)kucunLabel {
    if (!_kucunLabel) {
        _kucunLabel = [[UILabel alloc] init];
        _kucunLabel.font = [UIFont systemFontOfSize:13];
        _kucunLabel.textColor = CharacterGrayColor;
    }
    return _kucunLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (void)setModel:(LxmShopCenterModel *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _model.good_name;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_model.good_price];
    _kucunLabel.text = [NSString stringWithFormat:@"当前库存:%@",_model.good_num];
}

@end
