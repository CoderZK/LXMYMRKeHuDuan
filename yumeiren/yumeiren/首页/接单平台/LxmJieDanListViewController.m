//
//  LxmJieDanListViewController.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanListViewController.h"
#import "LxmJieDanPublishVC.h"
#import "LxmPanButton.h"
#import "LxmJiedanMyPublishVC.h"

@interface LxmJieDanListViewController ()

@property (nonatomic, strong) NSMutableArray <LxmJieDanListModel *> *dataArr;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmJieDanListViewController

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂无待接订单哦!";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单平台";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addPublishBtn];
    [self.view addSubview:self.emptyView];
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@200);
    }];
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
    /* 已提交撤单 */
    [LxmEventBus registerEvent:@"chedansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    /* 已提交退单 */
    [LxmEventBus registerEvent:@"tijiaotuidansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    
}

- (void)addPublishBtn {
    LxmPanButton *publishBtn = [LxmPanButton new];
    [self.view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.view).offset(-20);
        make.width.height.equalTo(@50);
    }];
    WeakObj(self);
    publishBtn.panBlock = ^{
        [selfWeak publishBtnClick];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        LxmJieDanListRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanListRenCell"];
        if (!cell) {
            cell = [[LxmJieDanListRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanListRenCell"];
        }
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
        LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
        }
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"服务类型:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.serviceTypeName];
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"时间区间:";
            if (model.beginTime.length > 10) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[[model.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[model.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
            } else {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[model.beginTime getIntervalToFXXTNoHHmmime],[model.endTime getIntervalToFXXTNoHHmmime]];
            }
        } else if (indexPath.row == 3) {
            cell.titleLabel.text = @"服务时间:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@天",model.serviceDay];
        } else {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.addressDetail];
            cell.titleLabel.text = @"服务地址:";
            cell.detailLabel.text = str;
        }
        return cell;
    } else {
        LxmJieDanMyBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyBottomCell"];
        if (!cell) {
            cell = [[LxmJieDanMyBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyBottomCell"];
        }
        cell.jiedanModel = model;
        WeakObj(self);
        cell.bottomButtonActionBlock = ^(NSInteger index, LxmJieDanListModel *model) {
            [selfWeak bottomActionIndex:index currentModel:model];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 1) {
        CGFloat h = [model.serviceTypeName getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
        return h;
    } else if (indexPath.row == 2 ) {
        if (model.beginTime.length > 10) {
            NSString *str = [NSString stringWithFormat:@"%@-%@",[[model.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[model.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
            return h;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@-%@",[model.beginTime getIntervalToFXXTNoHHmmime],[model.endTime getIntervalToFXXTNoHHmmime]];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
            return h;
        }
    } else if (indexPath.row == 3) {
        CGFloat h = [[model.servicePrice stringByAppendingString:@"天"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 10;
        return h;
    } else if (indexPath.row == 4) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.addressDetail];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
        return h;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)publishBtnClick {
    LxmJieDanPublishVC *vc = [LxmJieDanPublishVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 底部按钮操作
 
 @param index //222左 333右
 @param model 当前实例
 */
- (void)bottomActionIndex:(NSInteger)index currentModel:(LxmJieDanListModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认接单?" message:@"您确定要接单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //接单
        if (model.userId.intValue == [LxmTool ShareTool].userModel.id.intValue) {
            [SVProgressHUD showErrorWithStatus:@"自己不能接自己发的单!"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"id"] = model.id;
        [SVProgressHUD show];
        WeakObj(self);
        [LxmNetworking networkingPOST:get_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [SVProgressHUD showSuccessWithStatus:@"已接单!"];
                [LxmEventBus sendEvent:@"jiedansuccess" data:nil];
                StrongObj(self);
                self.page = 1;
                self.allPageNum = 1;
                [self loadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
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
        dict[@"type"] = @1;
        dict[@"pageNum"] = @(self.page);
        dict[@"city"] = self.city;
        [LxmNetworking networkingPOST:wait_get_service_list parameters:dict returnClass:LxmJieDanListRootModel.class success:^(NSURLSessionDataTask *task, LxmJieDanListRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                [LxmEventBus sendEvent:@"danCout" data:responseObject.result.count];
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.page ++;
                self.emptyView.hidden = self.dataArr.count > 0;
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

@interface LxmJieDanListRenCell ()
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end
@implementation LxmJieDanListRenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.priceLabel];
    
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.headerImgView).offset(-10);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.centerY.equalTo(self.headerImgView).offset(13);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 25;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = UIColor.blackColor;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = UILabel.new;
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.text = @"2018/6/6 18:17";
        _dateLabel.textColor = CharacterGrayColor;
    }
    return _dateLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = UILabel.new;
        _priceLabel.font = [UIFont boldSystemFontOfSize:18];
        _priceLabel.textColor = MainColor;
    }
    return _priceLabel;
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.showHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    _nameLabel.text = _model.showName;
    if (_model.createTime.length > 10) {
        _dateLabel.text = [[_model.createTime substringToIndex:10] getIntervalToFXXTime];
    } else {
        _dateLabel.text = [_model.createTime getIntervalToFXXTime];
    }
    CGFloat f = _model.servicePrice.doubleValue + _model.addPrice.doubleValue;
    NSInteger d = _model.servicePrice.integerValue + _model.addPrice.integerValue;
    if (f == d) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%ld",d];
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
    }
}

/**
 我接受的
 */
- (void)setJieshouModel:(LxmJieDanListModel *)jieshouModel {
    _jieshouModel = jieshouModel;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_jieshouModel.showHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    _nameLabel.text = _jieshouModel.showName;
    if (_jieshouModel.createTime.length > 10) {
        _dateLabel.text = [[_jieshouModel.createTime substringToIndex:10] getIntervalToFXXTime];
    } else {
        _dateLabel.text = [_jieshouModel.createTime getIntervalToFXXTime];
    }
    CGFloat f = _jieshouModel.servicePrice.doubleValue + _jieshouModel.addPrice.doubleValue;
    NSInteger d = _jieshouModel.servicePrice.integerValue + _jieshouModel.addPrice.integerValue;
    if (f == d) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%ld",d];
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
    }
    
    [_headerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.height.equalTo(@50);
    }];
    [self layoutIfNeeded];
}
/**
 详情
 */
- (void)setDetailModel:(LxmJieDanListModel *)detailModel {
    _detailModel = detailModel;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_detailModel.showHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    _nameLabel.text = _detailModel.showName;
    if (_detailModel.createTime.length > 10) {
        _dateLabel.text = [[_detailModel.createTime substringToIndex:10] getIntervalToFXXTime];
    } else {
        _dateLabel.text = [_detailModel.createTime getIntervalToFXXTime];
    }
    _priceLabel.hidden = YES;
}

@end
