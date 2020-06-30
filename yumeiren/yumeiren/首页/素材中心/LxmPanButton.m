//
//  LxmPanButton.m
//  peiqiwu
//
//  Created by 李晓满 on 2019/5/30.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmPanButton.h"

@interface LxmPanButton()

@property (nonatomic, strong) UIButton *bgView;

@end


@implementation LxmPanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
        
        [self addSubview:self.bgView];

        [self addSubview:self.iconImgView];
    
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIButton *)bgView {
    if (!_bgView) {
        _bgView = [[UIButton alloc] init];
        _bgView.backgroundColor = UIColor.clearColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        [_bgView addTarget:self action:@selector(panClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"publish"];
    }
    return _iconImgView;
}


- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    //移动状态
    UIGestureRecognizerState recState = recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:self.superview];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        } break;
            
        case UIGestureRecognizerStateEnded: {
            CGSize superViewSize = self.superview.bounds.size;
            CGPoint stopPoint = CGPointMake(0, superViewSize.height / 2.0);
            CGFloat lSpace = self.marginInsets.left + self.bounds.size.width * 0.5;
            CGFloat rSpace = superViewSize.width - self.bounds.size.width * 0.5 - self.marginInsets.right;
            CGFloat tSpace = self.marginInsets.top + self.bounds.size.height * 0.5;
            CGFloat bSpace = superViewSize.height - self.bounds.size.height * 0.5 - self.marginInsets.bottom;
            if (recognizer.view.center.x < superViewSize.width / 2.0) {
                if (recognizer.view.center.y <= superViewSize.height/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x + 15, tSpace + 15);
                    } else {
                        stopPoint = CGPointMake(lSpace + 15, recognizer.view.center.y + 15);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= (superViewSize.height - recognizer.view.center.y)) {
                        stopPoint = CGPointMake(recognizer.view.center.x + 15, bSpace - 15);
                    } else {
                        stopPoint = CGPointMake(lSpace + 15, recognizer.view.center.y - 15);
                    }
                }
            } else {
                if (recognizer.view.center.y <= superViewSize.height/2.0) {
                    //右上
                    if (superViewSize.width - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x - 15, tSpace + 15);
                    }else{
                        stopPoint = CGPointMake(rSpace - 15, recognizer.view.center.y + 15);
                    }
                } else {
                    //右下
                    if (superViewSize.width - recognizer.view.center.x  >= superViewSize.height - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x - 15, bSpace - 15);
                    } else {
                        stopPoint = CGPointMake(rSpace - 15, recognizer.view.center.y - 15);
                    }
                }
            }
            
            if (stopPoint.x < lSpace) {
                stopPoint.x = lSpace;
            }
            if (stopPoint.x > rSpace) {
                stopPoint.x = rSpace;
            }
            if (stopPoint.y < tSpace) {
                stopPoint.y = tSpace;
            }
            if (stopPoint.y > bSpace) {
                stopPoint.y = bSpace;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}

- (void)panClick {
    if (self.panBlock) {
        self.panBlock();
    }
}

@end
