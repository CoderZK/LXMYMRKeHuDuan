//
//  LxmFenLeiView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/18.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmFenLeiView.h"
#import "MLYPhotoBrowserView.h"
#import "LxmFenLeiView.h"
#import "LxmMoviePlayerView.h"

@implementation LxmFenLeiView

@end

@interface LxmFenLeiUserInfoCell()

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nickLabel;//昵称

@property (nonatomic, strong) UILabel *timeLabel;//时间

@end
@implementation LxmFenLeiUserInfoCell

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
    [self addSubview:self.nickLabel];
    [self addSubview:self.tuijianImgView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.deleteButton];
    [self.deleteButton addSubview:self.deleteLabel];
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
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.tuijianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nickLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.nickLabel);
        make.width.height.equalTo(@15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-75);
        make.centerY.equalTo(self.nickLabel);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.nickLabel);
    }];
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deleteButton);
        make.trailing.equalTo(self.deleteButton);
        make.width.equalTo(@50);
        make.height.equalTo(@24);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = CharacterDarkColor;
        _nickLabel.font = [UIFont boldSystemFontOfSize:15];
        _nickLabel.text = @"是木子啊";
    }
    return _nickLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CharacterLightGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"2018/6/6 18:17";
    }
    return _timeLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.textColor = MainColor;
    }
    return _stateLabel;
}

- (UIImageView *)tuijianImgView {
    if (!_tuijianImgView) {
        _tuijianImgView = [UIImageView new];
        _tuijianImgView.image = [UIImage imageNamed:@"tuijian"];
    }
    return _tuijianImgView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        [_deleteButton addTarget:self action:@selector(deleteSuCai) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UILabel *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [UILabel new];
        _deleteLabel.textColor = MainColor;
        _deleteLabel.text = @"删除";
        _deleteLabel.font = [UIFont systemFontOfSize:12];
        _deleteLabel.layer.cornerRadius = 12;
        _deleteLabel.layer.borderWidth = 0.5;
        _deleteLabel.layer.borderColor = MainColor.CGColor;
        _deleteLabel.layer.masksToBounds = YES;
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deleteLabel;
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.user_head] placeholderImage:[UIImage imageNamed:@"moren"]];
    self.nickLabel.text = _model.username;
    if (_model.create_time.length > 10) {
         self.timeLabel.text = [[_model.create_time substringToIndex:10] getIntervalToFXXTime];
    } else {
         self.timeLabel.text = [_model.create_time getIntervalToFXXTime];
    }
    if (_model.status.intValue == 1) {
        self.stateLabel.text = @"审核中";
        self.stateLabel.textColor = MainColor;
    } else if (_model.status.intValue == 2) {
        self.stateLabel.text = @"审核通过";
        self.stateLabel.textColor = CharacterGrayColor;
    } else if (_model.status.intValue == 3){
        self.stateLabel.text = @"审核拒绝";
        self.stateLabel.textColor = MainColor;
    }
}

- (void)deleteSuCai {
    if (self.deleteSuCaiBlock) {
        self.deleteSuCaiBlock(self.model);
    }
}

@end


/**
 内容cell
 */
@interface LxmFenLeiContentCell()

@property (nonatomic, strong) UILabel *contentlabel;//文字内容

@end
@implementation LxmFenLeiContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.contentlabel];
        [self.contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(85);
            make.trailing.equalTo(self).offset(-15);
        }];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)contentlabel {
    if (!_contentlabel) {
        _contentlabel = [[UILabel alloc] init];
        _contentlabel.font = [UIFont systemFontOfSize:14];
        _contentlabel.textColor = CharacterDarkColor;
        _contentlabel.numberOfLines = 0;
    }
    return _contentlabel;
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    _contentlabel.text = _model.title;
}

@end


/**
 展开收缩
 */
@implementation LxmFenLeiButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textColor = MainColor;
        _stateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _stateLabel;
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    NSString *str = model.title;
    CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 100, 9999) withFontSize:14].height;
    _stateLabel.hidden =  h < 50 ? YES : NO;
}

@end


/**
 图片cell
 */
@interface LxmFenLeiImgItemCell ()

@end

@implementation LxmFenLeiImgItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.deleteButton];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.equalTo(self);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"pic_tupian"];
        _imgView.layer.cornerRadius = 3;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteImgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteImgClick:(UIButton *)btn {
    if (self.deleteImgBlock) {
        self.deleteImgBlock(self.indexP);
    }
}


@end

@interface LxmFenLeiImgCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;



@property (nonatomic, strong) NSArray <NSString *>*imgs;//图片数组

@end
@implementation LxmFenLeiImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgs = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(85);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(floor((ScreenW-120)/3), floor((ScreenW-120)/3));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmFenLeiImgItemCell.class forCellWithReuseIdentifier:@"LxmFenLeiImgItemCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmFenLeiImgItemCell *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmFenLeiImgItemCell" forIndexPath:indexPath];
    [buttonItem.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgs[indexPath.item]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
    mlyView.dataSource = self;
    mlyView.currentIndex = indexPath.row;
    [mlyView showWithItemsSpuerView:self.superview];
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    self.imgs = [_model.content componentsSeparatedByString:@","];
    [self.collectionView reloadData];
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

@end

/**
 视频cell
 */
#import "LxmMoviePlayerView.h"
#import "LxmPlayerManager.h"
#import "LxmFullScreenViewController.h"

@interface LxmFenLeiVedioCell ()<LxmMoviePlayerViewDelegate>

@property (nonatomic, strong) UIImageView *vedioView;

@property (nonatomic, strong) LxmMoviePlayerView *playerView;

@property (nonatomic, strong) UIView *playerBaseView;

@property (nonatomic, strong) UIButton *playButton;//播放

@property (nonatomic, weak) LxmFullScreenViewController *fullScreenVC;

@end
@implementation LxmFenLeiVedioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.playerBaseView];
    [self.playerBaseView addSubview:self.playerView];
    [self addSubview:self.vedioView];
    [self addSubview:self.playButton];
}

- (void)setConstrains {
    void(^block)(MASConstraintMaker *make) = ^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(85);
        make.top.equalTo(self).offset(15);
        make.width.equalTo(@260);
        make.height.equalTo(@150);
    };
    
    [self.vedioView mas_makeConstraints:block];
    [self.playerBaseView mas_makeConstraints:block];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerBaseView);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vedioView);
        make.width.height.equalTo(@40);
    }];
}

- (UIImageView *)vedioView {
    if (!_vedioView) {
        _vedioView = [[UIImageView alloc] init];
        _vedioView.contentMode = UIViewContentModeScaleAspectFit;
        _vedioView.backgroundColor = [UIColor blackColor];
        _vedioView.layer.masksToBounds = YES;
    }
    return _vedioView;
}

- (UIView *)playerBaseView {
    if (!_playerBaseView) {
        _playerBaseView = [UIView new];
    }
    return _playerBaseView;
}

- (LxmMoviePlayerView *)playerView {
    if (!_playerView) {
        _playerView = [LxmMoviePlayerView new];
        [LxmPlayerManager addPlayer:_playerView];
        _playerView.delegate = self;
    }
    return _playerView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"audio-visual_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"audio_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = NO;
    }
    return _playButton;
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    if (_model.video_url) {
        _playerView.contentURL = [NSURL URLWithString:_model.video_url];
    }
    if (_model.content) {
        [_vedioView sd_setImageWithURL:[NSURL URLWithString:_model.content]];
    }
}

/**
 播放
 */
- (void)playButtonClick:(UIButton *)btn {
    [self.playerView resume];
    btn.hidden = YES;
    _vedioView.hidden = YES;
    [LxmPlayerManager stopOtherPlayerFor:_playerView];
}

- (void)LxmMoviePlayerView:(LxmMoviePlayerView *)view clickBtnAt:(LxmMoviePlayerViewBtnType)type {
    if (type == LxmMoviePlayerViewBtnType_pause) {
        self.playButton.hidden = NO;
    } else if (type == LxmMoviePlayerViewBtnType_play) {
        [LxmPlayerManager stopOtherPlayerFor:_playerView];
        _vedioView.hidden = YES;
        self.playButton.hidden = YES;
    } else if (type == LxmMoviePlayerViewBtnType_rotate) {
        if (_playerView.superview == _playerBaseView) {
            LxmFullScreenViewController *vc = [LxmFullScreenViewController new];
            vc.player = _playerView;
            vc.dismissBlock = ^{
                [_playerView removeFromSuperview];
                [self.playerBaseView addSubview:_playerView];
                [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.playerBaseView);
                }];
            };
            _fullScreenVC = vc;
            [[UIViewController topViewController] presentViewController:vc animated:NO completion:nil];
        } else {
            [_fullScreenVC close];
        }
    }
}

- (void)stopPlayer {
    [_playerView pause];
    self.playButton.hidden = NO;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_playerView pause];
    _vedioView.hidden = NO;
}

@end

/**
 底部
 */
@interface LxmFenLeiBottomButton : UIButton

@property (nonatomic, strong) UILabel *leftLabel;//左侧文字

@property (nonatomic, strong) UIImageView *rightImgView;//右侧图片

@end
@implementation LxmFenLeiBottomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightImgView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self);
        }];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.leftLabel);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:13];
    }
    return _leftLabel;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
    }
    return _rightImgView;
}

@end


#import <SDWebImage/UIImageView+WebCache.h>
@interface LxmFenLeiBottomCell ()

@property (nonatomic, strong) LxmFenLeiBottomButton *downloadImgBtn;

@property (nonatomic, strong) LxmFenLeiBottomButton *fuzhiTextBtn;

@end
@implementation LxmFenLeiBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.downloadImgBtn];
        [self addSubview:self.fuzhiTextBtn];
        [self addSubview:self.lineView];
        [self.downloadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(85);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.fuzhiTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.downloadImgBtn.mas_trailing).offset(20);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

- (LxmFenLeiBottomButton *)downloadImgBtn {
    if (!_downloadImgBtn) {
        _downloadImgBtn = [[LxmFenLeiBottomButton alloc] init];
        _downloadImgBtn.rightImgView.image = [UIImage imageNamed:@"sc_tupian"];
        _downloadImgBtn.leftLabel.text = @"下载图片 0";
        [_downloadImgBtn addTarget:self action:@selector(downImgView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadImgBtn;
}

- (LxmFenLeiBottomButton *)fuzhiTextBtn {
    if (!_fuzhiTextBtn) {
        _fuzhiTextBtn = [[LxmFenLeiBottomButton alloc] init];
        _fuzhiTextBtn.rightImgView.image = [UIImage imageNamed:@"sc_fuzhi"];
        _fuzhiTextBtn.leftLabel.text = @"复制文字 0";
        [_fuzhiTextBtn addTarget:self action:@selector(fuzhiTextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fuzhiTextBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmSuCaiListModel *)model {
    _model = model;
    _fuzhiTextBtn.leftLabel.text = [NSString stringWithFormat:@"复制文字 %@",_model.title_num];
    _downloadImgBtn.leftLabel.text = [NSString stringWithFormat:@"下载图片 %@",_model.media_num];
}

/**
 复制文字
 */
- (void)fuzhiTextClick {
    if (self.model.title.isValid) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.model.title;
        [self updateCount:@1];
        [SVProgressHUD showSuccessWithStatus:@"已复制到剪切板!"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"复制文字内容不存在!"];
    }
}

/**
 下载图片
 */
- (void)downImgView {
    if (self.model.video_url.isValid) {
        [self playerDownload:self.model.video_url];
    } else {
        if (self.model.content.isValid) {
            NSArray *imgs = [self.model.content componentsSeparatedByString:@","];

            for (NSString *str in imgs) {
                [self toSaveImage:str];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"图片资源不存在!"];
        }
    }
}

- (void)toSaveImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    //从网络下载图片
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

/* 保存图片完成之后的回调 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL) {
        // Show error message…
        [SVProgressHUD showErrorWithStatus:@"图片保存失败"];
    } else {
        // Show message image successfully saved
        [self updateCount:@2];
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
}

/* 下载视频 */
- (void)playerDownload:(NSString *)url {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       [self saveVideo:fullPath];
                   }];
    [task resume];
}

/* videoPath为视频下载到本地之后的本地路径 */
- (void)saveVideo:(NSString *)videoPath {
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"视频保存失败"];
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
        [self updateCount:@2];
        [SVProgressHUD showSuccessWithStatus:@"保存视频成功"];
    }
}
//统计下载图片 视频的次数
- (void)updateCount:(NSNumber *)num {
    WeakObj(self);
    [LxmNetworking networkingPOST:count_down_num parameters:@{@"token":SESSION_TOKEN,@"judge_id":self.model.id,@"type":num} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            if (num.intValue == 1) {
                NSInteger titleNum = selfWeak.model.title_num.intValue;
                titleNum ++;
                selfWeak.model.title_num = @(titleNum).stringValue;
            } else {
                NSInteger mediaNum = selfWeak.model.media_num.intValue;
                mediaNum ++;
                selfWeak.model.media_num = @(mediaNum).stringValue;
            }
            [LxmEventBus sendEvent:@"countAdd" data:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end


/**
 分类标识
 */

@implementation LxmFenLeiBiaoShiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self addSubview:self.statelabel];
        [self addSubview:self.lineView];
        [self.statelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(85);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(@20);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@1);
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

- (UILabel *)statelabel {
    if (!_statelabel) {
        _statelabel = [UILabel new];
        _statelabel.font = [UIFont systemFontOfSize:12];
        _statelabel.textColor = MainColor;
        _statelabel.layer.cornerRadius = 10;
        _statelabel.layer.borderColor = MainColor.CGColor;
        _statelabel.layer.masksToBounds = YES;
        _statelabel.layer.borderWidth = 0.5;
    }
    return _statelabel;
}

@end
