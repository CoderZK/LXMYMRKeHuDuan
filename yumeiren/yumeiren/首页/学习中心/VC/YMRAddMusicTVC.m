//
//  YMRAddMusicTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRAddMusicTVC.h"
#import "YMRAddMusicCell.h"
@interface YMRAddMusicTVC ()

@end

@implementation YMRAddMusicTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加配乐";
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRAddMusicCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRAddMusicCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.sendMusicBlock != nil) {
        self.sendMusicBlock(@"http://m10.music.126.net/20210202170542/2e0fd5b8990fd84f6d2b400787f82f8b/ymusic/0799/f368/4d01/df9cb41f2ce16c6806e23b6b858948cd.mp3");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
