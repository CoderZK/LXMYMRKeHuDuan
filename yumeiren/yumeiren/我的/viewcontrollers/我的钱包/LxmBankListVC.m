//
//  LxmSelectBankVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmBankListVC.h"
#import "LxmSelectBankVC.h"

@interface LxmBankListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *addImgView;//添加银行卡

@property (nonatomic, strong) UILabel *bankCardNo;//银行 + 银行卡号

@property (nonatomic, strong) UIImageView *selectImgView;

@property (nonatomic, strong) LxmMyBankModel *model;

@end

@implementation LxmBankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.addImgView];
        [self.addImgView addSubview:self.bankCardNo];
        [self.addImgView addSubview:self.selectImgView];
    
        [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.bankCardNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.addImgView).offset(15);
            make.centerY.equalTo(self.addImgView);
        }];
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.addImgView).offset(-15);
            make.centerY.equalTo(self.addImgView);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIImageView *)addImgView {
    if (!_addImgView) {
        _addImgView = [UIImageView new];
        _addImgView.userInteractionEnabled = YES;
        _addImgView.layer.cornerRadius = 5;
        _addImgView.layer.masksToBounds = YES;
        _addImgView.image = [UIImage imageNamed:@"blue"];
    }
    return _addImgView;
}

- (UILabel *)bankCardNo {
    if (!_bankCardNo) {
        _bankCardNo = [UILabel new];
        _bankCardNo.textColor = UIColor.whiteColor;
        _bankCardNo.font = [UIFont systemFontOfSize:14];
        _bankCardNo.text = @"华夏银行 1234567897144523123";
    }
    return _bankCardNo;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
    }
    return _selectImgView;
}

- (void)setModel:(LxmMyBankModel *)model {
    _model = model;
    NSString *str = _model.bankCode;
    if (str.length >= 4) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < str.length - 4; i++) {
            [arr addObject:@"*"];
        }
        str = [str substringWithRange:NSMakeRange(str.length - 4, 4)];
        _bankCardNo.text = [NSString stringWithFormat:@"%@  %@", _model.bankName,  [[arr componentsJoinedByString:@""] stringByAppendingString:str]];
    } else {
        _bankCardNo.text = [NSString stringWithFormat:@"%@  %@", _model.bankName,  _model.bankCode];
    }
    
}

@end


@interface LxmBankListVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIImageView *addImgView;//添加银行卡

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMyBankModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, assign) NSInteger currentIndex;//当前选中的

@end

@implementation LxmBankListVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIImageView *)addImgView {
    if (!_addImgView) {
        _addImgView = [UIImageView new];
        _addImgView.userInteractionEnabled = YES;
        _addImgView.image = [UIImage imageNamed:@"tianjia"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddImgView)];
        [_addImgView addGestureRecognizer:tap];
    }
    return _addImgView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (ScreenW - 30) * 150 / 690 + 15)];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行卡";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self initFooterView];
    
    self.currentIndex = -111;
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
    
    /* 银行卡添加成功 */
    [LxmEventBus registerEvent:@"addBankSuccess" block:^(id data) {
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
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (void)initFooterView {
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.addImgView];
    [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(15);
        make.leading.equalTo(self.footerView).offset(15);
        make.trailing.equalTo(self.footerView).offset(-15);
        make.height.equalTo(@((ScreenW - 30) * 150 / 690));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmBankListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmBankListCell"];
    if (!cell) {
        cell = [[LxmBankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmBankListCell"];
    }
    cell.model = self.dataArr[indexPath.section];
    cell.selectImgView.image = [UIImage imageNamed:self.currentIndex != indexPath.section ? @"xz_n" : @"xz_y"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (ScreenW - 30) * 150 / 690;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.section;
    [self.tableView reloadData];
    if (self.selectBankModelBlock) {
        self.selectBankModelBlock(self.dataArr[indexPath.section]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定删除银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak deleteBank:selfWeak.dataArr[indexPath.section]];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


/**
 添加银行卡
 */
- (void)tapAddImgView {
    LxmSelectBankVC *vc = [[LxmSelectBankVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [SVProgressHUD show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] = @(self.page);
        dict[@"pageSize"] = @10;
        [LxmNetworking networkingPOST:bank_list parameters:dict returnClass:LxmMyBankRootModel.class success:^(NSURLSessionDataTask *task, LxmMyBankRootModel *responseObject) {
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
 删除银行卡
 */
- (void)deleteBank:(LxmMyBankModel *)model {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:del_bank parameters:@{@"token":SESSION_TOKEN,@"bank_id":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除!"];
            [selfWeak.dataArr removeObject:model];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end

