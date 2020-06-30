//
//  LxmMyBaoZhengJinVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyBaoZhengJinVC.h"
#import "LxmMyHongBaoVC.h"

@interface LxmMyBaoZhengJinVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJiYiRecordModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmDepositMapModel *mapModel;

@end

@implementation LxmMyBaoZhengJinVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的保证金";
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArr.count;;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmMyBaoZhengJinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyBaoZhengJinCell"];
        if (!cell) {
            cell = [[LxmMyBaoZhengJinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyBaoZhengJinCell"];
        }
        return cell;
    }
    LxmMyHongBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyHongBaoCell"];
    if (!cell) {
        cell = [[LxmMyHongBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyHongBaoCell"];
    }
    cell.baozhengjinModel = self.dataArr[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        LxmMyHongBaoSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LxmMyHongBaoSectionHeaderView"];
        if (!headerView) {
            headerView = [[LxmMyHongBaoSectionHeaderView alloc] initWithReuseIdentifier:@"LxmMyHongBaoSectionHeaderView"];
        }
        headerView.titleLabel.text = @"资金变动记录";
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        [LxmNetworking networkingPOST:deposit_change_list parameters:dict returnClass:LxmJiYiRecordRootModel.class success:^(NSURLSessionDataTask *task, LxmJiYiRecordRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.mapModel = responseObject.result.map;
                
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


@interface LxmMyBaoZhengJinCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation LxmMyBaoZhengJinCell

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
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@250);
        make.height.equalTo(@120);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(70);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"baozhengjin_bg"];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"保证金额";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = MainColor;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",LxmTool.ShareTool.userModel.deposit.doubleValue] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
        [att appendAttributedString:str];
        _moneyLabel.attributedText = att;
    }
    return _moneyLabel;
}

@end
