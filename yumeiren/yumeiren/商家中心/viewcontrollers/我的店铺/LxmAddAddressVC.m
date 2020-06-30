//
//  LxmAddAddressVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmAddAddressVC.h"

@interface LxmAddAddressTextTFCell : UIControl

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UITextField *rightTF;//

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmAddAddressTextTFCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(10);
            make.top.bottom.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [UITextField new];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.font = [UIFont boldSystemFontOfSize:13];
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end



@implementation LxmAddAddressSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.accImgView];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.accImgView.mas_leading).offset(-5);
            make.centerY.equalTo(self);
        }];
        [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _detailLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end

@interface LxmAddAddressDetailCell : UIView

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) IQTextView *detailTextView;//详细

@end
@implementation LxmAddAddressDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailTextView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
        }];
        [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(7);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (IQTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[IQTextView alloc] init];
        _detailTextView.font = [UIFont boldSystemFontOfSize:13];
        _detailTextView.textColor = CharacterDarkColor;
    }
    return _detailTextView;
}

@end



#import "LxmAddressPickerView.h"

@interface LxmAddAddressVC ()<LxmAddressPickerViewDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) LxmAddAddressTextTFCell *lianxirenCell;//联系人

@property (nonatomic, strong) LxmAddAddressTextTFCell *phoneCell;//电话

@property (nonatomic, strong) LxmAddAddressSelectCell *shengCell;//省

@property (nonatomic, strong) LxmAddAddressSelectCell *shiCell;//市

@property (nonatomic, strong) LxmAddAddressSelectCell *quCell;//区

@property (nonatomic, strong) LxmAddAddressDetailCell *detailCell;//详细信息

@property (nonatomic, strong) UIButton *sureButton;//确定

@property (nonatomic, strong) LxmAddressPickerView * pickerView;

@end

@implementation LxmAddAddressVC

- (LxmAddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[LxmAddressPickerView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 25;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 7*50 + 60)];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.model ? @"修改地址" : @"添加地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    self.tableView.tableHeaderView = self.headerView;
    [self initHeaderView];
    [self setHeaderViewConstrains];
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

/**
 头视图添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.lianxirenCell];
    [self.headerView addSubview:self.phoneCell];
    [self.headerView addSubview:self.shengCell];
    [self.headerView addSubview:self.shiCell];
    [self.headerView addSubview:self.quCell];
    [self.headerView addSubview:self.detailCell];
    [self.headerView addSubview:self.sureButton];
}

/**
 设置头视图子视图约束
 */
- (void)setHeaderViewConstrains {
    [self.lianxirenCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.phoneCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lianxirenCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.shengCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.shiCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shengCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.quCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shiCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.detailCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quCell.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@100);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailCell.mas_bottom).offset(15);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@44);
    }];
}

- (LxmAddAddressTextTFCell *)lianxirenCell {
    if (!_lianxirenCell) {
        _lianxirenCell = [[LxmAddAddressTextTFCell alloc] init];
        _lianxirenCell.titleLabel.text = @"联系人";
        _lianxirenCell.rightTF.placeholder = @"请输入联系人";
        if (self.model) {
            _lianxirenCell.rightTF.text = self.model.username;
        }
        
    }
    return _lianxirenCell;
}

- (LxmAddAddressTextTFCell *)phoneCell {
    if (!_phoneCell) {
        _phoneCell = [[LxmAddAddressTextTFCell alloc] init];
        _phoneCell.titleLabel.text = @"电话";
        _phoneCell.rightTF.placeholder = @"请输入联系电话";
        _phoneCell.rightTF.keyboardType = UIKeyboardTypeNumberPad;
        if (self.model) {
            _phoneCell.rightTF.text = self.model.telephone;
        }
    }
    return _phoneCell;
}

- (LxmAddAddressSelectCell *)shengCell {
    if (!_shengCell) {
        _shengCell = [[LxmAddAddressSelectCell alloc] init];
        _shengCell.titleLabel.text = @"选择省";
        if (self.model) {
            _shengCell.detailLabel.text = self.model.province;
        } else {
            _shengCell.detailLabel.text = @"请选择";
        }
        
        [_shengCell addTarget:self action:@selector(selectShengShiQu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shengCell;
}

- (LxmAddAddressSelectCell *)shiCell {
    if (!_shiCell) {
        _shiCell = [[LxmAddAddressSelectCell alloc] init];
        _shiCell.titleLabel.text = @"选择市";
        if (self.model) {
            _shiCell.detailLabel.text = self.model.city;
        } else {
            _shiCell.detailLabel.text = @"请选择";
        }
        [_shiCell addTarget:self action:@selector(selectShengShiQu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shiCell;
}

- (LxmAddAddressSelectCell *)quCell {
    if (!_quCell) {
        _quCell = [[LxmAddAddressSelectCell alloc] init];
        _quCell.titleLabel.text = @"选择区";
        if (self.model) {
            _quCell.detailLabel.text = self.model.district;
        } else {
            _quCell.detailLabel.text = @"请选择";
        }
        [_quCell addTarget:self action:@selector(selectShengShiQu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quCell;
}

- (LxmAddAddressDetailCell *)detailCell {
    if (!_detailCell) {
        _detailCell = [[LxmAddAddressDetailCell alloc] init];
        _detailCell.titleLabel.text = @"详情地址";
        _detailCell.detailTextView.placeholder = @"请输入详细地址";
        if (self.model) {
            _detailCell.detailTextView.text = self.model.addressDetail;
        }
    }
    return _detailCell;
}
/**
 选择省市区
 */
- (void)selectShengShiQu {
    [self.headerView endEditing:YES];
    [self.pickerView show];
}

/** 取消按钮点击事件*/
- (void)cancelBtnClick {
    [self.pickerView hide];
}
/**
 *  完成按钮点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area {
    [self.pickerView hide];
    self.shengCell.detailLabel.text = province;
    self.shiCell.detailLabel.text = city;
    self.quCell.detailLabel.text = area;
}


/**
 确定
 */
- (void)sureButtonClick {
    [self.headerView endEditing:YES];
    if (!self.lianxirenCell.rightTF.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人!"];
        return;
    }
    if (!self.phoneCell.rightTF.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话!"];
        return;
    }
    if (self.phoneCell.rightTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的联系电话!"];
        return;
    }
    if ([self.shengCell.detailLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区!"];
        return;
    }
    if (!self.detailCell.detailTextView.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址!"];
        return;
    }
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否设为默认?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak addAddress:@1];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak addAddress:@2];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}
/**
 添加收货地址 1：不是默认，2：是默认
 */
- (void)addAddress:(NSNumber *)num {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"linkName"] = self.lianxirenCell.rightTF.text;
    dict[@"linkPhone"] = self.phoneCell.rightTF.text;
    dict[@"province"] = self.shengCell.detailLabel.text;
    dict[@"city"] = self.shiCell.detailLabel.text;
    dict[@"district"] = self.quCell.detailLabel.text;
    dict[@"detailAddress"] = self.detailCell.detailTextView.text;
    dict[@"defaultStatus"] = num;
    if (self.model) {
        dict[@"id"] = self.model.id;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:add_up_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:self.model ? @"地址修改成功!" : @"地址添加成功!"];
            [LxmEventBus sendEvent:@"addAddressSuccess" data:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
