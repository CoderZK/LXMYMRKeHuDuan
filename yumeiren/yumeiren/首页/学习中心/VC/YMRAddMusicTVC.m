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
        self.sendMusicBlock(@"http://mp.333ttt.com/mp3music/86762.mp3");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
