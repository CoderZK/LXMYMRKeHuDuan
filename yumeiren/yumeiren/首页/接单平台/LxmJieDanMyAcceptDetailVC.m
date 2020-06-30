//
//  LxmJieDanMyAcceptDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJieDanMyAcceptDetailVC.h"
#import "LxmJieDanMyPublishDetailVC.h"
#import "LxmJiedanMyPublishVC.h"
#import "LxmJieDanListViewController.h"
#import "LxmJiedanMyAcceptVC.h"
#import "LxmMyKefuAlertView.h"
#import "LxmPublishTouSuVC.h"
#import "LxmShangChuanPingJiaDanVC.h"

@interface LxmJieDanMyAcceptDetailVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmJieDanMyPublishDetailBottomView *bottomView;//底部确认发布view

@property (nonatomic, strong) LxmJieDanListModel *detailmodel;


@end

@implementation LxmJieDanMyAcceptDetailVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (LxmJieDanMyPublishDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmJieDanMyPublishDetailBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.hidden = YES;
        WeakObj(self);
        _bottomView.bottomButtonActionBlock = ^(NSInteger index, LxmJieDanListModel *model) {
            [selfWeak bottomActionIndex:index currentModel:model];
        };
    }
    return _bottomView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.readBlock) {
        self.readBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initView];
    [self loadDetailData];
    WeakObj(self);
    /* 已提交退单 */
    [LxmEventBus registerEvent:@"tuidansuccess" block:^(id data) {
        StrongObj(self);
        [self loadDetailData];
    }];
    /* 评价单上传成功 */
    [LxmEventBus registerEvent:@"shangchuanpingjiadansuccess" block:^(id data) {
        StrongObj(self);
        [self loadDetailData];
    }];
}

/**
 view添加子视图
 */
- (void)initView {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LxmJieDanOrderBianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderBianHaoCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderBianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderBianHaoCell"];
            }
            cell.model = self.detailmodel;
            return cell;
        } else if (indexPath.row == 1) {
            LxmJieDanListRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanListRenCell"];
            if (!cell) {
                cell = [[LxmJieDanListRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanListRenCell"];
            }
            cell.jieshouModel = self.detailmodel;
            return cell;
        } else if (indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 9){
            LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
            if (!cell) {
                cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
            }
            cell.jieshouModel = self.detailmodel;
            if (indexPath.row == 2) {
                cell.titleLabel.text = @"服务类型:";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.detailmodel.serviceTypeName];
            } else if (indexPath.row == 3) {
                cell.titleLabel.text = @"时间区间:";
                if (self.detailmodel.beginTime.length > 10) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.detailmodel.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[self.detailmodel.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
                } else {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[self.detailmodel.beginTime getIntervalToFXXTNoHHmmime],[self.detailmodel.endTime getIntervalToFXXTNoHHmmime]];
                }
            } else if (indexPath.row == 4) {
                cell.titleLabel.text = @"服务时间:";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@天",self.detailmodel.serviceDay];
            } else if (indexPath.row == 5) {
                NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.detailmodel.province,self.detailmodel.city,self.detailmodel.district,self.detailmodel.addressDetail];
                cell.titleLabel.text = @"服务地址:";
                cell.detailLabel.text = str;
            } else if (indexPath.row ==6) {
                cell.titleLabel.text = @"被服务人:";
                cell.detailLabel.text = self.detailmodel.username;
            } else if (indexPath.row == 7) {
                cell.titleLabel.text = @"联系电话:";
                cell.detailLabel.text = self.detailmodel.telephone;
            }  else {
                cell.titleLabel.text = @"打分结果:";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@分",self.detailmodel.score];
            }
            return cell;
        } else if (indexPath.row == 8) {
            LxmJieDanMyAcceptCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyAcceptCenterCell"];
            if (!cell) {
                cell = [[LxmJieDanMyAcceptCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyAcceptCenterCell"];
            }
            cell.model = self.detailmodel;
            return cell;
        }
    }
    LxmJieDanMyAcceptDetailImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyAcceptDetailImgCell"];
    if (!cell) {
        cell = [[LxmJieDanMyAcceptDetailImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyAcceptDetailImgCell"];
    }
    cell.model = self.detailmodel;
    return cell;
}
            
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row == 1) {
            return 65;
        } else if (indexPath.row == 2) {
            CGFloat h = [self.detailmodel.serviceTypeName getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 3) {
            if (self.detailmodel.beginTime.length > 10) {
                NSString *str = [NSString stringWithFormat:@"%@-%@",[[self.detailmodel.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[self.detailmodel.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
                CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
                return h;
            } else {
                NSString *str = [NSString stringWithFormat:@"%@-%@",[self.detailmodel.beginTime getIntervalToFXXTNoHHmmime],[self.detailmodel.endTime getIntervalToFXXTNoHHmmime]];
                CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
                return h;
            }
        } else if (indexPath.row == 4) {
            CGFloat h = [[self.detailmodel.servicePrice stringByAppendingString:@"天"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 5) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.detailmodel.province,self.detailmodel.city,self.detailmodel.district,self.detailmodel.addressDetail];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
            return h;
        } else if (indexPath.row == 6) {
            if (self.detailmodel.username.isValid) {
                CGFloat h = [self.detailmodel.username getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
                return h;
            }
            return 0;
        } else if (indexPath.row == 7) {
            CGFloat h = [self.detailmodel.telephone getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 25;
            return h;
        } else if (indexPath.row == 8) {
            if (self.detailmodel.status.intValue == 5 || self.detailmodel.status.intValue == 6) {//待打分  已完成已评价
                CGFloat width = (ScreenW - 110 - 10 - 60) / 3.0;
                NSArray *temp = [self.detailmodel.judgePic componentsSeparatedByString:@","];
                return width * ceil(temp.count/3.0) + 15;
            }
            return 0.01;
        } else {
            if (self.detailmodel.score.isValid && self.detailmodel.score.intValue != 0) {
                CGFloat h = [[self.detailmodel.score stringByAppendingString:@"分"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
                return h;
            }
            return 0.01;
        }
    }
    if (self.detailmodel.backCommend.isValid) {
        CGFloat resonH = [self.detailmodel.backCommend getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:15].height + 30;
        CGFloat imgH = 0;
        if (self.detailmodel.backPic.isValid) {
            NSArray *temp = [self.detailmodel.backPic componentsSeparatedByString:@","];
            CGFloat width = floor((ScreenW - 30 - 15) / 4.0);
            imgH = width * ceil(temp.count/4.0) + 15;;
        }
        return resonH + imgH ;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


/**
 获取订单详情
 */
- (void)loadDetailData {
    
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"type" : @2,
                           @"id" : self.model.id
                           };
    if (!self.detailmodel) {
        [SVProgressHUD show];
    }
    [LxmNetworking networkingPOST:order_detail parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        _bottomView.hidden = NO;
        if ([responseObject[@"key"] integerValue] == 1000) {
            self.detailmodel = [LxmJieDanListModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
            if (self.detailmodel.status.intValue == 3) {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(70 + TableViewBottomSpace));
                }];
            } else {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
            self.bottomView.jieshouModel = self.detailmodel;
            [self.view layoutIfNeeded];
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _bottomView.hidden = NO;
        [SVProgressHUD dismiss];
    }];
}

/**
 底部按钮操作
 
 @param index //222左 333右
 @param model 当前实例
 */
- (void)bottomActionIndex:(NSInteger)index currentModel:(LxmJieDanListModel *)model {
    if (model.status.intValue == 3) {
        if ([model.backCommend isValid]) {
            if (index == 222) {//申诉
                LxmMyKefuAlertView *alertView = [[LxmMyKefuAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                alertView.code = LxmTool.ShareTool.userModel.serviceName;
                [alertView show];
            } else {//上传评价单
                [self shangchaunpingjia:model];
            }
        } else {
            if (index == 222) {//申请退单
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认退单" message:@"您确定要退单吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self tuidan:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            } else {//上传评价单
                [self shangchaunpingjia:model];
            }
        }
    }
}
/**
 申请退单
 */
- (void)tuidan:(LxmJieDanListModel *)model {
    LxmPublishTouSuVC *vc = [[LxmPublishTouSuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmPublishTouSuVC_type_chedan];
    vc.tuidanModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 上传评价单
 */
- (void)shangchaunpingjia:(LxmJieDanListModel *)model {
    LxmShangChuanPingJiaDanVC *vc = [[LxmShangChuanPingJiaDanVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

/**
 退单原因和图片
 */
#import "MLYPhotoBrowserView.h"
#import "LxmJieDanImageCollectionViewCell.h"
@interface LxmJieDanMyAcceptDetailImgCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) UILabel *resonLabel;//退单原因

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <NSString *>*imgs;//图片数组

@end
@implementation LxmJieDanMyAcceptDetailImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgs = [NSMutableArray array];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.resonLabel];
    [self addSubview:self.collectionView];
    [self.resonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.resonLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self).offset(-15);
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
    CGFloat width = floor((ScreenW - 30 - 15) / 4.0);
    return CGSizeMake(width, width);
}

- (UILabel *)resonLabel {
    if (!_resonLabel) {
        _resonLabel = UILabel.new;
        _resonLabel.font = [UIFont systemFontOfSize:15];
        _resonLabel.textColor = CharacterDarkColor;
        _resonLabel.numberOfLines = 0;
    }
    return _resonLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:LxmJieDanImageCollectionViewCell.class forCellWithReuseIdentifier:@"LxmJieDanImageCollectionViewCell"];
    }
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
    mlyView.dataSource = self;
    mlyView.currentIndex = indexPath.row;
    [mlyView showWithItemsSpuerView:self.superview];
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.imgs.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:self.imgs[index]];
    return photo;
}


- (void)setModel:(LxmJieDanListModel *)model {
    _model = model;
    _resonLabel.text = _model.backCommend;
    NSArray *arr = [_model.backPic componentsSeparatedByString:@","];
    if (arr.count > 0) {
        [self.imgs addObjectsFromArray:arr];
    }
    [self.collectionView reloadData];
}

@end
