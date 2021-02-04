//
//  LxmTuanDuiSearchVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/24.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTuanDuiSearchVC.h"
#import "LxmSearchView.h"
#import "LxmSeeOtherKuCunVC.h"

@interface LxmTuanDuiSearchVC ()<UITextFieldDelegate>

@property (nonatomic, strong) LxmSearchPageView *serachView;//搜索栏

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmMyTeamListModel *>*dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) NSString *searchStr;//搜索关键字

@end

@implementation LxmTuanDuiSearchVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (LxmSearchPageView *)serachView {
    if (!_serachView) {
        _serachView = [[LxmSearchPageView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 30, 30)];
        _serachView.searchTF.placeholder = @"请输入姓名,授权码搜索";
        _serachView.searchTF.returnKeyType = UIReturnKeySearch;
        _serachView.searchTF.delegate = self;
    }
    return _serachView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.serachView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serachView.mas_bottom).offset(15);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
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
    LxmTuanDuiSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTuanDuiSearchCell"];
    if (!cell) {
        cell = [[LxmTuanDuiSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTuanDuiSearchCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    WeakObj(self);
    cell.seeKuCunBlock = ^(LxmMyTeamListModel *model) {
        [selfWeak pageToKuCun:model];
    };
    return cell;
}

/**
 查看别人库存
 */
- (void)pageToKuCun:(LxmMyTeamListModel *)model {
    LxmSeeOtherKuCunVC *vc = [[LxmSeeOtherKuCunVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    if (!textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名,授权码搜索"];
        return NO;
    }
    self.searchStr = textField.text;
    self.page = 1;
    self.allPageNum = 1;
    [self loadData];
    return YES;
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
        if (self.searchStr) {
            dict[@"username"] = self.searchStr;
        }
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

@interface LxmTuanDuiSearchCell ()

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

@implementation LxmTuanDuiSearchCell

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
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
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
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

/**
 查看库存
 */
- (void)seeKuCunClick {
    if (self.seeKuCunBlock) {
        self.seeKuCunBlock(self.model);
    }
}

- (void)setModel:(LxmMyTeamListModel *)model {
    _model = model;
    self.nameLabel.text = _model.username;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    NSArray<YMRRoleTypeModel *> *roleArr = [YMRRoleTypeModel mj_objectArrayWithKeyValuesArray:[LxmTool ShareTool].roleTypeNameList];
    for (YMRRoleTypeModel * rModel in roleArr) {
        if ([_model.roleType isEqualToString: rModel.role]) {
            self.rankLabel.text = [NSString stringWithFormat:@" %@ ",rModel.name];
            break;
        }
    }
    
//    if ([_model.roleType isEqualToString:@"-0.3"]){
//        self.rankLabel.text = @" 小红包系列-荣誉会员 ";
//    } else if ([_model.roleType isEqualToString:@"-0.4"]) {
//        self.rankLabel.text = @" 小红包系列-高级会员 ";
//    } else if ([_model.roleType isEqualToString:@"-0.5"]) {
//        self.rankLabel.text = @" 小红包系列-vip会员 ";
//    } else if ([_model.roleType isEqualToString:@"1.1"]) {
//        self.rankLabel.text = @" 小红包系列-市服务商 ";
//    } else if ([_model.roleType isEqualToString:@"2.1"]) {
//        self.rankLabel.text = @" 小红包系列-省服务商 ";
//    } else if ([_model.roleType isEqualToString:@"3.1"]) {
//        self.rankLabel.text = @" 小红包系列-CEO ";
//    } else {
//        switch (_model.roleType.intValue) {
//            case -1:
//                self.rankLabel.text = @" 无身份 ";
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
    
    if (model.suType.intValue == 1) {
        NSAttributedString *messageTextStr = [[NSAttributedString alloc] initWithString:messageText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MainColor}];
        [messageStr appendAttributedString:messageTextStr];
    
        if (messageText.length >1) {
            [messageStr insertAttributedString:messageImageStr atIndex:1];
        }else {
            [messageStr insertAttributedString:messageImageStr atIndex:0];
        }
        
        _rankLabel.attributedText = messageStr;
    }
    
    self.codeLabel.text = [NSString stringWithFormat:@"授权码: %@",_model.recommendCode];
    self.memberNumLabel.text = [NSString stringWithFormat:@"直属成员:%@",_model.firstN];
}


@end
