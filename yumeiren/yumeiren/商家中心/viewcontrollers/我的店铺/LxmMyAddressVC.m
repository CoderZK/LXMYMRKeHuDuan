//
//  LxmMyAddressVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMyAddressVC.h"
#import "LxmAddAddressVC.h"

@interface LxmMyAddressVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *addButton;//添加收货地址

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmAddressModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmMyAddressVC

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

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"添加收货地址" forState:UIControlStateNormal];
        [_addButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"tianjia_dizhi"] forState:UIControlStateNormal];
        _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.masksToBounds = YES;
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的地址";
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
    [LxmEventBus registerEvent:@"addAddressSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
}
/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.addButton];
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
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self.bottomView).offset(20);
        make.trailing.equalTo(self.bottomView).offset(-20);
        make.height.equalTo(@50);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMyAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyAddressCell"];
    if (!cell) {
        cell = [[LxmMyAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyAddressCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    WeakObj(self);
    cell.modeifyCurrentAddressBlock = ^(LxmAddressModel *model) {
        [selfWeak modifyAddress:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArr[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didselectedAddressBlock) {
        self.didselectedAddressBlock(self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"删除收货地址?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       [selfWeak deleteAddress:self.dataArr[indexPath.row]];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/**
 添加收货地址
 */
- (void)addButtonClick {
    LxmAddAddressVC *vc = [[LxmAddAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        [LxmNetworking networkingPOST:address_list parameters:@{@"token":SESSION_TOKEN,@"pageNum": @(self.page)} returnClass:LxmAddressRootModel.class success:^(NSURLSessionDataTask *task, LxmAddressRootModel *responseObject) {
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
 修改收货地址
 */
- (void)modifyAddress:(LxmAddressModel *)model {
    LxmAddAddressVC *vc = [[LxmAddAddressVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 删除收货地址
 */
- (void)deleteAddress:(LxmAddressModel *)model {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:del_address parameters:@{@"token":SESSION_TOKEN,@"addressId":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除!"];
            [self.dataArr removeObject:model];
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end

/**
 我的地址cell
 */
@interface LxmMyAddressCell ()

@property (nonatomic, strong) UILabel *titleLabel;//姓名 + 电话

@property (nonatomic, strong) UILabel *morenLabel;//默认

@property (nonatomic, strong) UILabel *addressLabel;//地址

@property (nonatomic, strong) UIButton *modifyButton;//修改

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmMyAddressCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.morenLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.modifyButton];
    [self.modifyButton addSubview:self.iconImgView];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.lessThanOrEqualTo(self.modifyButton.mas_leading);
    }];
    [self.morenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(70);
        make.trailing.lessThanOrEqualTo(self.modifyButton.mas_leading);
    }];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.equalTo(@80);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.modifyButton).offset(-15);
        make.centerY.equalTo(self.modifyButton);
        make.width.height.equalTo(@20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)morenLabel {
    if (!_morenLabel) {
        _morenLabel = [[UILabel alloc] init];
        _morenLabel.backgroundColor = MainColor;
        _morenLabel.textColor = UIColor.whiteColor;
        _morenLabel.textAlignment = NSTextAlignmentCenter;
        _morenLabel.font = [UIFont systemFontOfSize:12];
        _morenLabel.text = @"默认";
    }
    return _morenLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = CharacterDarkColor;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [[UIButton alloc] init];
        [_modifyButton addTarget:self action:@selector(modifyAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"bianji"];
    }
    return _iconImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmAddressModel *)model {
    _model = model;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", _model.username] attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _model.telephone] attributes:@{ NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [att appendAttributedString:str];
    self.titleLabel.attributedText = att;
    if (_model.defaultStatus.integerValue == 1) {//不是默认
        self.morenLabel.hidden = YES;
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
        }];
    } else {//默认
        self.morenLabel.hidden = NO;
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(70);
        }];
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_model.province, _model.city, _model.district, _model.addressDetail];
}
/**
 修改地址按钮
 */
- (void)modifyAddressClick {
    if (self.modeifyCurrentAddressBlock) {
        self.modeifyCurrentAddressBlock(self.model);
    }
}

@end
