//
//  LxmNotifyMessageVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/25.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmNotifyMessageVC.h"
#import "LxmQianBaoMessageVC.h"
#import "LxmDingDanMessageVC.h"

@interface LxmNotifyMessageVC ()

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) LxmNoticeRootModel *rootModel;

@end

@implementation LxmNotifyMessageVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
    [self loadMsgHomeData];
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
    return self.rootModel.result.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmNotifyMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNotifyMessageCell"];
    if (!cell) {
        cell = [[LxmNotifyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNotifyMessageCell"];
    }
    cell.model = self.rootModel.result.list[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmNoticeIndexModel *model = self.rootModel.result.list[indexPath.row];
    if (model.info_type.intValue == 5) {
        LxmDingDanMessageVC *vc = [[LxmDingDanMessageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LxmQianBaoMessageVC *vc = [[LxmQianBaoMessageVC alloc] init];
        vc.infoType = model.info_type;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

/**
 消息首页
 */
- (void)loadMsgHomeData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:shop_notice_index parameters:@{@"token":SESSION_TOKEN} returnClass:LxmNoticeRootModel.class success:^(NSURLSessionDataTask *task, LxmNoticeRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.rootModel = responseObject;
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end

@interface LxmNotifyMessageCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *detaillabel;//详情信息

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LxmNotifyMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self initSubviews];
        [self setContrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.detaillabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setContrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@40);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = CharacterLightGrayColor;
    }
    return _timeLabel;
}

- (UILabel *)detaillabel {
    if (!_detaillabel) {
        _detaillabel = [[UILabel alloc] init];
        _detaillabel.textColor = CharacterDarkColor;
        _detaillabel.font = [UIFont systemFontOfSize:13];
    }
    return _detaillabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmNoticeIndexModel *)model {
    _model = model;
    if (_model.create_time.length > 10) {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[[_model.create_time substringToIndex:10] getIntervalToZHXTime]];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[_model.create_time getIntervalToZHXTime]];
    }
    self.detaillabel.text = _model.title;
    //1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
    switch (_model.info_type.intValue) {
        case 1: {
            _iconImgView.image = [UIImage imageNamed:@"xitongxiaoxi"];
            _titleLabel.text = @"系统通知";
        }
            break;
        case 2: {
            _iconImgView.image = [UIImage imageNamed:@"dailibiandong"];
            _titleLabel.text = @"代理变动";
        }
            break;
        case 3: {
            _iconImgView.image = [UIImage imageNamed:@"qianbaoxiaoxi"];
            _titleLabel.text = @"钱包消息";
        }
            break;
        case 4: {
            _iconImgView.image = [UIImage imageNamed:@"jiedanxiaoxi"];
            _titleLabel.text = @"接单消息";
        }
            break;
        case 5: {
            _iconImgView.image = [UIImage imageNamed:@"bhdd"];
            _titleLabel.text = @"订单消息";
        }
            break;
        case 6: {
            _iconImgView.image = [UIImage imageNamed:@"tousuxiaoxi"];
            _titleLabel.text = @"投诉消息";
        }
            break;
        case 7: {
            _iconImgView.image = [UIImage imageNamed:@"sucaixiaoxi"];
            _titleLabel.text = @"素材消息";
        }
            break;
            
        default:
            break;
    }
}

@end
