//
//  LxmSafeAutherVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSafeAutherVC.h"

#import "LxmRenZhengProtocolVC.h"

@interface LxmSafeAutherView : UIView

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmSafeAutherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightTF];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstains {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
    }];
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing);
        make.trailing.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.font = [UIFont systemFontOfSize:13];
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmSafeAutherVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *zhengcardButton;//身份证正面按钮

@property (nonatomic, strong) UIImageView *zhengcardImgView;//身份证正面

@property (nonatomic, strong) UILabel *uploadZhengCardLabel;//上传身份证正面

@property (nonatomic, strong) UIButton *fancardButton;//身份证反面按钮

@property (nonatomic, strong) UIImageView *fancardImgView;//身份证反面

@property (nonatomic, strong) UIButton *fanZhengCardButton;//上传身份证反面

@property (nonatomic, strong) UILabel *uploadfanCardLabel;//上传身份证反面

@property (nonatomic, strong) UIView *bottomView;//底部视图

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) NSMutableDictionary *infoDict;//识别出的信息数组
@property (nonatomic, strong) NSMutableDictionary *infoDict1;//识别出的反面信息数组

@property (nonatomic, strong) NSString *zhengStr;//身份证正面id

@property (nonatomic, strong) NSString *fanStr;//身份证反面id

@property (nonatomic, strong) LxmSafeAutherView *nameView;

@property (nonatomic, strong) LxmSafeAutherView *cardView;

@end

@implementation LxmSafeAutherVC

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
        _bottomView.layer.shadowOffset = CGSizeZero;
        _bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bottomView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bottomView;
}


- (UIButton *)nextbutton {
    if (!_nextbutton) {
        _nextbutton = [[UIButton alloc] init];
        [_nextbutton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_nextbutton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextbutton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextbutton.layer.cornerRadius = 5;
        _nextbutton.layer.masksToBounds = YES;
        [_nextbutton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextbutton;
}

- (NSMutableDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}
- (NSMutableDictionary *)infoDict1 {
    if (!_infoDict1) {
        _infoDict1 = [NSMutableDictionary dictionary];
    }
    return _infoDict1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安全认证";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubViews];
    [self initFootView];
}

/**
 底部View
 */
- (void)initFootView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
   
    [footerView addSubview:self.nameView];
    [footerView addSubview:self.cardView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(footerView);
        make.height.equalTo(@50);
    }];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.leading.trailing.equalTo(footerView);
        make.height.equalTo(@50);
    }];
}

- (LxmSafeAutherView *)nameView {
    if (!_nameView) {
        _nameView = [[LxmSafeAutherView alloc] init];
        _nameView.nameLabel.text = @"姓名";
        _nameView.rightTF.placeholder = @"请输入姓名";
    }
    return _nameView;
}

- (LxmSafeAutherView *)cardView {
    if (!_cardView) {
        _cardView = [[LxmSafeAutherView alloc] init];
        _cardView.nameLabel.text = @"身份证号";
        _cardView.rightTF.placeholder = @"请输入身份证号";
    }
    return _cardView;
}

/**
 初始化
 */
- (void)initSubViews {
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
        make.height.equalTo(@(TableViewBottomSpace + 70));
    }];
    
    [self.bottomView addSubview:self.nextbutton];
    
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(@(ScreenW - 30));
        make.height.equalTo(@50);
    }];
}

#pragma --mark 事件
/**
 提交认证
 */
- (void)nextClick:(UIButton *)btn {
    [self.tableView endEditing:YES];
    if (self.nameView.rightTF.text.length == 0 || [self.nameView.rightTF.text isEqual:@""] || [[self.nameView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的姓名!"];
        return;
    }
    if (self.cardView.rightTF.text.length == 0 || [self.cardView.rightTF.text isEqual:@""] || [[self.cardView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的身份证号!"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"realName"] = self.nameView.rightTF.text;
    dict[@"idCode"] = self.cardView.rightTF.text;
    NSLog(@"%@", dict);
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:do_real_info parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        StrongObj(self);
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已认证!"];
            [self loadMyUserInfoWithOkBlock:^{
                LxmRenZhengProtocolVC *vc = [[LxmRenZhengProtocolVC alloc] init];
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}


@end
