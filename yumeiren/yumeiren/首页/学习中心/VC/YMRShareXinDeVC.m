//
//  YMRShareXinDeVC.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRShareXinDeVC.h"
#import "YMRLuYinView.h"
#import "YMRAddMusicTVC.h"
#import "ALCAudioTool.h"
#import "YMRShowBackView.h"
#import "YMRXueXiJiHuaTVC.h"
#import "YMRShowLuYinView.h"
@interface YMRShareXinDeVC ()
@property(nonatomic,strong)YMRLuYinView *luYinView;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,assign)BOOL isBack;
@property (nonatomic, assign) NSInteger timeNumber;
@end

@implementation YMRShareXinDeVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ALCAudioTool shareTool] stopAll];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分享心得";
    
    
    UIImageView * imageV  = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"fenxiang"];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.font = [UIFont boldSystemFontOfSize:30];
    self.titleLB.textColor = MainColor;
    [self.view addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    
    self.titleLB.text = self.shareWord;
    
    [self initBottomView];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
    leftItem.tintColor = CharacterDarkColor;
        //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)baseLeftBtnClick {
    
    if ([self.luYinView.luYinBt.currentBackgroundImage isEqual:[UIImage imageNamed:@"zanting"]] || [self.luYinView.luYinBt.currentBackgroundImage isEqual:[UIImage imageNamed:@"luyinzhong"]]) {
        
        WeakObj(self);
        YMRShowBackView * view  = [[YMRShowBackView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [view show];
        view.clickGoBlock = ^(NSInteger tag) {
            if (tag == 101) {
                
                [[ALCAudioTool shareTool] reStartRecord];
                [[ALCAudioTool shareTool] stopMp3];
                [selfWeak.luYinView.luYinBt setBackgroundImage:[UIImage imageNamed:@"luyinzhong"] forState:UIControlStateNormal];
                selfWeak.luYinView.showViewOne = NO;
                [selfWeak.luYinView.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
                
            }else {
                
                for (UIViewController * vc in  self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[YMRXueXiJiHuaTVC class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        
        
    }else {
        for (UIViewController * vc in  self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[YMRXueXiJiHuaTVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)initBottomView  {
    
    self.luYinView  = [[YMRLuYinView alloc] init];
    [self.view addSubview:self.luYinView];
    [self.luYinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@(230 + TableViewBottomSpace));
    }];
    WeakObj(self);
    self.luYinView.clickButtonBlock = ^(NSInteger index) {
        if (index == 100) {
            // 点击配乐
            YMRAddMusicTVC * vc =[[YMRAddMusicTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
            vc.hidesBottomBarWhenPushed = YES;
            vc.sendMusicBlock = ^(NSString * _Nonnull musicStr) {
                
              
//                [selfWeak palyWithMust:musicStr];
                
                [[ALCAudioTool shareTool] palyMp3WithNSSting:musicStr isLocality:NO];
                [selfWeak.luYinView.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
                selfWeak.luYinView.showViewOne = YES;
            };
            selfWeak.isBack = YES;
            [selfWeak.navigationController pushViewController:vc animated:YES];
            
        }else if (index == 101) {
            //试听
            [[ALCAudioTool shareTool] playRecord];
        }
//        else if (index == 104) {
//            //保存
//            YMRShareXinDeVC * vc =[[YMRShareXinDeVC alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [selfWeak.navigationController pushViewController:vc animated:YES];
//        }
    };
    self.luYinView.sendDataBlock = ^(NSInteger timeNumber, NSData * _Nonnull data) {
        [selfWeak uploadVedioWithData:data];
        selfWeak.timeNumber = timeNumber;
        [ALCAudioTool shareTool].timeNumber = 0;
        [selfWeak.luYinView.luYinBt setBackgroundImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];
//        [SVProgressHUD show];
    };
    
}

- (void)uploadVedioWithData:(NSData *)data {
    WeakObj(self);
//    [SVProgressHUD show];
    NSString * token = [LxmTool ShareTool].qiNiu_token;
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:[NSString stringWithFormat:@"%0.0f.mp3", [[NSDate date] timeIntervalSince1970]] token:token
    complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
//        [SVProgressHUD dismiss];
        [selfWeak upLoadOneWorkWith:[NSString stringWithFormat:@"%@%@",QiNiuYunURL,resp[@"key"]]];
    } option:nil];
    


}


- (void)upLoadOneWorkWith:(NSString *)url  {
    
    [SVProgressHUD show];
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = SESSION_TOKEN;
    dict[@"twoWork"] = [@{@"url":url,@"time":@(self.timeNumber)} mj_JSONString];
    dict[@"articleId"] = self.articleId;
    [LxmNetworking networkingPOST:do_card_work parameters:dict returnClass:LxmClassDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmClassDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            
           
            YMRShowLuYinView * vv = [[YMRShowLuYinView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            vv.desStr  = @"心得分享成功";
            [vv show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                for (UIViewController * vc in  self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[YMRXueXiJiHuaTVC class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
           
            
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

- (void)getQiNiuToken {
   
    [LxmNetworking networkingPOST:get_qiniu_token parameters:@{@"token":SESSION_TOKEN} returnClass:LxmClassDetailRootModel.class success:^(NSURLSessionDataTask *task, LxmClassDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1000) {
            [LxmTool ShareTool].qiNiu_token = responseObject.result.token;
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
