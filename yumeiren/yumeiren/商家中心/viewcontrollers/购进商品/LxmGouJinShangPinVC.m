//
//  LxmGouJinShangPinVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmGouJinShangPinVC.h"
#import "LxmShopCarView.h"
#import "LxmZiTiVC.h"

@interface LxmGouJinShangPinVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIButton *leftButton;//导航栏左侧按钮

@property (nonatomic, strong) LxmShopCarBottomView *bottomView;

@end

@implementation LxmGouJinShangPinVC


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
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"购进商品";
    [self initSubviews];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
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
        make.height.equalTo(@60);
    }];
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [_leftButton setTitle:@"进货单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftButton addTarget:self action:@selector(jinhuodan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmGouJinShangPinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGouJinShangPinCell"];
    if (!cell) {
        cell = [[LxmGouJinShangPinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGouJinShangPinCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

/**
 进货单
 */
- (void)jinhuodan {
    LxmZiTiVC *vc = [[LxmZiTiVC alloc] init];
    vc.isJinHuodan = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@interface LxmGouJinShangPinCell()

@property (nonatomic, strong) UIButton *selectButton;//选择按钮

@property (nonatomic, strong) UIImageView *selectImgView;//选择背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *kucunLabel;//库存

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) LxmNumView *numView;//增加减少输入

@end
@implementation LxmGouJinShangPinCell

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
        _kucunLabel.font = [UIFont boldSystemFontOfSize:13];
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
    }
    return _numView;
}

- (void)setData {
    self.selectImgView.backgroundColor = MainColor;
    self.titleLabel.text = @"高端魅力修护套装";
    self.moneyLabel.text = @"¥198";
    _numView.numTF.text = @"1";
    self.kucunLabel.text = @"库存:30";
}

@end
