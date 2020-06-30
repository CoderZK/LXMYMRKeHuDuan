//
//  LxmPlayer.m
//  yumeiren
//
//  Created by 李晓满 on 2020/3/23.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface LxmPlayer ()
{
    id _timeOb;
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, strong) NSString *playUrl;

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) void(^stateBlock)(LxmPlayerState state);
@property (nonatomic, copy) void(^timeBlock)(NSInteger position, NSInteger duration);

@end

@implementation LxmPlayer

- (void)dealloc
{
    [_player removeObserver:self forKeyPath:@"rate"];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_player removeTimeObserver:_timeOb];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _timeOb = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            AVPlayerItem *item = weakSelf.playItem;
            NSInteger currentTime = CMTimeGetSeconds(item.currentTime);
            NSInteger totalTime = CMTimeGetSeconds(item.duration);
            if (totalTime > 0) {
                weakSelf.duration = totalTime;
                weakSelf.position = currentTime;
                if (weakSelf.timeBlock) {
                    weakSelf.timeBlock(currentTime, totalTime);
                }
            }
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)playbackFinished:(NSNotification *)notification {
    if (_player.currentItem == notification.object) {
        [self pause];
        [_player seekToTime:kCMTimeZero];
        [self notiStateChanged:LxmPlayerState_stop];
    }
}

- (void)setPlayUrl:(NSString *)playUrl {
    if (!playUrl || [_playUrl isEqualToString:playUrl]) {
        return;
    }
    _playUrl = playUrl;
    [self notiStateChanged:LxmPlayerState_prepare];
    _playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playUrl]];
    [_player replaceCurrentItemWithPlayerItem:_playItem];
}

- (void)setStateBlock:(void(^)(LxmPlayerState state))stateBlock timeBlock:(void(^)(NSInteger position, NSInteger duration))timeBlock {
    _stateBlock = stateBlock;
    _timeBlock = timeBlock;
}

- (void)notiStateChanged:(LxmPlayerState)state {
    _state = state;
    if (self.stateBlock) {
        self.stateBlock(self.state);
    }
}

- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [_player pause];
    [_player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
}

- (void)seekToPosition:(NSInteger)position {
    [_playItem seekToTime:CMTimeMake(position, 1)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        NSLog(@"rate:%@",change);
        if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue]==0) {
            [self notiStateChanged:LxmPlayerState_pause];
        } else if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue]==1) {
            [self notiStateChanged:LxmPlayerState_playing];
        }
    }
}

+ (NSString *)timeStrWithInt:(NSInteger)time {
    NSInteger m = time / 60;
    NSInteger s = time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)m, (long)s];
}

@end
