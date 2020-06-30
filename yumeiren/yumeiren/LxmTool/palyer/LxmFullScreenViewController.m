//
//  LxmFullScreenViewController.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/3.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmFullScreenViewController.h"

@interface LxmFullScreenViewController ()

@end

@implementation LxmFullScreenViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (_player) {
        [_player removeFromSuperview];
        [self.view addSubview:_player];
        [_player mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    UIButton *back = [[UIButton alloc] init];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(15);
    }];
}

- (void)close {
    [self btnClick];
}

- (void)btnClick {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}


@end
