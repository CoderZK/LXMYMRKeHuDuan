//
//  LxmPublishTouSuVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPublishTouSuVC.h"
#import "LxmFenLeiView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

@interface LxmPublishTouSuVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *bottomView;//底部确认发布view

@property (nonatomic, strong) UIButton *surePublishButton;//确认发布按钮

@property (nonatomic, strong) IQTextView *textView;//输入框

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <UIImage *>*imgArr;

@property (nonatomic, strong) NSMutableArray <NSString *>*imgs;

@property (nonatomic, assign) LxmPublishTouSuVC_type type;

@end

@implementation LxmPublishTouSuVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPublishTouSuVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - TableViewBottomSpace - 70)];
    }
    return _headerView;
}

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.placeholder = self.type == LxmPublishTouSuVC_type_tousu ? @"请输入投诉内容" : self.type == LxmPublishTouSuVC_type_chedan ? @"请输入退单原因" : @"申请成为代理";
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
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
    self.navigationItem.title = self.type == LxmPublishTouSuVC_type_tousu ? @"发起投诉" : self.type == LxmPublishTouSuVC_type_chedan ? @"申请退单" : @"申请代理";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    [self initView];
    [self initHeaderView];
    self.imgArr = [NSMutableArray array];
    self.imgs = [NSMutableArray array];
    if (self.tousuModel) {
        self.textView.text = self.tousuModel.commend;
    }
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
    [self.headerView addSubview:self.textView];
    [self.headerView addSubview:self.collectionView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.leading.equalTo(self.headerView).offset(13);
        make.trailing.equalTo(self.headerView).offset(-13);
        make.height.equalTo(@150);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
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
        if (self.imgArr.count >= 9) {
            [SVProgressHUD showErrorWithStatus:@"最多上传9张图片"];
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
            [self showMXPickerWithMaximumPhotosAllow:9 - self.imgArr.count completion:^(NSArray *assets) {
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
    if (![self.textView.text isValid]) {
        [SVProgressHUD showErrorWithStatus: self.type == LxmPublishTouSuVC_type_tousu ? @"请输入投诉内容!":self.type == LxmPublishTouSuVC_type_chedan ? @"请输入退单原因" : @"请输入申请原因"];
        return;
    }
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
    
    if (self.type == LxmPublishTouSuVC_type_shenqingdaili) {
        if (self.imgs.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请上传至少一张图片!"];
            return;
        }
        NSString *ids = [self.imgs componentsJoinedByString:@","];
        if (self.shenqingDailiBlock) {
            self.shenqingDailiBlock(self.textView.text, ids);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    
    NSString *str = @"";
    if (self.type == LxmPublishTouSuVC_type_tousu) {
        if (self.tousuModel) {
            dict[@"id"] = self.tousuModel.id;
        }
        dict[@"commend"] = self.textView.text;
        if (self.imgs.count > 0) {
            dict[@"detailPic"] = [self.imgs componentsJoinedByString:@","];
        }
        str = send_complain;
    }
    if (self.tuidanModel) {
        dict[@"id"] = self.tuidanModel.id;
        dict[@"backCommend"] = self.textView.text;
        if (self.imgs.count > 0) {
            dict[@"backPic"] = [self.imgs componentsJoinedByString:@","];
        }
        str = back_service_order;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:self.type == LxmPublishTouSuVC_type_tousu ? @"已提交投诉!" : @"已撤单!"];
            [LxmEventBus sendEvent:@"toususuccess" data:nil];
            [LxmEventBus sendEvent:@"tuidansuccess" data:nil];
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
