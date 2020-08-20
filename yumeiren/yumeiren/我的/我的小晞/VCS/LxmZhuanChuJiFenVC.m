//
//  LxmZhuanChuJiFenVC.m
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmZhuanChuJiFenVC.h"

@interface LxmZhuanChuJiFenVC ()
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;

@end

@implementation LxmZhuanChuJiFenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"转出小晞";
    self.confirmBt.layer.cornerRadius = 5;
    self.nameLB.text = [NSString stringWithFormat:@"转给: %@",self.top_name];
    self.confirmBt.clipsToBounds = YES;
}
- (IBAction)confirmBt:(id)sender {
    if (self.TF.text.length  ==0 ){
        [SVProgressHUD showErrorWithStatus:@"请输入转出小晞"];
        return;
    }
    
    if (self.TF.text.doubleValue > self.jifen) {
        [SVProgressHUD showErrorWithStatus:@"小晞不足!"];
        return;
    }
    
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"infoType"] = @"2";
    dict[@"score"] = self.TF.text;
    dict[@"token"] =  SESSION_TOKEN;
    
    [LxmNetworking networkingPOST:give_score parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           [SVProgressHUD dismiss];
           if ([responseObject[@"key"] integerValue] == 1000) {
               [LxmEventBus sendEvent:@"jifentiqu" data:@{@"scoreType":@(2),@"money":self.TF.text}];
               [SVProgressHUD showSuccessWithStatus:@"申请转出小晞成功!"];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self.navigationController popViewControllerAnimated:YES];
               });
               
               
               
           }  else {
               [UIAlertController showAlertWithmessage:responseObject[@"message"]];
           }
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           [SVProgressHUD dismiss];
       }];
    
}


@end
