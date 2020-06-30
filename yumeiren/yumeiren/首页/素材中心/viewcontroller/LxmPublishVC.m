//
//  LxmPublishVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/19.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPublishVC.h"
#import "LxmPublishAlertView.h"
#import "LxmPublishView.h"
#import "LxmFenLeiView.h"
#import "LxmPublishTypeVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

#import "LxmPublishSuccessAlertView.h"

#import <AVFoundation/AVFoundation.h>

@interface LxmPublishVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) LxmPublishAlertView *alertView;

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) LxmPublishTypeButton *topButton;

@property (nonatomic, strong) LxmPublishTypeButton *publishTypeButton;

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *bottomView;//底部确认发布view

@property (nonatomic, strong) UIButton *surePublishButton;//确认发布按钮

@property (nonatomic, strong) IQTextView *textView;//输入框

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger index;//110图文 111视频 112没选择类型

@property (nonatomic, strong) NSString *contentID;

@property (nonatomic, strong) NSMutableArray <UIImage *>*imgArr;

@property (nonatomic, strong) NSMutableArray <NSString *>*imgs;

@property (nonatomic, strong) NSData *vedio_data;//视频data

@property (nonatomic, strong) UIImage *vedio_img;//视频封面

@property (nonatomic, strong) NSString *vedio_url;//视频封面地址

@property (nonatomic, strong) LxmPublishTouSutModel *vedioModel;//视频模型

@end

@implementation LxmPublishVC
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
        _textView.placeholder = @"请输入发布内容";
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
        [_surePublishButton setTitle:@"确认发布" forState:UIControlStateNormal];
        [_surePublishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _surePublishButton.layer.cornerRadius = 5;
        _surePublishButton.layer.masksToBounds = YES;
        _surePublishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_surePublishButton addTarget:self action:@selector(surePublishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePublishButton;
}

- (LxmPublishTypeButton *)topButton {
    if (!_topButton) {
        _topButton = [[LxmPublishTypeButton alloc] init];
        _topButton.textLabel.text = @"请选择发布类型";
        [_topButton addTarget:self action:@selector(leixingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}

- (LxmPublishTypeButton *)publishTypeButton {
    if (!_publishTypeButton) {
        _publishTypeButton = [[LxmPublishTypeButton alloc] init];
        _publishTypeButton.textLabel.text = @"发布内容分类";
        [_publishTypeButton addTarget:self action:@selector(publishTypeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishTypeButton;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.index == 112) {
        [self.alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 112;
    self.navigationItem.title = @"发布";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.alertView = [[LxmPublishAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    WeakObj(self);
    self.alertView.publishTypeBlock = ^(NSInteger index) {
        selfWeak.index = index;
        if (index == 110) {
            selfWeak.topButton.textLabel.textColor = CharacterDarkColor;
            selfWeak.topButton.textLabel.text = @"图文类型";
        } else if (index == 111) {
            selfWeak.topButton.textLabel.textColor = CharacterDarkColor;
            selfWeak.topButton.textLabel.text = @"视频类型";
        } else {
            selfWeak.topButton.textLabel.textColor = CharacterLightGrayColor;
            selfWeak.topButton.textLabel.text = @"请选择发布类型";
        }
    };
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
    [self.headerView addSubview:self.topButton];
    [self.headerView addSubview:self.publishTypeButton];
    [self.headerView addSubview:self.textView];
    [self.headerView addSubview:self.collectionView];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.publishTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topButton.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishTypeButton.mas_bottom);
        make.leading.equalTo(self.headerView).offset(12);
        make.trailing.equalTo(self.headerView).offset(-12);
        make.height.equalTo(@150);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@(ceil(1/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.index == 110) {//图文
        return self.imgArr.count + 1;
    }
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmFenLeiImgItemCell *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmFenLeiImgItemCell" forIndexPath:indexPath];
    if (self.index == 110) {//图文
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
    } else {//视频
        if (self.vedio_img) {
            buttonItem.deleteButton.hidden = NO;
            buttonItem.imgView.image = self.vedio_img;
            WeakObj(self);
            buttonItem.deleteImgBlock = ^(NSIndexPath *indexP) {
                [selfWeak deleteVedio];
            };
        } else {
            buttonItem.deleteButton.hidden = YES;
            buttonItem.imgView.image = [UIImage imageNamed:@"pic_tupian"];
        }
        
    }
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 110) {//图文
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
                    for (int i = 0; i < assets.count; i++) {
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
    } else {//视频
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.delegate = self;
        imgPickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *avliableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imgPickerController.mediaTypes = [NSArray arrayWithObject:avliableMedia[1]];
        [self presentViewController:imgPickerController animated:YES completion:nil];
    }
}
/**
 选择视频的回调
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    CGFloat time = [self getVideoLength:sourceURL];
    if (time > 60) {
        [SVProgressHUD showErrorWithStatus:@"请选择小于60s的视频进行上传!"];
        return;
    } else {
        self.vedio_img = [self firstFrameWithVideoURL:sourceURL size:CGSizeMake(400, 300)];
        if (self.vedio_img) {
            [self uploadCover];
        }
        NSURL *newVideoUrl; //一般.mp4
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    }
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"AVAssetExportSessionStatusCompleted");
             [SVProgressHUD dismiss];
             //转化成二进制流
             NSData *videlData = [NSData dataWithContentsOfURL:outputURL];
             [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.height.equalTo(@(ceil(1/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
             }];
             self.vedio_data = videlData;
             [self.collectionView reloadData];
             [self.headerView layoutIfNeeded];
             
         });
         
     }];
}


- (CGFloat)getFileSize:(NSString *)path {//此方法可以获取文件的大小，返回的是单位是KB。
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

- (CGFloat)getVideoLength:(NSURL *)URL {//此方法可以获取视频文件的时长。
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size {
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
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

//删除视频
- (void)deleteVedio {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除视频吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.vedio_img = nil;
        self.vedio_data = nil;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil((self.imgArr.count + 1)/4.0) * (floor((ScreenW - 60)/4.0) + 10)));
        }];
        [self.collectionView reloadData];
        [self.headerView layoutIfNeeded];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 发布内容分类
 */
- (void)publishTypeClick {
    LxmPublishTypeVC *vc = [[LxmPublishTypeVC alloc] init];
    vc.contentID = self.contentID;
    WeakObj(self);
    vc.contentTypeSelectBlock = ^(LxmSuCaiContentTypeListModel * _Nonnull model) {
        selfWeak.contentID = model.id;
        selfWeak.publishTypeButton.textLabel.textColor = CharacterDarkColor;
        selfWeak.publishTypeButton.textLabel.text = model.title;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 选择发布类型
 */
- (void)leixingClick {
    [self.alertView show];
}
/**
 确认发布
 */
- (void)surePublishClick {
    NSString *content = self.textView.text;
    if (!self.contentID) {
        [SVProgressHUD showErrorWithStatus:@"请选择发布内容分类!"];
        return;
    }
    if (![content isValid]) {
        [SVProgressHUD showErrorWithStatus:@"请输入发布内容!"];
        return;
    }
    if (self.index == 110) {//图文类型
        if (self.imgArr.count > 0) {
            [self updateFile];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请上传至少一张图片!"];
            return;
        }
    } else {//上传视频
        if (self.vedio_data) {
            [self uploadVedio];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请选择视频文件!"];
        }
    }
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
            if (self.imgs.count > 0) {
               [self publish];
            } else {
                [SVProgressHUD showErrorWithStatus:@"图片全部上传失败,请重试!"];
            }
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 上传视频封面
 */

- (void)uploadCover{
    [SVProgressHUD showWithStatus:@"视频封面正在上传,请稍后..."];
    [LxmNetworking NetWorkingUpLoad:Base_upload_img_URL image:self.vedio_img parameters:nil name:@"file" success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD dismiss];
            LxmPublishTouSutModel *model = [LxmPublishTouSutModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            self.vedio_url = model.path;
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



/**
 上传视频
 */
- (void)uploadVedio {
    [SVProgressHUD showWithStatus:@"视频上传图片,请稍后..."];
    [LxmNetworking NetWorkingUpLoad:Base_upload_img_URL fileData:self.vedio_data andFileName:@"file" parameters:@{@"video":@1} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD dismiss];
            self.vedioModel = [LxmPublishTouSutModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            if ([self.vedioModel.path isValid]) {
                [self publish];
            }
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


/**
 发布
 */
- (void)publish {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"type_id"] = self.contentID;
    dict[@"title"] = self.textView.text;
    if (self.index == 110) {//图文
        dict[@"content"] = [self.imgs componentsJoinedByString:@","];
    } else {
        if (self.vedio_url) {
            dict[@"content"] = self.vedio_url;
        }
        if ([self.vedioModel.path isValid]) {
            dict[@"videoUrl"] = self.vedioModel.path;
        }
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:up_share parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LxmEventBus sendEvent:@"sucaipublishsusuccess" data:nil];
            LxmPublishSuccessAlertView *alertView = [[LxmPublishSuccessAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alertView.roleType = LxmTool.ShareTool.userModel.roleType;
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
