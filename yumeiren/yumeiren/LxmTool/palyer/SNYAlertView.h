//
//  SNYAlertView.h
//  suzhouIOS
//
//  Created by sny on 16/2/18.
//  Copyright © 2016年 sny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SNYAlertView : NSObject
+(void)showAlertWithMsg:(NSString *)msg;
+(void)showAlertWithMsg:(NSString *)msg title:(NSString *)title;

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                   leftTitle:(NSString *)leftTitle
                   leftBlock:(void (^)(void))leftBlock
                  rightTitle:(NSString *)rightTitle
                  rightBlock:(void (^)(void))rightBlock;

-(void)showAtVC:(UIViewController *)vc;

@end
