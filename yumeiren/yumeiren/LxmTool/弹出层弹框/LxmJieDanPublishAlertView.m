//
//  LxmJieDanPublishAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/1.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanPublishAlertView.h"

@interface LxmJieDanPublishCell ()

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmJieDanPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmJieDanPublishAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) UILabel *textLabel;//选择服务类型

@property (nonatomic, strong) UIButton *sureButton;//确定

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LxmJieDanPublishRootModel *model;

@end

@implementation LxmJieDanPublishAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        [self addSubview:self.contentView];
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains {
//    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.textLabel];
//    [self.contentView addSubview:self.sureButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.tableView];
//    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.equalTo(self.contentView);
//        make.trailing.equalTo(self.textLabel.mas_leading);
//        make.height.equalTo(@40);
//    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
//    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.trailing.equalTo(self.contentView);
//        make.leading.equalTo(self.textLabel.mas_trailing);
//        make.height.equalTo(@40);
//    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.trailing.leading.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-TableViewBottomSpace);
    }];
}

/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200 + TableViewBottomSpace)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW*0.5-50, 40)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:MainColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW*0.5-50, 0, 100, 40)];
        _textLabel.text = @"选择服务类型";
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5 + 50, 0, ScreenW*0.5-50, 40)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:MainColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _sureButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        _sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.result.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanPublishCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanPublishCell"];
    if (!cell) {
        cell = [[LxmJieDanPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanPublishCell"];
    }
    cell.titleLabel.text = self.model.result.list[indexPath.row].typeName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectTypeBlock) {
        self.selectTypeBlock(self.model.result.list[indexPath.row]);
    }
    [self dismiss];
}


- (void)show {
    [self loadData];
    WeakObj(self);
    self.alpha = 1;
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.bounds.size.height;
        selfWeak.contentView.frame = rect;
        [selfWeak layoutIfNeeded];
    }];
}

- (void)dismiss {
    WeakObj(self);
    [UIView animateWithDuration:0.225 animations:^{
        self.alpha = 0;
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height;
        selfWeak.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
    }];
}

/**
 加载数据
 */
- (void)loadData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:service_type_list parameters:nil returnClass:LxmJieDanPublishRootModel.class success:^(NSURLSessionDataTask *task, LxmJieDanPublishRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            self.model = responseObject;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
