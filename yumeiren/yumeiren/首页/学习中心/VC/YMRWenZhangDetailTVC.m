//
//  YMRWenZhangDetailTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRWenZhangDetailTVC.h"
#import "YMRFenXiangListCell.h"
#import "YMRGenDuTV.h"
@interface YMRWenZhangDetailTVC ()
@property(nonatomic,strong)UIView * bottomV;
@end

@implementation YMRWenZhangDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRFenXiangListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initBottomView];
    
    
}

- (void)initBottomView  {
    
    self.bottomV = [[UIView alloc] init];
    self.bottomV.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
    self.bottomV.layer.shadowOffset = CGSizeMake(0,-3);
        // 设置阴影透明度
    self.bottomV.layer.shadowOpacity = 0.08;
        // 设置阴影半径
    self.bottomV.layer.shadowRadius = 20;
    self.bottomV.clipsToBounds = NO;
    self.bottomV.backgroundColor = [UIColor whiteColor];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.frame = CGRectMake(15, 10, ScreenW - 30, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;

   
    [button setTitle:@"我要跟读" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomV addSubview:button];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomV];
    button.backgroundColor = RGB(234, 104, 118);
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@(60 + TableViewBottomSpace));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(60 + TableViewBottomSpace));
    }];
    
}
//点击跟读
- (void)clickAction:(UIButton *)button {
    
    YMRGenDuTV * vc =[[YMRGenDuTV alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"head"];
        
        UIView * lineV  = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, ScreenW, 0.5)];
        lineV.backgroundColor = LineColor;
        [view addSubview:lineV];
        
        UIView * bV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        bV.backgroundColor = BGGrayColor;
        [view addSubview:bV];
        UILabel * lb  = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, ScreenW - 30, 30)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = @"分享列表";
        [view addSubview:lb];
        view.backgroundColor = [UIColor whiteColor];
        view.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRFenXiangListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}




@end
