//
//  SNYAlertView.m
//  suzhouIOS
//
//  Created by sny on 16/2/18.
//  Copyright © 2016年 sny. All rights reserved.
//

#import "SNYAlertView.h"

@interface SNYAlertView ()<UIAlertViewDelegate>
{
    UIAlertView * _alertView;
    UIAlertController * _alertController;
    void (^_leftBlock)(void);
    void (^_rightBlock)(void);
}
@end

@implementation SNYAlertView

+(void)showAlertWithMsg:(NSString *)msg
{
    [self showAlertWithMsg:msg title:nil];
}
+(void)showAlertWithMsg:(NSString *)msg title:(NSString *)title
{
    [[[SNYAlertView alloc] initWithTitle:title message:msg leftTitle:@"确定" leftBlock:nil rightTitle:nil rightBlock:nil] showAtVC:nil];
}

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                   leftTitle:(NSString *)leftTitle
                   leftBlock:(void (^)(void))leftBlock
                  rightTitle:(NSString *)rightTitle
                  rightBlock:(void (^)(void))rightBlock
{
    if (self=[super init])
    {
        _leftBlock = leftBlock;
        _rightBlock = rightBlock;
        
        if ([UIDevice currentDevice].systemVersion.floatValue>=8.0)
        {
            _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            if (leftTitle)
            {
                [_alertController addAction:[UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (_leftBlock)
                    {
                        _leftBlock();
                    }
                    
                }]];
            }
            if (rightTitle)
            {
                [_alertController addAction:[UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (_rightBlock)
                    {
                        _rightBlock();
                    }
                    
                }]];
            }
        }
        else
        {
            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:leftTitle,rightTitle, nil];
        }

        
    }
    return self;
}
-(void)showAtVC:(UIViewController *)vc
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0)
    {
        if (vc)
        {
            [vc presentViewController:_alertController animated:YES completion:nil];
        }
        else
        {
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:_alertController animated:YES completion:nil];
        }
        
    }
    else
    {
        [_alertView show];
    }
}

@end
