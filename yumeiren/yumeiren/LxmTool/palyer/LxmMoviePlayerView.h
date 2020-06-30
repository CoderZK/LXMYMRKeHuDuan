//
//  LxmMoviePlayerView.h
//  ttt
//
//  Created by lxm on 16/1/8.
//  Copyright © 2016年 lxm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    LxmMoviePlayerViewBtnType_play,
    LxmMoviePlayerViewBtnType_pause,
    LxmMoviePlayerViewBtnType_rotate

}LxmMoviePlayerViewBtnType;

@protocol LxmMoviePlayerViewDelegate;
@interface LxmMoviePlayerView : UIView


@property(nonatomic,assign,readonly)BOOL isplaying;
@property(nonatomic,assign,readonly)BOOL isbegingPlay;
@property(nonatomic,strong)NSURL * contentURL;

@property(nonatomic,assign)id<LxmMoviePlayerViewDelegate>delegate;

-(void)rePlay;
-(void)pause;
-(void)resume;

-(void)removeObserver;

@end

@protocol LxmMoviePlayerViewDelegate <NSObject>

@optional

-(void)LxmMoviePlayerView:(LxmMoviePlayerView *)view clickBtnAt:(LxmMoviePlayerViewBtnType)type;

-(void)LxmMoviePlayerViewPlayFinished:(LxmMoviePlayerView *)view;

@end
