//
//  LxmSelectAreaVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/27.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSelectAreaVC.h"

@interface LxmSelectAreaVC ()

@property (nonatomic, assign) NSInteger currentIndex;//当前选中

@property (nonatomic, strong) NSMutableArray <NSString *> *dataArr;

@end

@implementation LxmSelectAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    [self loadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(cell);
            make.height.equalTo(@0.5);
        }];
//        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
//        iconImgView.image = [UIImage imageNamed:@"xuanze"];
//        cell.accessoryView = iconImgView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIImageView *iconImgView = (UIImageView *)cell.accessoryView;
//    iconImgView.hidden = self.currentIndex != indexPath.row;
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.city;
    } else {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        UILabel *titlelabel = [UILabel new];
        titlelabel.font = [UIFont systemFontOfSize:15];
        titlelabel.textColor = CharacterGrayColor;
        titlelabel.tag = 1000;
        [headerView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView);
        }];
    }
    UILabel *titlelabel = (UILabel *)[headerView viewWithTag:1000];
    titlelabel.text = section == 0 ? @"当前城市" : @"省内城市";
    headerView.contentView.backgroundColor = BGGrayColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.didSelectCity) {
            self.didSelectCity(self.city);
        }
    } else {
        NSString *city = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
        if (self.didSelectCity) {
            self.didSelectCity(city);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 选择城市
 */
- (void)loadData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:service_city_list parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1000) {
            [self.dataArr removeAllObjects];
            NSArray *tempArr = responseObject[@"result"][@"list"];
            if ([tempArr isKindOfClass:NSArray.class]) {
                if (tempArr.count > 0) {
                    [self.dataArr addObjectsFromArray:tempArr];
                }
            }
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end




