//
//  LxmClassInfoDetailVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/3/10.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmClassInfoDetailVC.h"
#import "LxmPlayer.h"
#import "LxmMoviePlayerView.h"
#import "LxmFullScreenViewController.h"

@interface LxmClassInfoDetailVC ()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmClassDetailModel *detailModel;

@property (nonatomic, strong) LxmGoodsDetailTuPianModel *tupianModel;

@end

@implementation LxmClassInfoDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    [self loadDetailData];
}

- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmClassInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoTitleCell"];
        if (!cell) {
            cell = [[LxmClassInfoTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoTitleCell"];
        }
        cell.detailModel = self.detailModel;
        return cell;
    } else if (indexPath.row == 1) {
        if (self.detailModel.infoType.intValue == 1 || self.detailModel.infoType.intValue == 3) {//图文教程//视频教程
            LxmClassInfoVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoVideoCell"];
            if (!cell) {
                cell = [[LxmClassInfoVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoVideoCell"];
            }
            cell.detailModel = self.detailModel;
            return cell;
        } else {//音频教程
            LxmClassInfoYuyinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoYuyinCell"];
            if (!cell) {
                cell = [[LxmClassInfoYuyinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoYuyinCell"];
            }
            cell.detailModel = self.detailModel;
            return cell;
        }
    } else {
        LxmClassInfoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoDetailCell"];
        if (!cell) {
            cell = [[LxmClassInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoDetailCell"];
        }
        cell.detailModel = self.detailModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.detailModel.titleH;
    } else if (indexPath.row == 1) {
        if (self.detailModel.infoType.intValue == 1 || self.detailModel.infoType.intValue == 3) {//图文教程//视频教程
            if (self.detailModel.imagePath.isValid) {
                return ScreenW * self.tupianModel.height / self.tupianModel.width;
            }
            return 240;
        } else {
            return 50;
        }
    } else{
        return self.detailModel.contentH;
    }
}

/// 详情
- (void)loadDetailData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:course_detail parameters:@{@"token":SESSION_TOKEN, @"id":self.classId} returnClass:LxmClassDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmClassDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            selfWeak.detailModel = responseObject.result.data;
            if (selfWeak.detailModel.infoType.intValue == 1) {
                if (selfWeak.detailModel.imagePath.isValid) {
                    NSArray *arr = [selfWeak.detailModel.imagePath mj_JSONObject];
                    if ([arr isKindOfClass:NSArray.class]) {
                        if (arr.count >= 1) {
                            NSDictionary *dic = arr[0];
                            selfWeak.tupianModel = [LxmGoodsDetailTuPianModel mj_objectWithKeyValues:dic];
                            selfWeak.detailModel.listPic = selfWeak.tupianModel.url;
                            [selfWeak.tableView reloadData];
                        }
                    }
                    
                }
            } else if (selfWeak.detailModel.infoType.intValue == 3) {
                if (selfWeak.detailModel.imagePath.isValid) {
                    NSDictionary *dict = [selfWeak.detailModel.imagePath mj_JSONObject];
                    selfWeak.tupianModel = [LxmGoodsDetailTuPianModel mj_objectWithKeyValues:dict];
                    selfWeak.detailModel.listPic = selfWeak.tupianModel.url;
                    [selfWeak.tableView reloadData];
                }
            }
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end


/// 标题
@interface LxmClassInfoTitleCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation LxmClassInfoTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"烟花要开始放了，我们先是像是听到了一声鸟叫，看到了一颗闪闪发光的小球冲上天，然后“嘭”的一声爆炸了.";
    }
    return _titleLabel;
}

- (void)setDetailModel:(LxmClassDetailModel *)detailModel {
    _detailModel = detailModel;
    _titleLabel.text = _detailModel.title;
}

@end

/// 语音
@interface LxmClassInfoYuyinCell ()

@property (nonatomic, strong) LxmPlayer *audioPlayer;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UILabel *endTimeLabel;

@property (nonatomic, strong) UIImageView *imgView;

@end
@implementation LxmClassInfoYuyinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)setDetailModel:(LxmClassDetailModel *)detailModel {
    _detailModel = detailModel;
    if (!_audioPlayer) {
        _audioPlayer = [[LxmPlayer alloc] init];
        __weak typeof(self) weak_self = self;
        [_audioPlayer setStateBlock:^(LxmPlayerState state) {
            if (state == LxmPlayerState_playing) {
                weak_self.playButton.selected = YES;
            } else {
                weak_self.playButton.selected = NO;
            }
        } timeBlock:^(NSInteger position, NSInteger duration) {
            if (duration != 0) {
                weak_self.progressView.progress = position * 1.0 / duration;
            }
            weak_self.startTimeLabel.text = [LxmPlayer timeStrWithInt:position];
            weak_self.endTimeLabel.text = [LxmPlayer timeStrWithInt:duration];
        }];
    }
//    [_audioPlayer setPlayUrl:@"http://xia2.kekenet.com/Sound/2019/08/m200016581_1484302841_1444410KGM.mp3"];
    [_audioPlayer setPlayUrl:_detailModel.mp3Path];
}


- (void)playButtonClick:(UIButton *)btn {
    if (_audioPlayer.state != LxmPlayerState_playing) {
        [_audioPlayer play];
    } else {
        [_audioPlayer pause];
    }
}

- (void)initSubViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.playButton];
    [self.bgView addSubview:self.progressView];
    [self.bgView addSubview:self.startTimeLabel];
    [self.bgView addSubview:self.endTimeLabel];
    [self.bgView addSubview:self.imgView];
}

- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.leading.equalTo(self.bgView).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playButton.mas_trailing).offset(10);
        make.bottom.equalTo(self.bgView.mas_centerY).offset(2);
        make.trailing.equalTo(self.bgView).offset(-50);
        make.height.equalTo(@3);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(3);
        make.leading.equalTo(self.progressView);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(3);
        make.trailing.equalTo(self.progressView);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.trailing.equalTo(self.bgView).offset(-15);
        make.width.height.equalTo(@20);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:253/255.0 green:213/255.0 blue:207/255.0 alpha:1];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"audio-visual_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"audio_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        _progressView.progressTintColor = UIColor.whiteColor;
        _progressView.progress = 0.0;
    }
    return _progressView;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.7];
        _startTimeLabel.font = [UIFont systemFontOfSize:12];
        _startTimeLabel.text = @"00:00";
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel new];
        _endTimeLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.73];
        _endTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _endTimeLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"yinpin"];
    }
    return _imgView;
}

@end

/// 详情
@interface LxmClassInfoDetailCell ()

@property (nonatomic, strong) UILabel *detailLabel;

@end
@implementation LxmClassInfoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.leading.equalTo(self).offset(15);
           make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (void)setDetailModel:(LxmClassDetailModel *)detailModel {
    _detailModel = detailModel;
    _detailLabel.text = _detailModel.content;
}

@end

@interface LxmClassInfoVideoCell () <LxmMoviePlayerViewDelegate>
@property (nonatomic, weak) LxmFullScreenViewController *fullScreenVC;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) LxmMoviePlayerView *playView;
@end

@implementation LxmClassInfoVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _playView = [[LxmMoviePlayerView alloc] init];
        _playView.delegate = self;
        [self addSubview:_playView];
        [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _coverImgView = [UIImageView new];
        [self addSubview:_coverImgView];
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _playBtn = [[UIButton alloc] init];
        _playBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _playBtn.layer.cornerRadius = 22;
        _playBtn.layer.masksToBounds = YES;
        [_playBtn setImage:[UIImage imageNamed:@"audio-visual_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(@44);
        }];
    }
    return self;
}

- (void)playClick {
    [_playView rePlay];
    [_playBtn removeFromSuperview];
    [_coverImgView removeFromSuperview];
}

- (void)setDetailModel:(LxmClassDetailModel *)detailModel {
    _detailModel = detailModel;
    _playView.hidden = _detailModel.infoType.intValue == 1;
    _playBtn.hidden = _detailModel.infoType.intValue == 1;
//    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:@"https://vedio.hkymr.com/2019092114471715015478266113.png"]];
     [_coverImgView sd_setImageWithURL:[NSURL URLWithString:_detailModel.listPic]];
    if (_detailModel.infoType.intValue == 3) {
//        _playView.contentURL = [NSURL URLWithString:@"http://cctvalih5ca.v.myalicdn.com/live/cctv1_2/index.m3u8"];
        _playView.contentURL = [NSURL URLWithString:_detailModel.videoPath];
    }
}

-(void)LxmMoviePlayerView:(LxmMoviePlayerView *)view clickBtnAt:(LxmMoviePlayerViewBtnType)type {
    if (type == LxmMoviePlayerViewBtnType_rotate) {
        if (_playView.superview == self) {
            LxmFullScreenViewController *vc = [LxmFullScreenViewController new];
            vc.player = self.playView;
            vc.dismissBlock = ^{
                [self.playView removeFromSuperview];
                [self addSubview:self.playView];
                [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
            };
            [[UIViewController topViewController] presentViewController:vc animated:NO completion:nil];
            self.fullScreenVC = vc;
        } else {
            [self.fullScreenVC close];
        }
    }
}

-(void)LxmMoviePlayerViewPlayFinished:(LxmMoviePlayerView *)view {
    
}

@end
