//
//  LxmPlayer.h
//  yumeiren
//
//  Created by 李晓满 on 2020/3/23.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LxmPlayerState) {
    LxmPlayerState_prepare, // 准备中
    LxmPlayerState_playing, // 播放中
    LxmPlayerState_pause,   // 暂停中
    LxmPlayerState_stop     // 停止
};

@interface LxmPlayer : NSObject

@property (nonatomic, readonly) LxmPlayerState state;
@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, readonly) NSInteger duration;

- (void)setPlayUrl:(NSString *)playUrl;
- (void)setStateBlock:(void(^)(LxmPlayerState state))stateBlock timeBlock:(void(^)(NSInteger position, NSInteger duration))timeBlock;

- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToPosition:(NSInteger)position;

+ (NSString *)timeStrWithInt:(NSInteger)time;

@end
