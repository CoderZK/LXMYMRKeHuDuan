//
//  LxmJiedanMyAcceptVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmJiedanMyAcceptVC.h"
#import "LxmJieDanImageCollectionViewCell.h"
#import "LxmJiedanMyPublishVC.h"
#import "LxmJieDanListViewController.h"
#import "LxmPublishTouSuVC.h"
#import "LxmShangChuanPingJiaDanVC.h"
#import "LxmMyKefuAlertView.h"
#import "LxmJieDanMyAcceptDetailVC.h"

@interface LxmJiedanMyAcceptVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LxmJieDanListModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面

@end

@implementation LxmJiedanMyAcceptVC

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您暂无接单信息哦~";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单平台";
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
    
    [LxmEventBus registerEvent:@"jiedansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    /* 已提交退单 */
    [LxmEventBus registerEvent:@"tuidansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    /* 评价单上传成功 */
    [LxmEventBus registerEvent:@"shangchuanpingjiadansuccess" block:^(id data) {
        StrongObj(self);
        self.page = 1;
        self.allPageNum = 1;
        [self loadData];
    }];
    /* 已退单 */
    [LxmEventBus registerEvent:@"toususuccess" block:^(id data) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        LxmJieDanOrderBianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderBianHaoCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderBianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderBianHaoCell"];
        }
        cell.jieshouModel = model;
        return cell;
    } else if (indexPath.row == 1) {
        LxmJieDanListRenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanListRenCell"];
        if (!cell) {
            cell = [[LxmJieDanListRenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanListRenCell"];
        }
        cell.jieshouModel = model;
        return cell;
    } else if (indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7){
        LxmJieDanOrderLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanOrderLabelCell"];
        if (!cell) {
            cell = [[LxmJieDanOrderLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanOrderLabelCell"];
        }
        cell.jieshouModel = model;
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"服务类型:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.serviceTypeName];
        } else if (indexPath.row == 3) {
            cell.titleLabel.text = @"时间区间:";
            if (model.beginTime.length > 10) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[[model.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[model.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
            } else {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[model.beginTime getIntervalToFXXTNoHHmmime],[model.endTime getIntervalToFXXTNoHHmmime]];
            }
        } else if (indexPath.row == 4) {
            cell.titleLabel.text = @"服务时间:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@天",model.serviceDay];
        } else if (indexPath.row == 5) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.addressDetail];
            cell.titleLabel.text = @"服务地址:";
            cell.detailLabel.text = str;
        } else {
            cell.titleLabel.text = @"打分结果:";
            cell.detailLabel.text = [NSString stringWithFormat:@"%@分",model.score];
        }
        return cell;
    } else if (indexPath.row == 6) {
        LxmJieDanMyAcceptCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyAcceptCenterCell"];
        if (!cell) {
            cell = [[LxmJieDanMyAcceptCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyAcceptCenterCell"];
        }
        cell.model = model;
        return cell;
    }else {
        LxmJieDanMyBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanMyBottomCell"];
        if (!cell) {
            cell = [[LxmJieDanMyBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanMyBottomCell"];
        }
        cell.jieshouModel = model;
        WeakObj(self);
        cell.bottomButtonActionBlock = ^(NSInteger index, LxmJieDanListModel *model) {
            [selfWeak bottomActionIndex:index currentModel:model];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == 1) {
        return 65;
    } else if (indexPath.row == 2) {
        CGFloat h = [model.serviceTypeName getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
        return h;
    } else if (indexPath.row == 3 ) {
        if (model.beginTime.length > 10) {
            NSString *str = [NSString stringWithFormat:@"%@-%@",[[model.beginTime substringToIndex:10] getIntervalToFXXTNoHHmmime],[[model.endTime substringToIndex:10] getIntervalToFXXTNoHHmmime]];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
            return h;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@-%@",[model.beginTime getIntervalToFXXTNoHHmmime],[model.endTime getIntervalToFXXTNoHHmmime]];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
            return h;
        }
    } else if (indexPath.row == 4) {
        CGFloat h = [[model.servicePrice stringByAppendingString:@"天"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 10;
        return h;
    } else if (indexPath.row == 5) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.addressDetail];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 110 - 60, 9999) withFontSize:14].height + 25;
        return h;
    } else if (indexPath.row == 6) {
        if (model.status.intValue == 5 || model.status.intValue == 6) {//待打分  已完成已评价
            CGFloat width = floor((ScreenW - 110 - 60 - 10) / 3.0);
            NSArray *temp = [model.judgePic componentsSeparatedByString:@","];
            return width * ceil(temp.count/3.0) + 15;
        }
        return 0.01;
    } else if (indexPath.row == 7) {
        if (model.score.isValid && model.score.intValue != 0) {
            CGFloat h = [[model.score stringByAppendingString:@"分"] getSizeWithMaxSize:CGSizeMake(ScreenW - 110, 9999) withFontSize:14].height + 25;
            return h;
        }
        return 0.01;
    } else {
        if (model.status.intValue == 3) {
            return 50;
        }
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanListModel *model = self.dataArr[indexPath.section];
    LxmJieDanMyAcceptDetailVC *vc = [[LxmJieDanMyAcceptDetailVC alloc] init];
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
        [LxmNetworking networkingPOST:service_list parameters:@{@"token":SESSION_TOKEN,@"type":@2,@"pageNum" : @(self.page)} returnClass:LxmJieDanListRootModel.class success:^(NSURLSessionDataTask *task, LxmJieDanListRootModel *responseObject) {
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

#import "MLYPhotoBrowserView.h"
@interface LxmJieDanMyAcceptCenterCell() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MLYPhotoBrowserViewDataSource>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <NSString *>*imgs;//图片数组
@end

@implementation LxmJieDanMyAcceptCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.collectionView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(75);
        make.height.equalTo(@24);
        make.width.equalTo(@80);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing);
        make.trailing.bottom.equalTo(self);
        make.top.equalTo(self).offset(5);
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
    if (self.detailModel) {
        CGFloat width = floor((ScreenW - 110 - 10) / 3.0);
        return CGSizeMake(width, width);
    }
    CGFloat width = floor((ScreenW - 110 - 60 - 10) / 3.0);
    return CGSizeMake(width, width);
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"评 价 单：";
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 15);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
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
    self.imgs = [_model.judgePic componentsSeparatedByString:@","];
    [self.collectionView reloadData];
}

- (void)setDetailModel:(LxmJieDanListModel *)detailModel {
    _detailModel = detailModel;
    self.imgs = [_detailModel.backPic componentsSeparatedByString:@","];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.height.equalTo(@24);
        make.width.equalTo(@80);
    }];
    [self.collectionView reloadData];
    
}

@end
