//
//  LxmSubBuHuoOrderVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubBuHuoOrderVC.h"
#import "LxmJieSuanView.h"
#import "LxmShopCarVC.h"
#import "LxmBuHuoDetailVC.h"
#import "LxmYiJianBuHuoVC1.h"

#import "LxmPayVC.h"

@interface LxmSubBuHuoOrderVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmShopCenterOrderModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubBuHuoOrderVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.textLabel.text = @"暂无订单哦~";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
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
    [LxmEventBus registerEvent:@"jiesuanSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    [LxmEventBus registerEvent:@"cancelSuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    [LxmEventBus registerEvent:@"yitijianbuhuotuidanshenqing" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    [LxmEventBus registerEvent:@"yijianjiesuan" block:^(id data) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].sub2.count + 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmSubBuHuoOrderTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderTopCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderTopCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 2) {
        LxmSubBuHuoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderPriceCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        return cell;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 1){
        LxmSubBuHuoOrderButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        if (!cell) {
            cell = [[LxmSubBuHuoOrderButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubBuHuoOrderButtonCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section];
        WeakObj(self);
        cell.tuidanBlock = ^{
            [selfWeak buttonTuiDanAction:selfWeak.dataArr[indexPath.section]];
        };
        cell.gotobuhuoBlock = ^{
            [selfWeak buttonAction:selfWeak.dataArr[indexPath.section]];
        };
        return cell;
    } else {
        LxmJieSuanPeiSongGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        if (!cell) {
            cell = [[LxmJieSuanPeiSongGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieSuanPeiSongGoodsCell"];
        }
        cell.orderModel = self.dataArr[indexPath.section].sub2[indexPath.row - 1];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShopCenterOrderModel *orderModel = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 2) {
        return 44;
    } else if(indexPath.row == self.dataArr[indexPath.section].sub2.count + 3 - 1) {
        if (orderModel.status.intValue == 9 || orderModel.status.intValue == 10 || orderModel.status.intValue == 12) {
            return 60;
        }
        return 0.001;
    } else {
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
    vc.orderID = self.dataArr[indexPath.section].id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 9-待补货，10-补货待支付
 */
- (void)buttonAction:(LxmShopCenterOrderModel *)model {
    if (model.status.intValue == 9) {
        LxmYiJianBuHuoVC1 *vc = [[LxmYiJianBuHuoVC1 alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.status.intValue == 10) {
        LxmPayVC *vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPayVC_type_yjbh];
        vc.creatTime = model.create_time;
        LxmBuHuoModel *m = [LxmBuHuoModel new];
        m.price = [NSString stringWithFormat:@"%lf",model.total_money.doubleValue];
        m.orderId = model.id;
        vc.buhuoModel = m;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.status.intValue == 12) {//删除已过期商品
        [self deleteModel:model];
    }
}

/**
 9-待补货，10-补货待支付
 */
- (void)buttonTuiDanAction:(LxmShopCenterOrderModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认退单" message:@"您确定要申请退单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self tuidan:model];
    }]];
    [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)tuidan:(LxmShopCenterOrderModel *)model {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:return_bu_order parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已提交退单申请!"];
            model.status = @"12";
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
12删除已过期订单
*/
- (void)deleteModel:(LxmShopCenterOrderModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认订单" message:@"您确定要删除已过期订单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteOrder:model];
    }]];
    [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)deleteOrder:(LxmShopCenterOrderModel *)model {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:log_del_order parameters:@{@"token":SESSION_TOKEN,@"id":model.id} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已删除"];
            [selfWeak.dataArr removeObject:model];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
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
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        dict[@"status"] = self.status;
        [LxmNetworking networkingPOST:back_order_list parameters:dict returnClass:LxmShopCenterOrderRootModel.class success:^(NSURLSessionDataTask *task, LxmShopCenterOrderRootModel *responseObject) {
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

@end


/**
 补货视图
 */
@interface LxmSubBuHuoOrderTopCell ()

@property (nonatomic, strong) UILabel *orderLabel;//订单号

@property (nonatomic, strong) UILabel *stateLabel;//订单状态

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmSubBuHuoOrderTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.orderLabel];
        [self addSubview:self.stateLabel];
        [self addSubview:self.lineView];
        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.font = [UIFont systemFontOfSize:12];
    }
    return _orderLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

/**
 商家中心 发货订单列表
 */
- (void)setOrderModel:(LxmShopCenterOrderModel *)ordeModel {
    _orderModel = ordeModel;
    _stateLabel.textColor = MainColor;
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderModel.order_code];
    switch (_orderModel.status.intValue) {
        case 1: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待支付";
        }
            break;
        case 2: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待发货";
        }
            break;
        case 3: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待收货";
        }
            break;
        case 4: {
            _stateLabel.textColor = CharacterGrayColor;
            _stateLabel.text = @"已完成";
        }
            break;
        case 5: {
            _stateLabel.textColor = CharacterGrayColor;
            _stateLabel.text = @"已取消";
        }
            break;
        case 7: {
            _stateLabel.textColor = CharacterGrayColor;
            _stateLabel.text = @"待自提";
        }
            break;
        case 8: {
            _stateLabel.textColor = CharacterGrayColor;
            _stateLabel.text = @"已自提";
        }
            break;
        case 9: {
           _stateLabel.textColor = MainColor;
           _stateLabel.text = @"待补货";
        }
            break;
        case 10: {
           _stateLabel.textColor = MainColor;
           _stateLabel.text = @"待支付";
        }
            break;
        case 11: {
           _stateLabel.textColor = CharacterGrayColor;
           _stateLabel.text = @"已完成";
        }
            break;
        case 12: {
           _stateLabel.textColor = CharacterGrayColor;
           _stateLabel.text = @"已过期";
        }
            break;
        default:
            break;
    }
}

@end

//LxmJieSuanPeiSongGoodsCell 商品cell

@interface LxmSubBuHuoOrderPriceCell ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *lineView1;//线

@end
@implementation LxmSubBuHuoOrderPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.lineView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.lineView1];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
       
    }
    return _priceLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (void)setOrderModel:(LxmShopCenterOrderModel *)orderModel {
    _orderModel = orderModel;
//    CGFloat f = 0;
//    for (LxmShopCenterOrderGoodsModel *m in _orderModel.sub2) {
//        f += m.proxy_price.floatValue;
//    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"商品总计： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",_orderModel.total_money.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    _priceLabel.attributedText = att;
}

//订单查询 详情
- (void)setShifujineMoney:(NSString *)shifujineMoney {
    _shifujineMoney = shifujineMoney;
    CGFloat f = _shifujineMoney.floatValue;
    NSInteger d = _shifujineMoney.integerValue;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.isDaiBuHuo ? @"待补货金额： " : @"实付金额： " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString: d==f ? [NSString stringWithFormat:@"¥%ld",d] : [NSString stringWithFormat:@"¥%.2f",f] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:MainColor}];
    [att appendAttributedString:str];
    _priceLabel.attributedText = att;
}


@end


@interface LxmSubBuHuoOrderButtonCell ()

@property (nonatomic, strong) UIButton *buhuoButton;

@end
@implementation LxmSubBuHuoOrderButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.buhuoButton];
        [self addSubview:self.leftButton];
        [self.buhuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.buhuoButton.mas_leading).offset(-15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
    }
    return self;
}

- (UIButton *)buhuoButton {
    if (!_buhuoButton) {
        _buhuoButton = [UIButton new];
        [_buhuoButton setTitle:@"去补货" forState:UIControlStateNormal];
        [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
        _buhuoButton.layer.borderColor = MainColor.CGColor;
        _buhuoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _buhuoButton.layer.cornerRadius = 15;
        _buhuoButton.layer.borderWidth = 0.5;
        _buhuoButton.layer.masksToBounds = YES;
        [_buhuoButton addTarget:self action:@selector(buhuoclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buhuoButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setTitle:@"申请退单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _leftButton.layer.borderColor = CharacterGrayColor.CGColor;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _leftButton.layer.cornerRadius = 15;
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.masksToBounds = YES;
        _leftButton.hidden = YES;
         [_leftButton addTarget:self action:@selector(tuidanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (void)tuidanClick {
    if (self.tuidanBlock) {
        self.tuidanBlock();
    }
}

- (void)buhuoclick {
    if (self.gotobuhuoBlock) {
        self.gotobuhuoBlock();
    }
}

- (void)setOrderModel:(LxmShopCenterOrderModel *)orderModel {
    _orderModel = orderModel;
    switch (_orderModel.status.intValue) {
        case 1: {//待支付
            _leftButton.hidden = NO;
            [_buhuoButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 2: {//待发货
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"申请退单" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = CharacterGrayColor.CGColor;
        }
            break;
        case 3: {//待补货
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 7: {//待自提
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"确认自提" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 8: {//已自提
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"已自提" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 9: {//待补货
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"去补货" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 10: {//补货待支付
            _leftButton.hidden = NO;
            [_buhuoButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:MainColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = MainColor.CGColor;
        }
            break;
        case 12: {//已过期
            _leftButton.hidden = YES;
            [_buhuoButton setTitle:@"删除" forState:UIControlStateNormal];
            [_buhuoButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
            _buhuoButton.layer.borderColor = CharacterGrayColor.CGColor;
        }
            break;
            
        default:
            break;
    }
}

@end
