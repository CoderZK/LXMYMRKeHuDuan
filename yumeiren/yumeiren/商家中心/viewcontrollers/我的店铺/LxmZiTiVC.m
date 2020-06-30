//
//  LxmZiTiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmZiTiVC.h"
#import "LxmShopCarView.h"
#import "LxmZiTiJieSuanVC.h"

@interface LxmZiTiVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmShopCarBottomView *bottomView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LxmZiTiVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmShopCarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmShopCarBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.allImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
        [_bottomView.allSelectButton addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        WeakObj(self);
        _bottomView.jiesuanBlock = ^{
            [selfWeak bottomViewAction];
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = self.isJinHuodan ? @"进货单" : @"提货";
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
    
    /* 发货下单成功 */
    [LxmEventBus registerEvent:@"fahuoxaidanSuccess" block:^(id data) {
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
        make.height.equalTo(@(60 + TableViewBottomSpace));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmZiTiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmZiTiCell"];
    if (!cell) {
        cell = [[LxmZiTiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmZiTiCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    WeakObj(self);
    cell.selectClick = ^(LxmShopCenterModel *model) {
        model.isSelected = !model.isSelected;
        [selfWeak.tableView reloadData];
        NSInteger count = 0;
        for (LxmShopCenterModel *model in selfWeak.dataArr) {
            if (model.isSelected) {
                count ++;
            }
        }
        self.bottomView.allImgView.image = [UIImage imageNamed:count == selfWeak.dataArr.count ? @"xuanzhong_y" : @"xuanzhong_n"];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)bottomViewAction {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (LxmShopCarModel *model in self.dataArr) {
        if (model.isSelected) {
            [tempArr addObject:model];
        }
    }
    if (tempArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择宝贝哦!"];
        return;
    }
    [self settleCarOrder:tempArr];
}

/**
 全选
 */
- (void)allSelectClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.bottomView.allImgView.image = [UIImage imageNamed:btn.selected ? @"xuanzhong_y" : @"xuanzhong_n"];
    NSInteger count = 0;
    for (LxmShopCarModel *model in self.dataArr) {
        if (btn.selected) {
            model.isSelected = YES;
            count ++;
        }else {
            model.isSelected = NO;
        }
    }
    [self.tableView reloadData];
}

/**
 结算
 */
- (void)settleCarOrder:(NSMutableArray *)addArr {
    if (addArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择发货商品!"];
        return;
    }
    
    if (LxmTool.ShareTool.userModel.postMoney.floatValue == 0) {
        LxmZiTiJieSuanVC *vc = [[LxmZiTiJieSuanVC alloc] init];
        vc.fahuoArr = addArr;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CGFloat allPrice = 0;
        for (LxmShopCarModel *m in addArr) {
            if (!m.num.isValid) {
                m.num = @"1";
            }
            allPrice += m.proxy_price.doubleValue * m.num.intValue;
        }
        if (allPrice < LxmTool.ShareTool.userModel.postMoney.doubleValue) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"满%.2f包邮,是否继续发货",LxmTool.ShareTool.userModel.postMoney.doubleValue] preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"直接发货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LxmZiTiJieSuanVC *vc = [[LxmZiTiJieSuanVC alloc] init];
                vc.fahuoArr = addArr;
                [self.navigationController pushViewController:vc animated:YES];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"继续添加" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
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
        [LxmNetworking networkingPOST:stock_list parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page),@"status":@1} returnClass:LxmShopCenterRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterRootModel *responseObject) {
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

//自提cell
@interface LxmZiTiCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *selectButton;//选择按钮

@property (nonatomic, strong) UIImageView *selectImgView;//选择背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *kucunLabel;//库存

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@end
@implementation LxmZiTiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
         [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.selectButton];
    [self.selectButton addSubview:self.selectImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.kucunLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@50);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.selectButton);
        make.width.height.equalTo(@20);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing);
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
        make.trailing.lessThanOrEqualTo(self.numView.mas_leading).offset(-5);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
        make.height.equalTo(@26);
    }];
    [self.kucunLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
    }
    return _selectImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.backgroundColor = MainColor;
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
    }
    return _moneyLabel;
}

- (LxmNumView *)numView {
    if (!_numView) {
        _numView = [[LxmNumView alloc] init];
        _numView.numTF.delegate = self;
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _numView;
}

- (void)textFieldDidChanged {
    if (_numView.numTF.text.integerValue > self.model.good_num.integerValue) {
        _numView.numTF.text = self.model.good_num;
        _model.num = _numView.numTF.text;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.intValue < 1) {
        _numView.numTF.text = @"1";
        [SVProgressHUD showErrorWithStatus:@"至少购买一件商品!"];
        return;
    }
    _model.num = _numView.numTF.text;
}

- (void)btnClick:(UIButton *)btn {
    [self endEditing:YES];
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
            _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
        }else {
            [SVProgressHUD showErrorWithStatus:@"受不了了,不能再少了!"];
            return;
        }
    }else {
        if (_numView.numTF.text.integerValue + 1 > self.model.good_num.integerValue) {
            _numView.numTF.text = self.model.good_num;
            [SVProgressHUD showErrorWithStatus:@"库存不足!"];
            return;
        } else {
            num ++;
            _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
        }
    }
    self.model.num = _numView.numTF.text;
}

- (void)selectClick:(UIButton *)btn {
    if (self.selectClick) {
        self.selectClick(self.model);
    }
    
}


- (void)setData {
    self.selectImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    self.titleLabel.text = @"高端魅力修护套装";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"¥198 " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"¥158" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    _numView.numTF.text = @"1";
    self.kucunLabel.text = @"库存: 30";
}

- (void)setModel:(LxmShopCenterModel *)model {
    _model = model;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.selectImgView.image = [UIImage imageNamed:_model.isSelected ? @"xuanzhong_y" : @"xuanzhong_n"];
    self.titleLabel.text = _model.good_name;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ ", _model.proxy_price] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:MainColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",_model.good_price] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:CharacterLightGrayColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    [att appendAttributedString:str];
    self.moneyLabel.attributedText = att;
    if (!_model.num) {
        _model.num = @"1";
    }
    _numView.numTF.text = _model.num;
    self.kucunLabel.text = [NSString stringWithFormat:@"库存: %@", _model.good_num];
}

@end
