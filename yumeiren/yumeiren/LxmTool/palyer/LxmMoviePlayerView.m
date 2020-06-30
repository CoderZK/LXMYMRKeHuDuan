//
//  LxmMoviePlayerView.m
//  ttt
//
//  Created by lxm on 16/1/8.
//  Copyright © 2016年 lxm. All rights reserved.
//

#import "LxmMoviePlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LxmMovieProgressView.h"
#import "SNYAlertView.h"

@interface LxmAfter : NSObject
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, assign) BOOL isCanceled;
@end

@implementation LxmAfter

+ (LxmAfter *)afterWithBlock:(dispatch_block_t)block after:(NSTimeInterval)after {
    LxmAfter *obj = [LxmAfter new];
    obj.block = block;
    [obj start:after];
    return obj;
}

- (void)start:(NSTimeInterval)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isCanceled && self.block) {
            self.block();
        }
    });
}

- (void)cancel {
    self.isCanceled = YES;
}

@end

@interface LxmMoviePlayerView ()
{
    UIView * _bottomView;
    UIButton * _playBtn;
    UIButton * _rotateBtn;
    LxmMovieProgressView * _slider;
    UILabel * _currentTimeLabel;
    UILabel * _allTimeLabel;
    
    AVPlayer * _player;
    
    UIActivityIndicatorView * _activityView;
    NSInteger _cache;
    

    
    BOOL _is4GCanPlay;
    BOOL _isFirst;
    BOOL _isObserver;
    LxmAfter *_after;
}
@end

@implementation LxmMoviePlayerView

- (void)dealloc {
    [self removeNotification];
    [self removeObserver];
}

- (void)removeObserver {
    _isbegingPlay = NO;
    @try {
        [_player pause];
        if (_isObserver) {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        }
        [_player setRate:0];
        [_player replaceCurrentItemWithPlayerItem:nil];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
}
+(Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        _is4GCanPlay = NO;
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _player = [[AVPlayer alloc] init];
        AVPlayerLayer * layer = (AVPlayerLayer *)self.layer;
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        layer.player = _player;
        [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
//
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [self addNotification];
        [self initBottomView];

        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.tintColor = [UIColor whiteColor];
        [self addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        _activityView.hidesWhenStopped=YES;

    }
    return self;
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.hidden = YES;
    [self addSubview:_bottomView];
    
    _playBtn = [[UIButton alloc] init];
    [_playBtn setImage:[UIImage imageNamed:@"audio-visual_play"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_bottomView addSubview:_playBtn];
    
    _rotateBtn = [[UIButton alloc] init];
    [_rotateBtn setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];
    [_rotateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_rotateBtn];
    
    _slider = [[LxmMovieProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpOutside];
    [_bottomView addSubview:_slider];
    
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.font = [UIFont systemFontOfSize:10];
    _currentTimeLabel.text = @"00:00:00";
    _currentTimeLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_currentTimeLabel];
    
    _allTimeLabel = [[UILabel alloc] init];
    _allTimeLabel.font = [UIFont systemFontOfSize:10];
    _allTimeLabel.text = @"/00:00:00";
    _allTimeLabel.textColor = [UIColor lightGrayColor];
    [_bottomView addSubview:_allTimeLabel];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(_bottomView);
        make.width.height.equalTo(@44);
    }];
    
    [_rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.equalTo(_bottomView);
        make.width.height.equalTo(@44);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_playBtn.mas_trailing);
        make.top.equalTo(_bottomView).equalTo(@10);
        make.trailing.equalTo(_rotateBtn.mas_leading);
        make.height.equalTo(@20);
    }];
    
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_playBtn.mas_trailing);
        make.top.equalTo(_slider.mas_bottom);
    }];
    
    [_allTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_currentTimeLabel.mas_trailing);
        make.top.equalTo(_slider.mas_bottom);
    }];
}

- (void)sliderValueChange:(LxmMovieProgressView *)slider {
    if (self.isplaying) {
        [self pause];
    }
    CMTime time = CMTimeMakeWithSeconds(slider.value, _player.currentTime.timescale);
    [_player seekToTime:time];
}

- (void)sliderTouchUpInside:(LxmMovieProgressView *)slider {
    if (!self.isplaying) {
        [self resume];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (btn==_playBtn) {
        if (_player.rate==1) {
            [self pause];
        } else {
            [self selfClickAtType:LxmMoviePlayerViewBtnType_play];
            if (_isbegingPlay) {
                _isplaying = NO;
                [self resume];
            } else {
                [self rePlay];
            }
            
        }
    } else if(btn==_rotateBtn) {
        [self selfClickAtType:LxmMoviePlayerViewBtnType_rotate];
    }
}

- (void)setContentURL:(NSURL *)contentURL {
    _contentURL = contentURL;
    _isFirst = YES;
}

- (void)showAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.alpha = 1;
        _bottomView.hidden = NO;
    } completion:nil];
}

- (void)hideAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.alpha = 0;
    } completion:^(BOOL finished) {
        _bottomView.hidden = YES;
    }];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self showAnimation];
    [_after cancel];
    WeakObj(self);
    _after = [LxmAfter afterWithBlock:^{
        StrongObj(self);
        [self hideAnimation];
    } after:5];
}

- (void)selfClickAtType:(LxmMoviePlayerViewBtnType)type {
    if ([self.delegate respondsToSelector:@selector(LxmMoviePlayerView:clickBtnAt:)]) {
        [self.delegate LxmMoviePlayerView:self clickBtnAt:type];
    }
}

- (void)resume {
    if (_isFirst) {
        _isFirst = NO;
        [self rePlay];
    } else {
        if (!_isplaying) {
            _isplaying = YES;
            _playBtn.selected = YES;
            [_player play];
            [_after cancel];
            WeakObj(self);
            _after = [LxmAfter afterWithBlock:^{
                StrongObj(self);
                [self hideAnimation];
            } after:5];
        }
    }
}

- (void)rePlay {
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN && !_is4GCanPlay) {
        [[[SNYAlertView alloc] initWithTitle:nil message:@"您现在使用的是运营商网络，继续观看可能产生超额流量费" leftTitle:@"继续播放" leftBlock:^{
            [self startPlayer];
            _is4GCanPlay = YES;
        } rightTitle:@"取消播放" rightBlock:nil] showAtVC:nil];
    } else {
        [self startPlayer];
    }
}

- (void)startPlayer {
    [_activityView startAnimating];
    if (_isObserver) {
        [self removeObserver];
    }
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:_contentURL];
    [_player replaceCurrentItemWithPlayerItem:playerItem];
    [self addObserverToPlayerItem];
    [self addProgressObserver];
    [self resume];
    _isbegingPlay = YES;
}

- (void)pause {
    _isplaying = NO;
    _playBtn.selected = NO;
    [_player pause];
    [self selfClickAtType:LxmMoviePlayerViewBtnType_pause];
}
#pragma mark - 通知
- (void)addNotification {
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification *)notification {
    if (_player.currentItem == notification.object) {
        NSLog(@"视频播放完成.");
        [self pause];
        [_player seekToTime:kCMTimeZero];
        _slider.value = 0;
        
        if ([self.delegate respondsToSelector:@selector(LxmMoviePlayerViewPlayFinished:)]) {
            [self.delegate LxmMoviePlayerViewPlayFinished:self];
        }
    }
}
#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
- (void)addProgressObserver {
    __weak typeof(self) safe_self = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^(CMTime time) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [safe_self updateProgress:time];
        });
    }];
}

- (void)updateProgress:(CMTime)time {
    float current=CMTimeGetSeconds(time);
    if (!isnan(current)) {
        _currentTimeLabel.text = [self getTimeFromNum:current];
        _slider.value = current;
    }
}

- (void)addObserverToPlayerItem {
    _isObserver = YES;
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem {
    _isObserver = NO;
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if(_player.currentItem.status==AVPlayerItemStatusReadyToPlay) {
            [_activityView stopAnimating];
            CGFloat duration = CMTimeGetSeconds(_player.currentItem.duration);
            if (!isnan(duration)) {
                _slider.maximumValue = duration;
                _allTimeLabel.text = [NSString stringWithFormat:@"/%@",[self getTimeFromNum:duration]];
            }
        } else {
            [_activityView stopAnimating];
            NSLog(@"未知错误");
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        CGFloat duration = CMTimeGetSeconds(_player.currentItem.duration);
        if (!isnan(duration)) {
            _slider.maximumValue = duration;
        }
        
        NSArray *array=_player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        if (!isnan(startSeconds) && !isnan(durationSeconds)) {
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            _cache = (NSInteger)totalBuffer;
            _slider.cacheValue = totalBuffer;
           //
            NSLog(@"共缓冲：%.2f",totalBuffer);
            
        }
    } else if ([keyPath isEqualToString:@"rate"]) {
        NSLog(@"rate:%@",change);
        if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue]==0) {
            _playBtn.selected = NO;
            _isplaying = NO;
        } else if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue]==1) {
            _playBtn.selected = YES;
            _isplaying = YES;
        }
    }
}

- (NSString *)getTimeFromNum:(CGFloat)time {
    if (time<=0) {
        return @"00:00:00";
    } else {
        int h = (int)time/3600;
        int m = ((int)time-h*3600)/60;
        int s = (int)time%60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
        
    }
}
@end
