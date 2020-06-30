//
//  LxmJieDanPublishVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanPublishVC.h"
#import "LxmJieDanPublishAlertView.h"
#import "LxmAddressPickerView.h"
#import "LxmDataPickerView.h"
#import "LxmPayVC.h"

@interface LxmJieDanPublishVC ()<LxmAddressPickerViewDelegate,LxmDataPickerViewDelegate>

@property (nonatomic, strong) UIView *lineView;//
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *beifuwuren;
@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *dianhua;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *xuanzhesheng;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *xuanzheshi;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *xuanzhequ;
@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *xiangxidizhi;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *xuanzefuwuleibie;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *dingdanzuidijiage;
@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *shifoujiajia;
@property (nonatomic, strong) LxmJieDanPublishSelectedCell *shijianqujian;
@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *fuwushijian;

@property (nonatomic, strong) LxmJieDanPublishModel *typeModel;//服务类型model
//serviceDay
@property (nonatomic, strong) LxmAddressPickerView * pickerView;

@property (nonatomic, strong) LxmDataPickerView *startDataPicker;//开始时间

@property (nonatomic, strong) LxmDataPickerView *endDataPicker;//结束时间

@property (nonatomic, strong) NSDate *stratDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSString *stratTime;

@property (nonatomic, strong) NSString *endTime;

@end

@implementation LxmJieDanPublishVC

- (LxmAddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[LxmAddressPickerView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布";
    [self initViews];
    [self initSubviews];
}

/**
 初始化子视图
 */
- (void)initViews {
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

- (void)initSubviews {
    [self.contentView addSubview:self.beifuwuren];
    [self.contentView addSubview:self.dianhua];
    [self.contentView addSubview:self.xuanzhesheng];
    [self.contentView addSubview:self.xuanzheshi];
    [self.contentView addSubview:self.xuanzhequ];
    [self.contentView addSubview:self.xiangxidizhi];
    [self.contentView addSubview:self.xuanzefuwuleibie];
    [self.contentView addSubview:self.dingdanzuidijiage];
    [self.contentView addSubview:self.shifoujiajia];
    [self.contentView addSubview:self.shijianqujian];
    [self.contentView addSubview:self.fuwushijian];
    self.contentView.frame = CGRectMake(0, 0, ScreenW, 50 * 11 + 20 + 100);
    self.tableView.tableHeaderView = self.contentView;
    CGFloat height = 50;
    
    [self.beifuwuren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.contentView);
    }];
    
    [self.dianhua mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.beifuwuren.mas_bottom);
    }];
    
    [self.xuanzhesheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.dianhua.mas_bottom);
    }];
    
    [self.xuanzheshi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.xuanzhesheng.mas_bottom);
    }];
    
    [self.xuanzhequ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.xuanzheshi.mas_bottom);
    }];
    
    [self.xiangxidizhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.xuanzhequ.mas_bottom);
    }];
    
    [self.xuanzefuwuleibie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.xiangxidizhi.mas_bottom).offset(10);
    }];
    
    [self.dingdanzuidijiage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.xuanzefuwuleibie.mas_bottom);
    }];
    
    [self.shifoujiajia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.dingdanzuidijiage.mas_bottom);
    }];
    
    
    [self.shijianqujian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.shifoujiajia.mas_bottom).offset(10);
    }];
    
    [self.fuwushijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.view);
        make.height.equalTo(@(height));
        make.top.equalTo(self.shijianqujian.mas_bottom);
        // 最后一个cell  加上底部约束
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-100);
    }];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = UIColor.whiteColor;
    bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    bottomView.layer.shadowRadius = 5;
    bottomView.layer.shadowOpacity = 0.5;
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.view addSubview:bottomView];
    
    UIButton *publishBtn = [UIButton new];
    publishBtn.layer.cornerRadius = 4;
    publishBtn.layer.masksToBounds = YES;
    
    [publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(surePublish:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:publishBtn];
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(kDevice_Is_iPhoneX ? (54 + 30) : 64));
    }];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);;
        make.height.equalTo(@44);
        make.top.equalTo(@10);
    }];
   
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (LxmJieDanPublishTextFieldCell *)beifuwuren {
    if (!_beifuwuren) {
        _beifuwuren = [[LxmJieDanPublishTextFieldCell alloc] init];
        _beifuwuren.titleLabel.text = @"被服务人";
        _beifuwuren.textField.placeholder = @"请输入";
    }
    return _beifuwuren;
}

- (LxmJieDanPublishTextFieldCell *)dianhua {
    if (!_dianhua) {
        _dianhua = [[LxmJieDanPublishTextFieldCell alloc] init];
        _dianhua.titleLabel.text = @"电话";
        _dianhua.textField.placeholder = @"请输入";
        _dianhua.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _dianhua;
}

- (LxmJieDanPublishSelectedCell *)xuanzhesheng {
    if (!_xuanzhesheng) {
        _xuanzhesheng = [LxmJieDanPublishSelectedCell new];
        _xuanzhesheng.titleLabel.text = @"选择省";
        _xuanzhesheng.subTitleLabel.text = @"请选择";
        WeakObj(self);
        _xuanzhesheng.clickBlock = ^{
            [selfWeak.contentView endEditing:YES];
            [selfWeak.pickerView show];
        };
    }
    return _xuanzhesheng;
}

- (LxmJieDanPublishSelectedCell *)xuanzheshi {
    if (!_xuanzheshi) {
        _xuanzheshi = [LxmJieDanPublishSelectedCell new];
        _xuanzheshi.titleLabel.text = @"选择市";
        _xuanzheshi.subTitleLabel.text = @"请选择";
        WeakObj(self);
        _xuanzheshi.clickBlock = ^{
            [selfWeak.contentView endEditing:YES];
            [selfWeak.pickerView show];
        };
    }
    return _xuanzheshi;
}

- (LxmJieDanPublishSelectedCell *)xuanzhequ {
    if (!_xuanzhequ) {
        _xuanzhequ = [LxmJieDanPublishSelectedCell new];
        _xuanzhequ.titleLabel.text = @"选择区";
        _xuanzhequ.subTitleLabel.text = @"请选择";
        WeakObj(self);
        _xuanzhequ.clickBlock = ^{
            [selfWeak.contentView endEditing:YES];
            [selfWeak.pickerView show];
        };
    }
    return _xuanzhequ;
}

- (LxmJieDanPublishTextFieldCell *)xiangxidizhi {
    if (!_xiangxidizhi) {
        _xiangxidizhi = [[LxmJieDanPublishTextFieldCell alloc] init];
        _xiangxidizhi.titleLabel.text = @"详细地址";
        _xiangxidizhi.textField.placeholder = @"请输入";
    }
    return _xiangxidizhi;
}

- (LxmJieDanPublishSelectedCell *)xuanzefuwuleibie {
    if (!_xuanzefuwuleibie) {
        _xuanzefuwuleibie = [LxmJieDanPublishSelectedCell new];
        _xuanzefuwuleibie.titleLabel.text = @"选择服务类别";
        _xuanzefuwuleibie.subTitleLabel.text = @"请选择";
        WeakObj(self);
        _xuanzefuwuleibie.clickBlock = ^{
            [selfWeak.contentView endEditing:YES];
            NSLog(@"选择服务类别");
            LxmJieDanPublishAlertView *alertView = [[LxmJieDanPublishAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alertView.selectTypeBlock = ^(LxmJieDanPublishModel * _Nonnull model) {
                selfWeak.typeModel = model;
                selfWeak.xuanzefuwuleibie.subTitleLabel.text = model.typeName;
                selfWeak.dingdanzuidijiage.subTitleLabel.text = model.payPrice;
            };
            [alertView show];
        };
    }
    return _xuanzefuwuleibie;
}

- (LxmJieDanPublishSelectedCell *)dingdanzuidijiage {
    if (!_dingdanzuidijiage) {
        _dingdanzuidijiage = [LxmJieDanPublishSelectedCell new];
        _dingdanzuidijiage.titleLabel.text = @"订单最低价格";
        WeakObj(self);
        _dingdanzuidijiage.clickBlock = ^{
            [selfWeak.contentView endEditing:YES];
            NSLog(@"订单最低价格");
            if (!selfWeak.typeModel) {
                [SVProgressHUD showErrorWithStatus:@"请选择服务类型"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"请切换服务类型"];
            }
        };
    }
    return _dingdanzuidijiage;
}

- (LxmJieDanPublishTextFieldCell *)shifoujiajia {
    if (!_shifoujiajia) {
        _shifoujiajia = [[LxmJieDanPublishTextFieldCell alloc] init];
        _shifoujiajia.titleLabel.text = @"订单价格(不能低于最低价格)";
        _shifoujiajia.textField.placeholder = @"请输入金额";
        _shifoujiajia.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _shifoujiajia;
}

- (LxmJieDanPublishSelectedCell *)shijianqujian {
    if (!_shijianqujian) {
        _shijianqujian = [LxmJieDanPublishSelectedCell new];
        _shijianqujian.titleLabel.text = @"预计服务时间";
        _shijianqujian.subTitleLabel.text = @"请选择";
        WeakObj(self);
        _shijianqujian.clickBlock = ^{
            NSLog(@"时间区间");
            [selfWeak.contentView endEditing:YES];
            [selfWeak dataPicke];
        };
    }
    return _shijianqujian;
}

- (LxmJieDanPublishTextFieldCell *)fuwushijian {
    if (!_fuwushijian) {
        _fuwushijian = [LxmJieDanPublishTextFieldCell new];
        _fuwushijian.titleLabel.text = @"服务天数";
        _fuwushijian.textField.placeholder = @"请输入服务天数";
        _fuwushijian.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _fuwushijian;
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
    self.xuanzhesheng.subTitleLabel.text = province;
    self.xuanzheshi.subTitleLabel.text = city;
    self.xuanzhequ.subTitleLabel.text = area;
}

- (void)surePublish:(UIButton *)btn {
    [self.contentView endEditing:YES];
    NSString *name = self.beifuwuren.textField.text;
    if (![name isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入被服务人!"];
        return;
    }
    if ([NSString JudgeTheillegalCharacter:name] || [NSString isContainNum:name]) {
        [SVProgressHUD showErrorWithStatus:@"被服务人不能包含非法字符或数字!"];
        return;
    }
    if (![self.dianhua.textField.text isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入被服务人电话!"];
        return;
    }
    if (self.dianhua.textField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号码!"];
        return;
    }
    if ([self.xuanzhesheng.subTitleLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区!"];
        return;
    }
    if (![self.xiangxidizhi.textField.text isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址!"];
        return;
    }
    if (!self.typeModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择服务类别!"];
        return;
    }
    if (![self.dingdanzuidijiage.subTitleLabel.text isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请选择服务类别!"];
        return;
    }
    if (![self.shifoujiajia.textField.text isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入订单价格!"];
        return;
    }
    if (self.shifoujiajia.textField.text.doubleValue < self.typeModel.payPrice.doubleValue) {
        [SVProgressHUD showErrorWithStatus:@"订单价格不能低于最低价格!"];
        return;
    }
    if (!self.stratTime) {
        [SVProgressHUD showErrorWithStatus:@"请选择服务时间!"];
        return;
    }
    if (![self.fuwushijian.textField.text isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入服务天数!"];
        return;
    }
    NSInteger stratInterval = [[NSNumber numberWithDouble:[self.stratDate timeIntervalSince1970]] integerValue] * 1000;
    NSInteger endInterval = [[NSNumber numberWithDouble:[self.endDate timeIntervalSince1970]] integerValue] * 1000;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"username"] = self.beifuwuren.textField.text;
    dict[@"telephone"] = self.dianhua.textField.text;
    dict[@"province"] = self.xuanzhesheng.subTitleLabel.text;
    dict[@"city"] = self.xuanzheshi.subTitleLabel.text;
    dict[@"district"] = self.xuanzhequ.subTitleLabel.text;
    dict[@"addressDetail"] = self.xiangxidizhi.textField.text;
    dict[@"serviceType"] = self.typeModel.id;
    dict[@"payMoney"] = self.shifoujiajia.textField.text;
    dict[@"beginTime"] = @(stratInterval);
    dict[@"endTime"] = @(endInterval);
    dict[@"serviceDay"] = self.fuwushijian.textField.text;
    btn.userInteractionEnabled = NO;
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:send_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功!"];
            NSString *orderID = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"data"]];
            if (orderID.isValid) {
                LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_wfbd];
                vc.wfbdID = orderID;
                vc.wfbdMoney = self.shifoujiajia.textField.text;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LxmEventBus sendEvent:@"danzifabusuccess" data:nil];
                });
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

//选择服务时间
-(void)dataPicke {
    self.startDataPicker = [LxmDataPickerView pickerView];
    self.startDataPicker.titleLabel.text = @"服务开始时间";
    self.startDataPicker.delegate = self;
    [self.startDataPicker show];
}

-(void)LxmDataPickerView:(LxmDataPickerView *)view currentData:(NSDate *)date {
    if (view == self.startDataPicker) {
        self.stratDate = date;
        [view dismiss];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        self.stratTime = [dateFormatter stringFromDate:date];
        self.endDataPicker = [LxmDataPickerView pickerView];
        self.endDataPicker.titleLabel.text = @"服务结束时间";
        self.endDataPicker.delegate = self;
        [self.endDataPicker show];
    }
    if (view == self.endDataPicker) {
        self.endDate = date;
        int bijiao = [NSString compareOneDay:self.stratDate withAnotherDay:self.endDate];
        if (bijiao == 1) {
            [SVProgressHUD showErrorWithStatus:@"结束时间小于开始时间!"];
            return;
        } else {
            [view dismiss];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            
            self.endTime = [dateFormatter stringFromDate:date];
            self.shijianqujian.subTitleLabel.text = [NSString stringWithFormat:@"%@~%@",self.stratTime,self.endTime];
        }
    }
}

@end

@implementation LxmJieDanPublishTextFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        [self addSubview:self.lineView];
    
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.height.equalTo(@44);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = CharacterGrayColor;
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterGrayColor;
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutPriorityRequired];
    }
    return _titleLabel;
}

@end

@implementation LxmJieDanPublishSelectedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.jiantouView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self.jiantouView.mas_leading).offset(-5);
            make.leading.equalTo(self.titleLabel.mas_trailing);
        }];
        [self.jiantouView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self addLine];
        [self addTarget:self action:@selector(selfClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)selfClick {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)addLine {
    UIView *line = [UIView new];
    line.backgroundColor = BGGrayColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterGrayColor;
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutPriorityRequired];
    }
    return _titleLabel;
}

- (UITextField *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UITextField new];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor = CharacterGrayColor;
        _subTitleLabel.userInteractionEnabled = NO;
        [_subTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutPriorityRequired];
    }
    return _subTitleLabel;
}

- (UIImageView *)jiantouView {
    if (!_jiantouView) {
        _jiantouView = [[UIImageView alloc] init];
        _jiantouView.image = [UIImage imageNamed:@"next"];
    }
    return _jiantouView;
}


@end
