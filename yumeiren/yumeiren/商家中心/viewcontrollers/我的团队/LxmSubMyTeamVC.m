//
//  LxmSubMyTeamVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubMyTeamVC.h"
#import "LxmSeeOtherKuCunVC.h"
#import "LxmSeeOtherInfoVC.h"

@interface LxmSubMyTeamVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMyTeamListModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubMyTeamVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前的等级没有直属成员噢~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSubMyTeamCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubMyTeamCell"];
    if (!cell) {
        cell = [[LxmSubMyTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubMyTeamCell"];
    }
    cell.index = indexPath.row;
    cell.model = self.dataArr[indexPath.row];
    WeakObj(self);
    cell.seeKuCunBlock = ^(LxmMyTeamListModel *model) {
        [selfWeak pageToKuCun:model];
    };
    cell.seeOtherInfoBlock = ^(LxmMyTeamListModel *model) {
        [selfWeak seeOtherInfo:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/**
 查看别人库存
 */
- (void)pageToKuCun:(LxmMyTeamListModel *)model {
    LxmSeeOtherKuCunVC *vc = [[LxmSeeOtherKuCunVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 查看他人信息
 */
- (void)seeOtherInfo:(LxmMyTeamListModel *)model {
    LxmSeeOtherInfoVC *vc = [[LxmSeeOtherInfoVC alloc] init];
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
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"pageNum"] =  @(self.page);
        dict[@"pageSize"] = @10;
        dict[@"type"] = self.type;
        [LxmNetworking networkingPOST:group_count_list parameters:dict returnClass:LxmMyTeamListRootModel.class success:^(NSURLSessionDataTask *task, LxmMyTeamListRootModel *responseObject) {
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
                self.emptyView.textLabel.text = self.type.intValue == 1 ? @"您当前的等级没有直属成员噢~" : @"您当前的等级没有非直属成员噢~";
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

@interface LxmSubMyTeamCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *rankLabel;//市服务商

@property (nonatomic, strong) UILabel *codeLabel;//授权码

@property (nonatomic, strong) UIButton *recordButton;//库存

@property (nonatomic, strong) UILabel *recordLabel;//库存

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) UILabel *memberNumLabel;//成员

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmSubMyTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.numLabel];
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.rankLabel];
    [self addSubview:self.codeLabel];
    [self.contentView addSubview:self.recordButton];
    [self.recordButton addSubview:self.recordLabel];
    [self.recordButton addSubview:self.accImgView];
    [self addSubview:self.memberNumLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@10);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.headerImgView.mas_leading);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(40);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(3);
        make.centerY.equalTo(self.nameLabel);
        make.trailing.lessThanOrEqualTo(self.recordButton.mas_leading);
        make.height.equalTo(@13);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.trailing.lessThanOrEqualTo(self.memberNumLabel.mas_leading);
    }];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel);
        make.top.trailing.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.recordButton).offset(-15);
        make.bottom.equalTo(self.recordButton);
        make.width.height.equalTo(@15);
    }];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
        make.bottom.equalTo(self.recordButton);
    }];
    
    [self.memberNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.codeLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
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

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.textColor = CharacterDarkColor;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
        [_headerImgView addGestureRecognizer:tap];
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.font = [UIFont systemFontOfSize:10];
        _rankLabel.textColor = MainColor;
        _rankLabel.layer.cornerRadius = 3;
        _rankLabel.layer.borderWidth = 0.5;
        _rankLabel.layer.borderColor = MainColor.CGColor;
    }
    return _rankLabel;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        [_recordButton addTarget:self action:@selector(seeKuCunClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.font = [UIFont systemFontOfSize:13];
        _recordLabel.textColor = CharacterGrayColor;
        _recordLabel.text = @"查看库存";
    }
    return _recordLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"next"];
    }
    return _accImgView;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = [UIFont systemFontOfSize:13];
        _codeLabel.textColor = CharacterGrayColor;
    }
    return _codeLabel;
}

- (UILabel *)memberNumLabel {
    if (!_memberNumLabel) {
        _memberNumLabel = [[UILabel alloc] init];
        _memberNumLabel.font = [UIFont systemFontOfSize:12];
        _memberNumLabel.textColor = CharacterGrayColor;
    }
    return _memberNumLabel;
}

/**
 查看库存
 */
- (void)seeKuCunClick {
    if (self.seeKuCunBlock) {
        self.seeKuCunBlock(self.model);
    }
}

/**
 查看他人信息
 */
- (void)headerTap {
    if (self.seeOtherInfoBlock) {
        self.seeOtherInfoBlock(self.model);
    }
}

- (void)setIndex:(NSInteger)index {
    if (index == 0) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"1"];
        self.numLabel.hidden = YES;
    } else if (index == 1) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"2"];
        self.numLabel.hidden = YES;
    } else if (index == 2) {
        self.iconImgView.hidden = NO;
        self.iconImgView.image = [UIImage imageNamed:@"3"];
        self.numLabel.hidden = YES;
    } else {
        self.iconImgView.hidden = YES;
        self.numLabel.hidden = NO;
        self.numLabel.text = @(index + 1).stringValue;
    }
}

- (void)setModel:(LxmMyTeamListModel *)model {
    _model = model;
    self.nameLabel.text = _model.username;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    if ([_model.roleType isEqualToString:@"-0.5"]){
        self.rankLabel.text = @" 减肥单项-vip会员 ";
    } else if ([_model.roleType isEqualToString:@"-0.4"]) {
        self.rankLabel.text = @" 减肥单项-高级会员 ";
    } else if ([_model.roleType isEqualToString:@"-0.3"]) {
        self.rankLabel.text = @" 减肥单项-荣誉会员 ";
    } else if ([_model.roleType isEqualToString:@"1.1"]) {
        self.rankLabel.text = @" 减肥单项-市服务商 ";
    } else if ([_model.roleType isEqualToString:@"2.1"]) {
        self.rankLabel.text = @" 减肥单项-省服务商 ";
    } else if ([_model.roleType isEqualToString:@"3.1"]) {
        self.rankLabel.text = @" 减肥单项-CEO ";
    }  else {
        switch (_model.roleType.intValue) {
            case -1:
                self.rankLabel.text = @" 无身份 ";
                break;
            case 0:
                self.rankLabel.text = @" vip门店 ";
                break;
            case 1:
                self.rankLabel.text = @" 高级门店 ";
                break;
            case 2:
                self.rankLabel.text = @" 市服务商 ";
                break;
            case 3:
                self.rankLabel.text = @" 省服务商 ";
                break;
            case 4:
                self.rankLabel.text = @" CEO ";
                break;
                
            default:
                break;
        }
    }
    
    self.codeLabel.text = [NSString stringWithFormat:@"授权码: %@",_model.recommendCode];
    self.memberNumLabel.text = [NSString stringWithFormat:@"直属成员:%@",_model.firstN];
}

@end
