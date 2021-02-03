//
//  YMRWenZhangYiWanChengListTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangYiWanChengListTVC.h"
#import "YMRFenXiangListCell.h"
@interface YMRWenZhangYiWanChengListTVC ()

@end

@implementation YMRWenZhangYiWanChengListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已完成任务";
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRFenXiangListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 145;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRFenXiangListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


@end
