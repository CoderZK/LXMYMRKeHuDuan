//
//  LxmJiedanMyPublishVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJiedanMyPublishVC.h"
#import "LxmJieDanImageCollectionViewCell.h"
#import "LxmJiaJiaAlertView.h"
#import "LxmJieDanMyPublishDetailVC.h"
#import "LxmPayVC.h"

@interface LxmJiedanMyPublishVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJieDanListModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmJiedanMyPublishVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂无发布单子哦~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单平台";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    /* 已提交退单 */
    [LxmEventBus registerEvent:@"tijiaotuidansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    /* 详情操作 */
    [LxmEventBus registerEvent:@"detailAction" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
     /* 加价回调 */
    [LxmEventBus registerEvent:@"jiesuanSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
     /* 发单成功 */
    [LxmEventBus registerEvent:@"danzifabusuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {//订单编号
        LxmJieDanOrderBianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderBianHaoCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderBianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderBianHaoCell"];
        }
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1) {//服务类型 + money
        LxmJieDanOrderServiceTypeAndMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderServiceTypeAndMoneyCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderServiceTypeAndMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderServiceTypeAndMoneyCell"];
        }
        cell.model = model;
        return cell;
    } else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6){
        LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
        }
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"时间区间:";
            if (model.beginTime.length > 10) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[[model.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[model.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
            } else {
                 cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[model.beginTime getIntervalToFXXTNoHHmmime],[model.endTime getIntervalToFXXTNoHHmmime]];
            }
        } else if (indexPath.row == 3) {
            cell.titleLabel.text = @"服务时间:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@天",model.serviceDay];
        } else if (indexPath.row == 4) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.addressDetail];
            cell.titleLabel.text = @"服务地址:";
            cell.detailLabel.text = str;
        } else {
            cell.titleLabel.text = @"打分结果:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@分",model.score];
        }
        return cell;
    } else if (indexPath.row == 5){
        LxmJieDanMyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyCenterCell"];
        if (!cell) {
            cell = [[LxmJieDanMyCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyCenterCell"];
        }
        cell.model = model;
        return cell;
    } else if (indexPath.row == 7){
        LxmJieDanRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanRenCell"];
        if (!cell) {
            cell = [[LxmJieDanRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanRenCell"];
        }
        cell.model = model;
        return cell;
    } else {
        LxmJieDanMyBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyBottomCell"];
        if (!cell) {
            cell = [[LxmJieDanMyBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyBottomCell"];
        }
        cell.model = model;
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
        return 40;
    } else if (indexPath.row == 1) {
        return 30;
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
    } else if (indexPath.row == 5) {
        if (model.judgePic.isValid) {//待打分 已评价
            NSArray *temp = [model.judgePic componentsSeparatedByString:@","];
            CGFloat width = floor((ScreenW - 110 - 10) / 3.0);
            CGFloat hhh = ceil(temp.count/3.0);
            return width * hhh + 15;
        } else {
            return 0.01;
        }
    } else if (indexPath.row == 6) {
        if (model.score.isValid && model.score.intValue != 0) {
            CGFloat h = [[model.score stringByAppendingString:@"分"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
            return h;
        }
        return 0.01;
    }  else if (indexPath.row == 7) {
        // 1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        if (model.status.intValue == 3 || model.status.intValue == 4 || model.status.intValue == 5 || model.status.intValue == 6 ||  model.status.intValue == 7 ||  model.status.intValue == 8 ) {
            if (model.showHead.isValid) {
                return 80;
            } else {
              return 0.01;
            }
            
        } else {
            return 0.01;
        }
    } else {
        if (model.status.intValue == 1 || model.status.intValue == 2 || model.status.intValue == 4 || model.status.intValue == 5 ) {
            return 50;
        }
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    LxmJieDanMyPublishDetailVC *vc = [[LxmJieDanMyPublishDetailVC alloc] init];
    vc.model = model;
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
        [LxmNetworking networkingPOST:service_list parameters:@{@"token":SESSION_TOKEN,@"type":@1,@"pageNum" : @(self.page)} returnClass:LxmJieDanListRootModel.class success:^(NSURLSessionDataTask *task, LxmJieDanListRootModel *responseObject) {
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

/**
 底部按钮操作

 @param index //222左 333右
 @param model 当前实例
 */
- (void)bottomActionIndex:(NSInteger)index currentModel:(LxmJieDanListModel *)model {
    switch (model.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {//去支付
            LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_wfbd];
            vc.wfbdID = model.id;
            vc.wfbdMoney = model.servicePrice;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            if (index == 222) {//申请撤单
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认撤单" message:@"您确定要撤单吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   [self shenqingchedan:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
            } else {//加价
                [self jiajia:model];
            }
        }
            break;
        case 3: {//待完成 没有底部按钮
            
        }
            break;
        case 4: {//处理退单
           [self chulituidan:model];
        }
            break;
        case 5: {//去打分
            [self dafen:model];
        }
            break;
            
        default:
            break;
    }
}

/**
 加价
 */
- (void)jiajia:(LxmJieDanListModel *)model {
    LxmJiaJiaAlertView *alertView = [[LxmJiaJiaAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds type:LxmJiaJiaAlertView_type_jiajia];
    WeakObj(self);
    alertView.jiajiaBlock = ^(NSString *price) {
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_jiajia];
        vc.jiajiaModel = model;
        vc.jiajiaPrice = price;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    [alertView show];
}

/**
 申请撤单
 */
- (void)shenqingchedan:(LxmJieDanListModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:cancel_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"撤单申请已提交!"];
            [LxmEventBus sendEvent:@"chedansuccess" data:nil];
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
    
}

- (void)dafen:(LxmJieDanListModel *)model {
    LxmJiaJiaAlertView *alertView = [[LxmJiaJiaAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds type:LxmJiaJiaAlertView_type_dafen];
    WeakObj(self);
    alertView.jiajiaBlock = ^(NSString *price) {//分数
        [selfWeak dafenRequest:model price:price];
    };
    [alertView show];
}

/**
 打分
 */
- (void)dafenRequest:(LxmJieDanListModel *)model price:(NSString *)price {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    dict[@"score"] = price;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:score_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"打分已提交!"];
            [LxmEventBus sendEvent:@"chedansuccess" data:nil];
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
}

/**
 处理退单
 */
- (void)chulituidan:(LxmJieDanListModel *)model {
    WeakObj(self);
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"退单" message:@"您是否同意退单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak chulituidan:model state:@3];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak chulituidan:model state:@7];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)chulituidan:(LxmJieDanListModel *)model state:(NSNumber *)status {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] = model.id;
    dict[@"status"] = status;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:verify_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:status.intValue == 3 ? @"已拒绝!" : @"退单成功!"];
            [LxmEventBus sendEvent:@"chedansuccess" data:nil];
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
}


@end

/**
 订单编号
 */
@interface LxmJieDanOrderBianHaoCell ()

@property (nonatomic, strong) UILabel *bianhaoLabel;//投诉编号

@property (nonatomic, strong) UILabel *stateLabel;//处理状态

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmJieDanOrderBianHaoCell

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
    [self addSubview:self.bianhaoLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bianhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.trailing.lessThanOrEqualTo(self.stateLabel.mas_leading);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)bianhaoLabel {
    if (!_bianhaoLabel) {
        _bianhaoLabel = [UILabel new];
        _bianhaoLabel.font = [UIFont systemFontOfSize:13];
        _bianhaoLabel.textColor = CharacterDarkColor;
    }
    return _bianhaoLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.textColor = MainColor;
    }
    return _stateLabel;
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    _bianhaoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_model.orderCode];
    switch (_model.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {
            _stateLabel.text = @"待支付";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 2: {
            _stateLabel.text = @"待接单";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 3: {
            _stateLabel.text = @"待完成";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 4:  {
            _stateLabel.text = @"待退单";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 5:  {
            _stateLabel.text = @"待打分";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 6: {
             _stateLabel.text = @"已完成";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 7: {
            _stateLabel.text = @"已退单";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 8: {
            _stateLabel.text = @"已失效";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
            
        default:
            break;
    }
}

- (void)setJieshouModel:(LxmJieDanListModel *)jieshouModel {
    _jieshouModel = jieshouModel;
    _bianhaoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_jieshouModel.orderCode];
    switch (_jieshouModel.status.intValue) {
    //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待支付";
        }
            break;
        case 2: {
            _stateLabel.text = @"待接单";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 3: {
            if (_jieshouModel.backCommend.isValid) {
                _stateLabel.text = @"退单被驳回";
            } else {
                _stateLabel.text = @"已接单";
            }
            _stateLabel.textColor = MainColor;
        }
            break;
        case 4: {
           _stateLabel.text = @"退单待审核";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 5: {
            _stateLabel.text = @"待打分";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 6: {
            _stateLabel.text = @"已完成";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 7: {
            _stateLabel.text = @"已退单";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 8: {
            _stateLabel.text = @"已失效";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
            
        default:
            break;
    }
}

@end

/**
 服务类型加右测时间
 */
@interface LxmJieDanOrderServiceTypeAndMoneyCell ()

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation LxmJieDanOrderServiceTypeAndMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.typeLabel];
    [self addSubview:self.priceLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(5);
    }];
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = UILabel.new;
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textColor = CharacterDarkColor;
    }
    return _typeLabel;
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
    _typeLabel.text = [NSString stringWithFormat:@"服务类型：%@",_model.serviceTypeName];
    CGFloat f = _model.servicePrice.doubleValue + _model.addPrice.doubleValue;
    NSInteger d = _model.servicePrice.integerValue + _model.addPrice.integerValue;
    if (f == d) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%ld",d];
    } else {
      _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
    }
}

- (void)setJiedanModel:(LxmJieDanListModel *)jiedanModel {
    _jiedanModel = jiedanModel;
    _priceLabel.hidden = YES;
    _typeLabel.text = [NSString stringWithFormat:@"服务类型：%@",_jiedanModel.serviceTypeName];
    [_typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(75);
    }];
    [self layoutIfNeeded];
}

- (void)setDetailModel:(LxmJieDanListModel *)detailModel {
    _detailModel = detailModel;
    _typeLabel.text = [NSString stringWithFormat:@"服务类型：%@",_detailModel.serviceTypeName];
    if (_detailModel.status.intValue == 2 && _detailModel.addPrice.doubleValue != 0) {
        //待接单 且已加价
        CGFloat f = _detailModel.servicePrice.doubleValue ;
        NSInteger d = _detailModel.servicePrice.integerValue;
        if (f == d) {
            _priceLabel.text = [NSString stringWithFormat:@"￥%ld",d];
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
        }
    } else {
        CGFloat f = _detailModel.servicePrice.doubleValue + _detailModel.addPrice.doubleValue;
        NSInteger d = _detailModel.servicePrice.integerValue + _detailModel.addPrice.integerValue;
        if (f == d) {
            _priceLabel.text = [NSString stringWithFormat:@"￥%ld",d];
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",f];
        }
    }
}

@end


/**
 只有一个label
 */
@interface LxmJieDanOrderLabelCell()

@end

@implementation LxmJieDanOrderLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.leading.equalTo(self).offset(15);
            make.width.equalTo(@80);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(10);
        }];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

-(void)setJieshouModel:(LxmJieDanListModel *)jieshouModel {
    _jieshouModel = jieshouModel;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(75);
    }];
    [self layoutIfNeeded];
}

- (void)setDetailModel:(LxmJieDanListModel *)detailModel {
    _detailModel = detailModel;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@80);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing);
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
}

@end



@interface LxmJieDanMyCenterCell() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *>*imgs;
@end

@implementation LxmJieDanMyCenterCell

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
    [self addSubview:self.nameLabel];
    [self addSubview:self.collectionView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self);
        make.height.equalTo(@24);
        make.width.equalTo(@95);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing);
        make.trailing.bottom.equalTo(self);
        make.top.equalTo(self).offset(5);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmJieDanImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgs[indexPath.item]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floor((collectionView.bounds.size.width - 15 - 10) / 3.0);
    return CGSizeMake(width, width);
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"评  价  单：";
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 15);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:LxmJieDanImageCollectionViewCell.class forCellWithReuseIdentifier:@"LxmJieDanImageCollectionViewCell"];
    }
    return _collectionView;
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    self.imgs = [_model.judgePic componentsSeparatedByString:@","];
    [self.collectionView reloadData];
}

@end

/**
 接单人cell
 */
@interface LxmJieDanRenCell ()

@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmJieDanRenCell

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
    [self addSubview:self.lineView];
    [self addSubview:self.lineView1];
    
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
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@0.5);
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = UIView.new;
        _lineView1.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    }
    return _lineView1;
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.showHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    _nameLabel.text = _model.showName;
    if (_model.takeTime.length > 10) {
        _dateLabel.text = [[_model.takeTime substringToIndex:10] getIntervalToFXXTime];
    } else {
        _dateLabel.text = [_model.takeTime getIntervalToFXXTime];
    }
}

@end

/**
 button
 */
@interface LxmJieDanMyBottomCell()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmJieDanMyBottomCell

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
    [self addSubview:self.lineView];
    [self addSubview:self.button];
    [self addSubview:self.button1];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@28);
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@28);
        make.trailing.equalTo(self.button.mas_leading).offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)button {
    if (!_button) {
        _button = UIButton.new;
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setTitleColor:MainColor forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_bk"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = UIButton.new;
        _button1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button1 setTitleColor:MainColor forState:UIControlStateNormal];
        [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_bk"] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    switch (_model.status.intValue) {
            //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 1: {
            _button1.hidden = YES;
            [_button setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 2: {
            _button1.hidden = NO;
            [_button setTitle:@"加价" forState:UIControlStateNormal];
            [_button1 setTitle:@"申请撤单" forState:UIControlStateNormal];
        }
            break;
        case 3: {//待完成 没有底部按钮
            
        }
            break;
        case 4: {
            _button1.hidden = YES;
            [_button setTitle:@"处理退单" forState:UIControlStateNormal];
        }
            break;
        case 5: {
            _button1.hidden = YES;
            [_button setTitle:@"去打分" forState:UIControlStateNormal];
        }
            break;
        case 6: {//已评价 已完成 没有底部按钮
            
        }
            break;
        case 7: {//已退单 没有底部按钮
            
        }
            break;
        case 8: {//已失效 没有底部按钮
            
        }
            break;
            
        default:
            break;
    }
}
/**
 我接受的单子 model
 */
- (void)setJieshouModel:(LxmJieDanListModel *)jieshouModel {
    _jieshouModel = jieshouModel;
    switch (_jieshouModel.status.intValue) {
    //1：待支付，2：待接单，3：待完成，4：申请退单中，5：已完成待评价，6：已评价，7：已退单，8：已失效
        case 3: {
            if ([_jieshouModel.backCommend isValid]) {//退单被驳回
                [_button1 setTitle:@"申诉" forState:UIControlStateNormal];
                [_button setTitle:@"上传评价单" forState:UIControlStateNormal];
            } else {//已接单
                [_button1 setTitle:@"申请撤单" forState:UIControlStateNormal];
                [_button setTitle:@"上传评价单" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}


/**
 接单大厅 接单model
 */
- (void)setJiedanModel:(LxmJieDanListModel *)jiedanModel {
    _jiedanModel = jiedanModel;
    _button1.hidden = YES;
    [_button setTitle:@"接单" forState:UIControlStateNormal];
}

/**
 底部按钮操作
 */
- (void)btnClick:(UIButton *)btn {
    
    NSInteger index;
    if (btn == _button) {//右侧按钮
        index = 333;
    } else {//左侧按钮
        index = 222;
    }
    if ([btn.titleLabel.text isEqualToString:@"接单"]) {
        if (self.bottomButtonActionBlock) {
            self.bottomButtonActionBlock(333,self.jiedanModel);
        }
    } else {
        if (self.jieshouModel) {
            if (self.bottomButtonActionBlock) {
                self.bottomButtonActionBlock(index,self.jieshouModel);
            }
        } else {
            if (self.bottomButtonActionBlock) {
                self.bottomButtonActionBlock(index,self.model);
            }
        }
    }
   
}

@end
