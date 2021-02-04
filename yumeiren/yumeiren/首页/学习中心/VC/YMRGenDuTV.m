//
//  YMRGenDuTV.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRGenDuTV.h"
#import "YMRLuYinView.h"
#import "YMRAddMusicTVC.h"
#import "ALCAudioTool.h"
#import "YMRShareXinDeVC.h"
#import "LxmClassInfoDetailVC.h"
@interface YMRGenDuTV ()
@property(nonatomic,strong)YMRLuYinView *luYinView;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,strong)AVAudioPlayer *audioPlay;
@end

@implementation YMRGenDuTV

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ALCAudioTool shareTool] stopAll];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要跟读";

    [self initBottomView];
    [self getQiNiuToken];
    
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
                selfWeak.luYinView.showViewOne = YES;
            };
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
    };
   
}

- (void)palyWithMust:(NSString *)str  {
     NSError * error;
          //初始化播放器对象
//      self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:str] error:&error];
    self.audioPlay = [[AVAudioPlayer alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:str]] error:&error];
          //设置声音的大小
    self.audioPlay.volume = 0.5;//范围为（0到1）；
          //设置循环次数，如果为负数，就是无限循环
    self.audioPlay.numberOfLoops =-1;
          //设置播放进度
    self.audioPlay.currentTime = 0;
          //准备播放
          [self.audioPlay prepareToPlay];
          [self.audioPlay play];
}


- (void)uploadVedioWithData:(NSData *)data {
    [SVProgressHUD showWithStatus:@"音频上传中..."];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:@"5JQLMS9FK-jx_i8QpKKoGZZy5Cz4p85_a1scuCsG" token:[LxmTool ShareTool].qiNiu_token
    complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
        [SVProgressHUD dismiss];
    } option:nil];
    
//    [LxmNetworking NetWorkingUpLoad:QiNiuYunUploadURL fileData:data andFileName:@"file" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        if ([responseObject[@"key"] integerValue] == 1000) {
//
//        } else {
//            [SVProgressHUD dismiss];
//            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
    

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.detailModel.titleH;
    }  else{
        return self.detailModel.contentH;
    }
    
    
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LxmClassInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoTitleCell"];
        if (!cell) {
            cell = [[LxmClassInfoTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoTitleCell"];
        }
        cell.detailModel = self.detailModel;
        return cell;
    } else {
        LxmClassInfoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmClassInfoDetailCell"];
        if (!cell) {
            cell = [[LxmClassInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmClassInfoDetailCell"];
        }
        cell.detailModel = self.detailModel;
        return cell;
    }
   
    
}


@end
