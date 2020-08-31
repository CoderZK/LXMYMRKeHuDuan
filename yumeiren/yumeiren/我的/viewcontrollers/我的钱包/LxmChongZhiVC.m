//
//  LxmChongZhiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmChongZhiVC.h"
#import "LxmPayVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface LxmChongZhiHeaderView : UIView

@property (nonatomic, strong) UILabel *textLabel;//充值金额

@property (nonatomic, strong) UILabel *yuanlabel;//元

@property (nonatomic, strong) UITextField *moneyTF;//输入的钱数

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *textLabel11;//单笔充值不能超过50000

@property (nonatomic, strong) UILabel *textLabel1;//选择充值方式

@end
@implementation LxmChongZhiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.textLabel11];
    [self addSubview:self.yuanlabel];
    [self addSubview:self.moneyTF];
    [self addSubview:self.lineView];
    [self addSubview:self.textLabel];
    [self addSubview:self.textLabel1];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
    [self.yuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yuanlabel.mas_trailing);
        make.centerY.equalTo(self.yuanlabel);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.moneyTF.mas_bottom);
        make.height.equalTo(@1);
    }];
    [self.textLabel11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel11.mas_bottom).offset(30);
        make.leading.equalTo(self).offset(15);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"充值金额";
    }
    return _textLabel;
}

- (UILabel *)yuanlabel {
    if (!_yuanlabel) {
        _yuanlabel = [UILabel new];
        _yuanlabel.font = [UIFont boldSystemFontOfSize:25];
        _yuanlabel.textColor = UIColor.blackColor;
        _yuanlabel.text = @"¥";
    }
    return _yuanlabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UITextField *)moneyTF {
    if (!_moneyTF) {
        _moneyTF = [UITextField new];
        _moneyTF.textColor = UIColor.blackColor;
        _moneyTF.font = [UIFont boldSystemFontOfSize:25];
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _moneyTF;
}

- (UILabel *)textLabel11 {
    if (!_textLabel11) {
        _textLabel11 = [UILabel new];
        _textLabel11.font = [UIFont systemFontOfSize:14];
        _textLabel11.textColor = CharacterLightGrayColor;
        _textLabel11.text = @"单笔充值不能超过¥50000";
    }
    return _textLabel11;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont boldSystemFontOfSize:14];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = @"选择充值方式";
    }
    return _textLabel1;
}

@end


@interface LxmChongZhiVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmChongZhiHeaderView *headerView;

@property (nonatomic, strong) UIButton *chongzhiButton;//充值

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation LxmChongZhiVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmChongZhiHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LxmChongZhiHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 170)];
    }
    return _headerView;
}

- (UIButton *)chongzhiButton {
    if (!_chongzhiButton) {
        _chongzhiButton = [[UIButton alloc] init];
        [_chongzhiButton setTitle:@"充值" forState:UIControlStateNormal];
        [_chongzhiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_chongzhiButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _chongzhiButton.layer.cornerRadius = 5;
        _chongzhiButton.layer.masksToBounds = YES;
        _chongzhiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chongzhiButton addTarget:self action:@selector(chongzhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chongzhiButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayNoti:) name:@"WXPAY" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
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
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.tableView.tableFooterView = footView;
    
    [footView addSubview:self.chongzhiButton];
    [self.chongzhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(footView).offset(-20);
        make.leading.equalTo(footView).offset(20);
        make.bottom.equalTo(footView);
        make.height.equalTo(@44);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPayCell"];
    if (!cell) {
        cell = [[LxmPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPayCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectImgView.image = self.currentIndex == indexPath.row ? [UIImage imageNamed:@"xuanzhong_y"] : [UIImage imageNamed:@"xuanzhong_n"];
    if (indexPath.row == 0) {
        cell.iconImgView.image = [UIImage imageNamed:@"alipay_pay"];
        cell.titleLabel.text = @"支付宝支付";
    } else {
        cell.iconImgView.image = [UIImage imageNamed:@"wechat_pay"];
        cell.titleLabel.text = @"微信支付";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
}

/**
 充值
 */
- (void)chongzhiButtonClick {
    [self.headerView endEditing:YES];
    if (!self.headerView.moneyTF.text.isValid || self.headerView.moneyTF.text.doubleValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值金额!"];
        return;
    }
    if (self.headerView.moneyTF.text.doubleValue > 50000) {
        [SVProgressHUD showErrorWithStatus:@"单笔充值金额不能超过5万!"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"payMoney" : self.headerView.moneyTF.text,
                           @"type" : @(self.currentIndex + 1),
                           };
    [SVProgressHUD show];
    self.chongzhiButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LxmNetworking networkingPOST:up_recharge parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        selfWeak.chongzhiButton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已提交充值申请!"];
            if (self.currentIndex == 0) {//支付宝
                NSString *payStr = responseObject[@"result"][@"data"];
                if (payStr.isValid) {
                    [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"com.biuwork.yumeiren.alipaysafety" callback:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"支付信息获取失败!"];
                }
                
            } else {//微信
                NSDictionary * dict = responseObject[@"result"][@"map"];
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req completion:nil];
            }
            
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        selfWeak.chongzhiButton.userInteractionEnabled = YES;
    }];
}

- (void)zhiFuBaoNoti:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"取消支付"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        [SVProgressHUD showSuccessWithStatus:@"充值成功"];
        [LxmEventBus sendEvent:@"chargeSuccess" data:nil];
        [self loadMyUserInfoWithOkBlock:nil];
        [LxmEventBus sendEvent:@"chongzhiSuccess" data:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

- (void)wechatPayNoti:(NSNotification *)noti{
    BaseResp * resp = noti.object;
    if (resp.errCode==WXSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [LxmEventBus sendEvent:@"chargeSuccess" data:nil];
        [self loadMyUserInfoWithOkBlock:nil];
        [LxmEventBus sendEvent:@"chongzhiSuccess" data:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (resp.errCode==WXErrCodeUserCancel) {
        [SVProgressHUD showErrorWithStatus:@"用户取消了支付"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

@end



