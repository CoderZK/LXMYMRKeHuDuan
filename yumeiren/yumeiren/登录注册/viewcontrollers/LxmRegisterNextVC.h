//
//  LxmRegisterNextVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/28.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,LxmRegisterNextVC_type) {
    LxmRegisterNextVC_type_zczh,//注册账号2
    LxmRegisterNextVC_type_szmm,//1-手机号已注册，但是未绑定微信号
    LxmRegisterNextVC_type_nophone//手机号未注册过
};

@interface LxmRegisterNextVC : BaseTableViewController

//注册第一步 手机号和验证码
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *openID;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmRegisterNextVC_type)type;

@end

