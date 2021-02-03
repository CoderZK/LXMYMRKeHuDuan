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
@interface YMRShareXinDeVC ()
@property(nonatomic,strong)YMRLuYinView *luYinView;
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
            
        }else if (index == 104) {
            //保存
            
        }
    };
    
}


@end
