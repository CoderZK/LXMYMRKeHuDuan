//
//  LxmTouSuView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTouSuView.h"

@implementation LxmTouSuView

@end

@interface LxmTouSuListCell()

@property (nonatomic, strong) UIView *bgView;//背景

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *bianhaoLabel;//投诉编号

@property (nonatomic, strong) UILabel *stateLabel;//处理状态

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *detailLabel;//详情

@end

@implementation LxmTouSuListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.topView addSubview:self.bianhaoLabel];
    [self.topView addSubview:self.stateLabel];
    [self.topView addSubview:self.lineView];
    [self.bgView addSubview:self.detailLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bgView);
        make.height.equalTo(@40);
    }];
    [self.bianhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topView).offset(15);
        make.centerY.equalTo(self.topView);
        make.trailing.lessThanOrEqualTo(self.stateLabel.mas_leading);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.topView).offset(-15);
        make.centerY.equalTo(self.topView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topView).offset(15);
        make.trailing.equalTo(self.topView).offset(-15);
        make.bottom.equalTo(self.topView);
        make.height.equalTo(@0.5);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(15);
        make.leading.equalTo(self.bgView).offset(15);
        make.trailing.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.bgView).offset(-15);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
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

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (void)setListModel:(LxmTouSuListModel *)listModel {
    _listModel = listModel;
    _bianhaoLabel.text = [NSString stringWithFormat:@"投诉编号：%@",_listModel.longCode];
    
    switch (_listModel.status.intValue) {//1：待处理，2：处理中，3：待评价（处理完成），4：已驳回，5：已结束
        case 1: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待处理";
        }
            break;
        case 2: {
            _stateLabel.text = @"处理中";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 3: {
            _stateLabel.text = @"待评价";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 4: {
            _stateLabel.text = @"已驳回";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 5: {
            _stateLabel.text = @"已结束";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        default:
            break;
    }
    _detailLabel.text = _listModel.commend;
}

@end


/**
 投诉详情 投诉编号
 */
@interface LxmTouSuDetailBianHaoCell ()

@property (nonatomic, strong) UILabel *bianhaoLabel;//投诉编号

@property (nonatomic, strong) UILabel *stateLabel;//处理状态

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmTouSuDetailBianHaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
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
        
    }
    return _stateLabel;
}

- (void)setData {
    _bianhaoLabel.text = @"投诉编号：8045215484865438653";
    _stateLabel.text = @"处理中";
}

- (void)setModel:(LxmTouSuDetailModel *)model {
    _model = model;
    _bianhaoLabel.text = [NSString stringWithFormat:@"投诉编号：%@",_model.longCode];
    switch (_model.status.integerValue) {//1：待处理，2：处理中，3：待评价（处理完成），4：已驳回，5：已结束
        case 1: {
            _stateLabel.textColor = MainColor;
            _stateLabel.text = @"待处理";
        }
            break;
        case 2: {
            _stateLabel.text = @"处理中";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 3: {
            _stateLabel.text = @"待评价";
            _stateLabel.textColor = MainColor;
        }
            break;
        case 4: {
            _stateLabel.text = @"已驳回";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        case 5: {
            _stateLabel.text = @"已结束";
            _stateLabel.textColor = CharacterGrayColor;
        }
            break;
        default:
            break;
    }
    
}


@end


/**
 投诉详情 投诉内容
 */
@interface LxmTouSuDetailContentCell ()

@property (nonatomic, strong) UILabel *detailLabel;//详情

@end
@implementation LxmTouSuDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (void)setModel:(LxmTouSuDetailModel *)model {
    _model = model;
    _detailLabel.text = _model.commend;
}


@end


/**
 投诉详情 投诉图片
 */
#import "MLYPhotoBrowserView.h"
#import "LxmFenLeiView.h"
@interface LxmTouSuDetailImageCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation LxmTouSuDetailImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(ceil(9/3.0) * (floor((ScreenW - 60)/3.0) + 10)));
        }];
    }
    return self;
}

- (void)setModel:(LxmTouSuDetailModel *)model {
    _model = model;
    [self.dataArr removeAllObjects];
    if (_model.detailPic.isValid) {
        NSArray *tempArr = [_model.detailPic componentsSeparatedByString:@","];
        [self.dataArr addObjectsFromArray:tempArr];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(ceil(self.dataArr.count/3.0) * (floor((ScreenW - 60)/3.0) + 10)));
        }];
        [self.collectionView reloadData];
    } else {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@10);
        }];
    }
   
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.itemSize = CGSizeMake(floor((ScreenW - 60)/3.0), floor((ScreenW - 60)/3.0));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmFenLeiImgItemCell.class forCellWithReuseIdentifier:@"LxmFenLeiImgItemCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmFenLeiImgItemCell *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmFenLeiImgItemCell" forIndexPath:indexPath];
    [buttonItem.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
    mlyView.dataSource = self;
    mlyView.currentIndex = indexPath.row;
    [mlyView showWithItemsSpuerView:self.superview];
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.dataArr.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:self.dataArr[index]];
    return photo;
}

@end


/**
 官方客服Cell
 */
@interface LxmTouSuDetailKeFuCell ()

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//名称

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *resultLabel;//处理结果

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmTouSuDetailKeFuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
        [self setData];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.resultLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
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

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 25;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = CharacterLightGrayColor;
    }
    return _timeLabel;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [UILabel new];
        _resultLabel.font = [UIFont systemFontOfSize:13];
        _resultLabel.numberOfLines = 0;
        _resultLabel.textColor = CharacterDarkColor;
    }
    return _resultLabel;
}

/**
 模拟数据
 */
- (void)setData {
    self.nameLabel.text = @"煜美人客服小蜜";
    self.timeLabel.text = @"2018-06-30 10:22";
    self.resultLabel.text = @"客服小蜜收到您的投诉！";
}

- (void)setModel:(LxmTouSuRecordModel *)model {
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    self.nameLabel.text = _model.username;
    if (_model.createTime.length > 10) {
        self.timeLabel.text = [[_model.createTime substringToIndex:10] getIntervalToZHXTime];
    } else {
        self.timeLabel.text = [_model.createTime getIntervalToZHXTime];
    }
    self.resultLabel.text = _model.commend;
}


@end

/**
 投诉结果 满意 或 不满意
 */
@interface LxmTouSuBottomView ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation LxmTouSuBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.bumanyiButton];
        [self.topView addSubview:self.mamyiButton];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@64);
        }];
        [self.bumanyiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.topView.mas_centerX).offset(-8);
            make.centerY.equalTo(self.topView);
            make.leading.equalTo(self.topView).offset(15);
            make.height.equalTo(@44);
        }];
        
        [self.mamyiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.topView.mas_centerX).offset(8);
            make.centerY.equalTo(self.topView);
            make.trailing.equalTo(self.topView).offset(-15);
            make.height.equalTo(@44);
        }];
        
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
    }
    return _topView;
}

- (UIButton *)bumanyiButton {
    if (!_bumanyiButton) {
        _bumanyiButton = [UIButton new];
        [_bumanyiButton setTitle:@"不满意" forState:UIControlStateNormal];
        [_bumanyiButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_bumanyiButton setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
        _bumanyiButton.layer.cornerRadius = 5;
        _bumanyiButton.layer.masksToBounds = YES;
        _bumanyiButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _bumanyiButton;
}

- (UIButton *)mamyiButton {
    if (!_mamyiButton) {
        _mamyiButton = [UIButton new];
        [_mamyiButton setTitle:@"满意" forState:UIControlStateNormal];
        [_mamyiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mamyiButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        _mamyiButton.layer.cornerRadius = 5;
        _mamyiButton.layer.masksToBounds = YES;
        _mamyiButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mamyiButton;
}

@end
