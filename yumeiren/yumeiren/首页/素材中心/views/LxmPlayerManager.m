//
//  LxmPlayerManager.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/3.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPlayerManager.h"

@interface LxmPlayerManager ()
@property (nonatomic, strong) NSHashTable<LxmMoviePlayerView *> *playerArr;
@end

@implementation LxmPlayerManager

+ (instancetype)sharedInstance {
    static LxmPlayerManager *__LxmPlayerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __LxmPlayerManager = [LxmPlayerManager new];
    });
    return __LxmPlayerManager;
}

- (NSHashTable<LxmMoviePlayerView *> *)playerArr {
    if (!_playerArr) {
        _playerArr = [NSHashTable weakObjectsHashTable];
    }
    return _playerArr;
}

+ (void)addPlayer:(LxmMoviePlayerView *)player {
    if (player && ![LxmPlayerManager.sharedInstance.playerArr containsObject:player]) {
        [LxmPlayerManager.sharedInstance.playerArr addObject:player];
    }
}

+ (void)stopOtherPlayerFor:(LxmMoviePlayerView *)player {
    for (LxmMoviePlayerView *tmp in LxmPlayerManager.sharedInstance.playerArr) {
        if (tmp != player) {
            [tmp pause];
        }
    }
}

@end
