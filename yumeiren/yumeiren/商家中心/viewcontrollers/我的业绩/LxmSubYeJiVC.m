//
//  LxmSubYeJiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSubYeJiVC.h"

@interface LxmSubYeJiVC ()

@property (nonatomic, strong) NSMutableArray <LxmMyYeJiListModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmSubYeJiVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前的等级!";
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
    LxmYeJiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYeJiCell"];
    if (!cell) {
        cell = [[LxmYeJiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYeJiCell"];
    }
    cell.index = indexPath.row;
    cell.yejiModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/**
 请求数据
 */
- (void)loadData {
    if (self.dataArr.count <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] =  @(self.page);
    dict[@"pageSize"] = @10;
    dict[@"type"] = self.type;//1-团队业绩，2-推荐业绩
    dict[@"month"] = self.currentTime;
    WeakObj(self);
    [LxmNetworking networkingPOST:sale_count_list parameters:dict returnClass:LxmMyYeJiListRootModel.class success:^(NSURLSessionDataTask *task, LxmMyYeJiListRootModel *responseObject) {
        StrongObj(self);
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            self.page ++;
            
            self.emptyView.textLabel.text = self.type.intValue == 1 ? @"您暂时没有团队成员" : @"您暂时没有推荐成员";
            self.emptyView.hidden = self.dataArr.count > 0;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}



@end

@interface LxmYeJiCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *rankLabel;//市服务商

@property (nonatomic, strong) UILabel *moneyLabel;//

@property (nonatomic, strong) UILabel *moneyLabel1;//

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmYeJiCell

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
    [self addSubview:self.moneyLabel];
    [self addSubview:self.moneyLabel1];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
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
        make.trailing.lessThanOrEqualTo(self.moneyLabel.mas_leading);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.trailing.lessThanOrEqualTo(self.moneyLabel1.mas_leading);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.moneyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.rankLabel);
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
        //        _headerImgView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
        //        [_headerImgView addGestureRecognizer:tap];
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

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        _moneyLabel.textColor = MainColor;
    }
    return _moneyLabel;
}

- (UILabel *)moneyLabel1 {
    if (!_moneyLabel1) {
        _moneyLabel1 = [UILabel new];
        _moneyLabel1.font = [UIFont systemFontOfSize:10];
        _moneyLabel1.textColor = CharacterGrayColor;
    }
    return _moneyLabel1;
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

- (void)setYejiModel:(LxmMyYeJiListModel *)yejiModel {
    _yejiModel = yejiModel;
    self.nameLabel.text = _yejiModel.username;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_yejiModel.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    NSArray<YMRRoleTypeModel *> *roleArr = [YMRRoleTypeModel mj_objectArrayWithKeyValuesArray:[LxmTool ShareTool].roleTypeNameList];
    for (YMRRoleTypeModel * rModel in roleArr) {
        if ([_yejiModel.roleType isEqualToString: rModel.role]) {
            self.rankLabel.text = [NSString stringWithFormat:@" %@ ",rModel.name];
            break;
        }
    }
    
//    if ([_yejiModel.roleType isEqualToString:@"-0.5"]){
//        self.rankLabel.text = @" 小红包系列-vip会员 ";
//    } else if ([_yejiModel.roleType isEqualToString:@"-0.4"]) {
//        self.rankLabel.text = @" 小红包系列-高级会员 ";
//    } else if ([_yejiModel.roleType isEqualToString:@"-0.3"]) {
//        self.rankLabel.text = @" 小红包系列-荣誉会员 ";
//    } else if ([_yejiModel.roleType isEqualToString:@"1.1"]) {
//        self.rankLabel.text = @" 小红包系列-市服务商 ";
//    } else if ([_yejiModel.roleType isEqualToString:@"2.1"]) {
//        self.rankLabel.text = @" 小红包系列-省服务商 ";
//    } else if ([_yejiModel.roleType isEqualToString:@"3.1"]) {
//        self.rankLabel.text = @" 小红包系列-CEO";
//    } else {
//        switch (_yejiModel.roleType.intValue) {
//            case -1:
//                self.rankLabel.text = @" 无 ";
//                break;
//            case 0:
//                self.rankLabel.text = @" vip门店 ";
//                break;
//            case 1:
//                self.rankLabel.text = @" 高级门店 ";
//                break;
//            case 2:
//                self.rankLabel.text = @" 市服务商 ";
//                break;
//            case 3:
//                self.rankLabel.text = @" 省服务商 ";
//                break;
//            case 4:
//                self.rankLabel.text = @" CEO ";
//                break;
//            case 5:
//                self.rankLabel.text = @" 总经销商 ";
//                break;
//            default:
//                break;
//        }
//    }
    
    
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] init];
        
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *messageAttach = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        messageAttach.image = [UIImage imageNamed:@"ss"];
        messageAttach.bounds = CGRectMake(0, -2.5, 15, 15);
        //创建带有图片的富文本
        NSAttributedString *messageImageStr = [NSAttributedString attributedStringWithAttachment:messageAttach];
//         [messageStr appendAttributedString:messageImageStr];
        
        //富文本中的文字
       NSString *messageText = _rankLabel.text;
    
    if (yejiModel.suType.intValue == 1) {
        NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
        [messageStr appendAttributedString:messageTextStr];
    
        if (messageText.length >1) {
            [messageStr insertAttributedString:messageImageStr atIndex:1];
        }else {
            [messageStr insertAttributedString:messageImageStr atIndex:0];
        }
        
        _rankLabel.attributedText = messageStr;
    }
    
    CGFloat f = _yejiModel.saleM.doubleValue;
    NSInteger d = _yejiModel.saleM.integerValue;
    
    CGFloat f1 = _yejiModel.targetM.doubleValue;
    NSInteger d1 = _yejiModel.targetM.integerValue;
    
    self.moneyLabel.text = d==f ? [NSString stringWithFormat:@"¥%ld",d]:[NSString stringWithFormat:@"¥%.2f",f];
    self.moneyLabel1.text =  d1==f1 ? [NSString stringWithFormat:@"¥%ld",d1]:[NSString stringWithFormat:@"¥%.2f",f1];
}

@end
