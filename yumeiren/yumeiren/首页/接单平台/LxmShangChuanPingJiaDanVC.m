//
//  LxmShangChuanPingJiaDanVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShangChuanPingJiaDanVC.h"
#import "LxmFenLeiView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

@interface LxmShangChuanPingJiaDanVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *bottomView;//底部确认发布view

@property (nonatomic, strong) UIButton *surePublishButton;//确认发布按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <UIImage *>*imgArr;

@property (nonatomic, strong) NSMutableArray <NSString *>*imgs;


@end

@implementation LxmShangChuanPingJiaDanVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - TableViewBottomSpace - 70)];
    }
    return _headerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

- (UIButton *)surePublishButton {
    if (!_surePublishButton) {
        _surePublishButton = [[UIButton alloc] init];
        [_surePublishButton setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
        [_surePublishButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [_surePublishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _surePublishButton.layer.cornerRadius = 5;
        _surePublishButton.layer.masksToBounds = YES;
        _surePublishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_surePublishButton addTarget:self action:@selector(tijiaoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePublishButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(floor((ScreenW - 60)/4.0), floor((ScreenW - 60)/4.0));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmFenLeiImgItemCell.class forCellWithReuseIdentifier:@"LxmFenLeiImgItemCell"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传评价单";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    [self initView];
    [self initHeaderView];
    self.imgArr = [NSMutableArray array];
    self.imgs = [NSMutableArray array];
}

/**
 view添加子视图
 */
- (void)initView {
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.surePublishButton];
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
    [self.surePublishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self.bottomView).offset(15);
        make.trailing.equalTo(self.bottomView).offset(-15);
        make.height.equalTo(@50);
    }];
}

/**
 头视图添加子视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@(ceil((self.imgArr.count + 1)/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmFenLeiImgItemCell *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmFenLeiImgItemCell" forIndexPath:indexPath];
    if (indexPath.row == self.imgArr.count) {
        buttonItem.deleteButton.hidden = YES;
        buttonItem.imgView.image = [UIImage imageNamed:@"pic_tupian"];
    } else {
        buttonItem.deleteButton.hidden = NO;
        buttonItem.imgView.image = self.imgArr[indexPath.row];
    }
    buttonItem.indexP = indexPath;
    WeakObj(self);
    buttonItem.deleteImgBlock = ^(NSIndexPath *indexP) {
        [selfWeak deleteImg:indexP];
    };
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imgArr.count) {//添加图片
        if (self.imgArr.count >= 3) {
            [SVProgressHUD showErrorWithStatus:@"最多上传3张图片"];
            return;
        }
        
        UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self.imgArr addObject:image];
                    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(ceil((self.imgArr.count + 1)/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
                    }];
                    [self.headerView layoutIfNeeded];
                    [self.collectionView reloadData];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"相片获取失败"];
                }
            }];
        }];
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPickerWithMaximumPhotosAllow:3 - self.imgArr.count completion:^(NSArray *assets) {
                NSArray *assetArr = assets;
                for (int i = 0; i < assets.count; i++)
                {
                    ALAsset *asset = assetArr[i];
                    CGImageRef thum = [asset aspectRatioThumbnail];
                    UIImage *image = [UIImage imageWithCGImage:thum];
                    [self.imgArr addObject:image];
                }
                
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(ceil((self.imgArr.count + 1)/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
                }];
                [self.headerView layoutIfNeeded];
                [self.collectionView reloadData];
            }];
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionController addAction:a1];
        [actionController addAction:a2];
        [actionController addAction:a3];
        [self presentViewController:actionController animated:YES completion:nil];
    }
}


/**
 删除图片
 */
- (void)deleteImg:(NSIndexPath *)indexP {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这张图片吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = [self.imgArr objectAtIndex:indexP.item];
        [self.imgArr removeObject:img];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil((self.imgArr.count + 1)/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
        }];
        [self.collectionView reloadData];
        [self.headerView layoutIfNeeded];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}


/**
 确认提交
 */
- (void)tijiaoClick {
    if (self.imgArr.count > 0) {
        [self updateFile];
    } else {
        [self tijiao];
    }
    
}

/**
 发布投诉提交
 */
- (void)tijiao {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    if (self.imgs.count > 0) {
        dict[@"judgePic"] = [self.imgs componentsJoinedByString:@","];
    }
    if (self.model) {
        dict[@"id"] = self.model.id;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:judge_service_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已上传评价单!"];
            [LxmEventBus sendEvent:@"shangchuanpingjiadansuccess" data:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 多张图片上传
 */
- (void)updateFile {
    [SVProgressHUD showWithStatus:@"正在上传图片,请稍后..."];
    [LxmNetworking NetWorkingUpLoad:Base_upload_multi_img_URL images:self.imgArr parameters:nil name:@"files" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD dismiss];
            NSArray *arr = responseObject[@"result"][@"list"];
            if ([arr isKindOfClass:NSArray.class]) {
                for (NSDictionary *dict in arr) {
                    LxmPublishTouSutModel *model = [LxmPublishTouSutModel mj_objectWithKeyValues:dict];
                    [self.imgs addObject:model.path];
                }
                
            }
            [self tijiao];
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
