//
//  LxmSubInfoClassVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/2/21.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmSubInfoClassVC.h"
#import "LxmClassInfoDetailVC.h"

@interface LxmSubInfoClassVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmClassGoodsModel *>*dataArr;

@end

@implementation LxmSubInfoClassVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake((ScreenW - 25)/2, (ScreenW - 25)/2 * 3/4 + 10 + 40 + 10 + 15 + 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ((ScreenW - 25)/2 * 3/4 + 10 + 40 + 10 + 15 + 15 + 5)*ceil(6/2.0) + 20) collectionViewLayout:layout];
        _collectionView.backgroundColor = BGGrayColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LxmSubClassInfoCell.class forCellWithReuseIdentifier:@"LxmSubClassInfoCell"];
        [_collectionView registerClass:LxmSubYuYinInfoCell.class forCellWithReuseIdentifier:@"LxmSubYuYinInfoCell"];
        
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    WeakObj(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadData];
    }];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadData];
}

- (void)loadData {
    if (self.dataArr <= 0) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    if (self.info_type != 100) {
        dict[@"info_type"] = @(self.info_type);
    }
    dict[@"pageNum"] = @(self.page);
    dict[@"pageSize"] = @10;
    WeakObj(self);
    [LxmNetworking networkingPOST:course_list parameters:dict returnClass:LxmClassRootModel.class success:^(NSURLSessionDataTask *task, LxmClassRootModel *responseObject) {
        StrongObj(self);
        [self endRefresh];
        if (responseObject.key.integerValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                 [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            self.page++;
            [self.collectionView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmClassGoodsModel *model = self.dataArr[indexPath.item];
    if (model.info_type.intValue == 1 || model.info_type.intValue == 3) {//
        LxmSubClassInfoCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmSubClassInfoCell" forIndexPath:indexPath];
        itemCell.model = model;
        return itemCell;
    } else {
        LxmSubYuYinInfoCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmSubYuYinInfoCell" forIndexPath:indexPath];
        itemCell.model = model;
        return itemCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmClassGoodsModel *model = self.dataArr[indexPath.item];
    LxmClassInfoDetailVC *vc = [LxmClassInfoDetailVC new];
    vc.classId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endRefresh {
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

@end

@interface LxmSubClassInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *yingyinView;

@property (nonatomic, strong) UIImageView *playImgView;//视频按钮

@property (nonatomic, strong) UIImageView *goodsImgView;//图片或视频

@property (nonatomic, strong) UIView *bottmView;//底部视图

@property (nonatomic, strong) UILabel *titlelabel;//标题

@property (nonatomic, strong) UILabel *typelabel;//类型

@property (nonatomic, strong) UIImageView *typeImgView;


@end
@implementation LxmSubClassInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yingyinView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.goodsImgView];
        [self.goodsImgView addSubview:self.playImgView];
        [self.bgView addSubview:self.bottmView];
        [self.bgView addSubview:self.titlelabel];
        [self.bgView addSubview:self.typelabel];
        [self.bgView addSubview:self.typeImgView];
        [self.yingyinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(8);
            make.bottom.trailing.equalTo(self).offset(-8);
        }];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(5);
            make.bottom.trailing.equalTo(self).offset(-5);
        }];
        [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@((ScreenW - 45)/2 *3/4));
        }];
        [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.goodsImgView);
            make.width.height.equalTo(@30);
        }];
        [self.bottmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsImgView.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.bgView);
        }];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsImgView.mas_bottom).offset(10);
            make.leading.equalTo(self.bgView).offset(15);
            make.trailing.equalTo(self.bgView).offset(-15);
            make.height.equalTo(@40);
        }];
        [self.typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titlelabel.mas_bottom).offset(10);
            make.leading.equalTo(self.bgView).offset(15);
            make.trailing.lessThanOrEqualTo(self.typeImgView.mas_leading).offset(-5);
        }];
        [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.typelabel);
            make.trailing.equalTo(self.bgView).offset(-15);
            make.width.height.equalTo(@20);
        }];
    }
    return self;
}

- (UIView *)yingyinView {
    if (!_yingyinView) {
        _yingyinView = [[UIView alloc] init];
        _yingyinView.backgroundColor = [UIColor whiteColor];
        _yingyinView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _yingyinView.layer.shadowRadius = 5;
        _yingyinView.layer.shadowOpacity = 0.5;
        _yingyinView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _yingyinView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.image = [UIImage imageNamed:@"tupian"];
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.layer.masksToBounds = YES;
    }
    return _goodsImgView;
}

- (UIImageView *)playImgView {
    if (!_playImgView) {
        _playImgView = [UIImageView new];
        _playImgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _playImgView.layer.cornerRadius = 15;
        _playImgView.layer.masksToBounds = YES;
        _playImgView.image = [UIImage imageNamed:@"audio-visual_play"];
    }
    return _playImgView;
}

- (UIView *)bottmView {
    if (!_bottmView) {
        _bottmView = [[UIView alloc] init];
    }
    return _bottmView;
}

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [UILabel new];
        _titlelabel.textColor = CharacterDarkColor;
        _titlelabel.font = [UIFont systemFontOfSize:16];
        _titlelabel.numberOfLines = 0;
    }
    return _titlelabel;
}

- (UILabel *)typelabel {
    if (!_typelabel) {
        _typelabel = [UILabel new];
        _typelabel.textColor = CharacterLightGrayColor;
        _typelabel.font = [UIFont systemFontOfSize:12];
    }
    return _typelabel;
}

- (UIImageView *)typeImgView {
    if (!_typeImgView) {
        _typeImgView = [UIImageView new];
        _typeImgView.image = [UIImage imageNamed:@"class_vedio"];
    }
    return _typeImgView;
}

- (void)setModel:(LxmClassGoodsModel *)model {
    _model = model;
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titlelabel.text = _model.title;
    _typelabel.text = _model.type_name;
    _typeImgView.image = [UIImage imageNamed:_model.info_type.intValue == 3 ? @"class_vedio" : @"class_img"];
    _playImgView.hidden = _model.info_type.intValue == 1;
}

@end

@interface lxmYuYinView ()

@property (nonatomic, strong) UIImageView *huatongImgView;

@property (nonatomic, strong) UIImageView *yuyinImgView;

@end
@implementation lxmYuYinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.huatongImgView];
        [self addSubview:self.yuyinImgView];
        [self.huatongImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(8);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@18);
        }];
        [self.yuyinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.huatongImgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@18);
        }];
    }
    return self;
}

- (UIImageView *)huatongImgView {
    if (!_huatongImgView) {
        _huatongImgView = [UIImageView new];
        _huatongImgView.image = [UIImage imageNamed:@"huatong"];
    }
    return _huatongImgView;
}

- (UIImageView *)yuyinImgView {
    if (!_yuyinImgView) {
        _yuyinImgView = [UIImageView new];
        _yuyinImgView.image = [UIImage imageNamed:@"yinpin"];
    }
    return _yuyinImgView;
}

@end


@interface LxmSubYuYinInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *yingyinView;

@property (nonatomic, strong) UIImageView *goodsImgView;//图片或视频

@property (nonatomic, strong) lxmYuYinView *yuyinView;

@property (nonatomic, strong) UILabel *typelabel;//类型

@property (nonatomic, strong) UIImageView *typeImgView;

@end
@implementation LxmSubYuYinInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yingyinView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.goodsImgView];
        [self.bgView addSubview:self.yuyinView];
        [self.bgView addSubview:self.typelabel];
        [self.bgView addSubview:self.typeImgView];
        
        [self.yingyinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(8);
            make.bottom.trailing.equalTo(self).offset(-8);
        }];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(5);
            make.bottom.trailing.equalTo(self).offset(-5);
        }];
        [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@((ScreenW - 45)/2 *3/4));
        }];
        [self.yuyinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsImgView.mas_bottom).offset(10);
            make.leading.equalTo(self.bgView).offset(10);
            make.trailing.equalTo(self.bgView).offset(-40);
            make.height.equalTo(@26);
        }];
        [self.typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.yuyinView.mas_bottom).offset(15);
            make.leading.equalTo(self.bgView).offset(15);
            make.trailing.lessThanOrEqualTo(self.typeImgView.mas_leading).offset(-5);
        }];
        [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.typelabel);
            make.trailing.equalTo(self.bgView).offset(-15);
            make.width.height.equalTo(@20);
        }];
        
    }
    return self;
}

- (UIView *)yingyinView {
    if (!_yingyinView) {
        _yingyinView = [[UIView alloc] init];
        _yingyinView.backgroundColor = [UIColor whiteColor];
        _yingyinView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _yingyinView.layer.shadowRadius = 5;
        _yingyinView.layer.shadowOpacity = 0.5;
        _yingyinView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _yingyinView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.image = [UIImage imageNamed:@"tupian"];
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.layer.masksToBounds = YES;
    }
    return _goodsImgView;
}

- (lxmYuYinView *)yuyinView {
    if (!_yuyinView) {
        _yuyinView = [lxmYuYinView new];
        _yuyinView.backgroundColor = [UIColor colorWithRed:254/255.0 green:185/255.0  blue:182/255.0  alpha:1];
        _yuyinView.layer.cornerRadius = 13;
        _yuyinView.layer.masksToBounds = YES;
    }
    return _yuyinView;
}

- (UILabel *)typelabel {
    if (!_typelabel) {
        _typelabel = [UILabel new];
        _typelabel.textColor = CharacterLightGrayColor;
        _typelabel.font = [UIFont systemFontOfSize:12];
        _typelabel.text = @"养生";
    }
    return _typelabel;
}

- (UIImageView *)typeImgView {
    if (!_typeImgView) {
        _typeImgView = [UIImageView new];
        _typeImgView.image = [UIImage imageNamed:@"class_vedio"];
    }
    return _typeImgView;
}

- (void)setModel:(LxmClassGoodsModel *)model {
    _model = model;
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _typelabel.text = _model.type_name;
    _typeImgView.image = [UIImage imageNamed:@"class_yuyin"];
}

@end
