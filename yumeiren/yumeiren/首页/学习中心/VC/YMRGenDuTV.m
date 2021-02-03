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
@interface YMRGenDuTV ()
@property(nonatomic,strong)YMRLuYinView *luYinView;
@property(nonatomic,assign)BOOL isBack;
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
                [[ALCAudioTool shareTool] palyMp3WithNSSting:musicStr isLocality:NO];
                selfWeak.luYinView.showViewOne = YES;
            };
            [selfWeak.navigationController pushViewController:vc animated:YES];
            
        }else if (index == 101) {
            //试听
            [[ALCAudioTool shareTool] playRecord];
        }else if (index == 104) {
            //保存
            YMRShareXinDeVC * vc =[[YMRShareXinDeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        }
    };
   
}


@end
