//
//  LxmXuanZeBankVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmXuanZeBankVC.h"

@interface LxmXuanZeBankCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//银行

@property (nonatomic, strong) UIImageView *accimgView;//对号

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmXuanZeBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.accimgView];
    [self addSubview:self.lineView];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.accimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.text = @"中国工商银行";
    }
    return _leftLabel;
}

- (UIImageView *)accimgView {
    if (!_accimgView) {
        _accimgView = [[UIImageView alloc] init];
        _accimgView.image = [UIImage imageNamed:@"xuanze"];
    }
    return _accimgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmXuanZeBankVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmBankRootModel *model;

@end

@implementation LxmXuanZeBankVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    /* 获取银行卡列表 */
    [self loadBankList];
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
    return self.model.result.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmXuanZeBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmXuanZeBankCell"];
    if (!cell) {
        cell = [[LxmXuanZeBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmXuanZeBankCell"];
    }
    LxmBankModel *model = self.model.result.list[indexPath.row];
    cell.leftLabel.text = model.bankName;
    cell.accimgView.hidden = !model.isSelected;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (LxmBankModel *model in self.model.result.list) {
        model.isSelected = NO;
    }
    LxmBankModel *model = self.model.result.list[indexPath.row];
    model.isSelected = YES;
    if (self.selectBankModelBlock) {
        self.selectBankModelBlock(model);
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 银行列表
 */
- (void)loadBankList {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:dic_bank_list parameters:@{@"token" : SESSION_TOKEN} returnClass:LxmBankRootModel.class success:^(NSURLSessionDataTask *task, LxmBankRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            StrongObj(self);
            self.model = responseObject;
            if (selfWeak.currentModel) {
                for (LxmBankModel *model in self.model.result.list) {
                    if (model.id == selfWeak.currentModel.id) {
                        model.isSelected = YES;
                    }
                }
            } else {
                if (self.model.result.list.count >= 1) {
                    self.model.result.list.firstObject.isSelected = YES;
                }
            }
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end



