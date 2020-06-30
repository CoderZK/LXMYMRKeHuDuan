//
//  LxmMovieProgressView.m
//  ttt
//
//  Created by lxm on 16/1/13.
//  Copyright © 2016年 lxm. All rights reserved.
//

#import "LxmMovieProgressView.h"

@interface LxmMovieProgressView ()
{
    UIProgressView * _progressView;
}
@end

@implementation LxmMovieProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setThumbImage:[UIImage imageNamed:@"icon_sliderImage"] forState:UIControlStateNormal];
        [self setMinimumTrackTintColor:[UIColor clearColor]];
        [self setMaximumTrackTintColor:[UIColor clearColor]];

        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, (frame.size.height-1.5)*0.5, frame.size.width, 1.5)];
        _progressView.progress = 0;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressTintColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:182/255.0 alpha:1];
        _progressView.trackTintColor = [UIColor colorWithRed:251/255.0 green:62/255.0 blue:7/255.0 alpha:1];
        [self addSubview:_progressView];
        
    }
    return self;
}

-(void)setCacheValue:(CGFloat)cacheValue
{
    if (!isnan(cacheValue))
    {
        _cacheValue = cacheValue;
        if (cacheValue>0)
        {
            if (self.maximumValue>0)
            {
                if (_cacheValue/self.maximumValue >= _progressView.progress) {
                    [_progressView setProgress:_cacheValue/self.maximumValue animated:YES];
                } else {
                    [_progressView setProgress:_cacheValue/self.maximumValue animated:NO];
                }
            }
            else
            {
                _progressView.progress = 0;
            }
        }
        else
        {
            _progressView.progress = 0;
        }

    }
}
@end
