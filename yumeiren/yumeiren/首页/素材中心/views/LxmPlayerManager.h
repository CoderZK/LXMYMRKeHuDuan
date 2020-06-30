//
//  LxmPlayerManager.h
//  yumeiren
//
//  Created by 李晓满 on 2019/8/3.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmMoviePlayerView.h"

@interface LxmPlayerManager : NSObject

+ (instancetype)sharedInstance;

+ (void)addPlayer:(LxmMoviePlayerView *)player;

+ (void)stopOtherPlayerFor:(LxmMoviePlayerView *)player;
@end
