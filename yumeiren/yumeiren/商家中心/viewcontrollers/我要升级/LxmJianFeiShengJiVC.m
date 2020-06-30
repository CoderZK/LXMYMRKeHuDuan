//
//  LxmJianFeiShengJiVC.m
//  yumeiren
//
//  Created by 李晓满 on 2020/2/26.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJianFeiShengJiVC.h"
#import "LxmShengJiVC.h"
#import "LxmShengJiTiaoJianVC.h"

@interface LxmJianFeiShengJiVC ()

@end

@implementation LxmJianFeiShengJiVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_jianbian2"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:UIColor.whiteColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbarwhite"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = CharacterDarkColor;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:CharacterDarkColor,
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                    };
    self.navigationItem.leftBarButtonItem.tintColor = CharacterDarkColor;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"减肥单项";
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.jianfeiArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmShengJiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmShengJiCell"];
    if (!cell) {
        cell = [[LxmShengJiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmShengJiCell"];
    }
    cell.jianfeiModel = self.jianfeiArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmShengjiModel *model = self.jianfeiArr[indexPath.section];
    if (model.inStatus.intValue == 7 || model.inStatus.intValue == 8) {
        return;
    }
    bool ishave = NO;
    LxmShengjiModel *temp = nil;
    for (LxmShengjiModel *model in self.jianfeiArr) {
        if (model.inStatus.intValue < 6) {
            ishave = YES;
            temp = model;
            break;
        }
    }
    if (ishave) {
        if (temp == model) {
            LxmShengJiTiaoJianVC *vc = [[LxmShengJiTiaoJianVC alloc] init];
            vc.model = model;
            vc.orderID = self.orderID;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"你当前有正在升级的状态,请先完成升级"];
            return;
        }
    } else {
        LxmShengJiTiaoJianVC *vc = [[LxmShengJiTiaoJianVC alloc] init];
        vc.model = model;
        vc.orderID = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
