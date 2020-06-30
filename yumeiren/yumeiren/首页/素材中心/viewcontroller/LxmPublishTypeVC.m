//
//  LxmPublishTypeVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPublishTypeVC.h"


@interface LxmPublishTypeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) UIImageView *duihaoImgView;//对号

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmPublishTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.duihaoImgView];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.duihaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.height.width.equalTo(@15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIImageView *)duihaoImgView {
    if (!_duihaoImgView) {
        _duihaoImgView = [[UIImageView alloc] init];
        _duihaoImgView.image = [UIImage imageNamed:@"xuanzhong_y"];
    }
    return _duihaoImgView;
}

@end


@interface LxmPublishTypeVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmSuCaiContentTypeRootModel *model;

@end

@implementation LxmPublishTypeVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布内容分类";
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    [self loadListData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.result.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmPublishTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPublishTypeCell"];
    if (!cell) {
        cell = [[LxmPublishTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPublishTypeCell"];
    }
    cell.titleLabel.text = self.model.result.list[indexPath.row].title;
    cell.duihaoImgView.image = self.model.result.list[indexPath.row].isSelected ? [UIImage imageNamed:@"xuanzhong_y"] : [UIImage imageNamed:@"xuanzhong_n" ];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    if (self.contentTypeSelectBlock) {
        self.contentTypeSelectBlock(self.model.result.list[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 获取数据
 */
- (void)loadListData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:judge_type_list parameters:nil returnClass:LxmSuCaiContentTypeRootModel.class success:^(NSURLSessionDataTask *task, LxmSuCaiContentTypeRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            selfWeak.model = responseObject;
            if (selfWeak.contentID) {
                for (LxmSuCaiContentTypeListModel *m in self.model.result.list) {
                    if (m.id.integerValue == selfWeak.contentID.integerValue) {
                        m.isSelected = YES;
                    } else {
                        m.isSelected = NO;
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
