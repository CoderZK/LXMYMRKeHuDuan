//
//  YMRXueXiJiHuaTVC.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRXueXiJiHuaTVC.h"
#import "YMRRenWuSectionView.h"
#import "YMRRenWuOneCell.h"
#import "YMRRenWuTableViewCell.h"
#import "YMRJiFenGuiListTVC.h"
#import "YMRWenZhangYiWanChengListTVC.h"
#import "YMRXueXiWenZhangListTVC.h"
#import "YMRWenZhangJiFenGuiZeView.h"
#import "YMRWenZhangDetailTVC.h"
#import "YMRPaiHangListTVC.h"
#import "YMRShareXinDeVC.h"
@interface YMRXueXiJiHuaTVC ()
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIButton *headBt,*leveBt;
@property(nonatomic,strong)UILabel *nameLb,*jiFenLB,*danqianJiFenLB,*r0LB,*r1LB,*r2LB,*r3LB,*r4LB;

@property(nonatomic,strong)UIView *whiteV;
@property(nonatomic,strong)UIView *pViewOne,*pViewTwo;
@property(nonatomic,strong)YMRXueXiModel *homeModel;


@end

@implementation YMRXueXiJiHuaTVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self loadIndexData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeadView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YMRRenWuOneCell" bundle:nil] forCellReuseIdentifier:@"YMRRenWuOneCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YMRRenWuTableViewCell class] forCellReuseIdentifier:@"YMRRenWuTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[YMRRenWuSectionView class] forHeaderFooterViewReuseIdentifier:@"head"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
 
    
}

/**
 获取首页数据
 */
- (void)loadIndexData {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:card_page_index parameters:@{@"token" : SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak endRefrish];
        if ([responseObject[@"key"] integerValue] == 1000) {
            self.homeModel = [YMRXueXiModel mj_objectWithKeyValues:responseObject[@"result"]];
          
            [self.headBt sd_setBackgroundImageWithURL:[NSURL URLWithString:[LxmTool ShareTool].userModel.userHead] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
            self.nameLb.text = [LxmTool ShareTool].userModel.username;
            [LxmTool ShareTool].shareWord = self.homeModel.map.shareWord;
            [self.leveBt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%d",self.homeModel.map.levelNum.intValue]] forState:UIControlStateNormal];

            [self.leveBt setTitle:[NSString stringWithFormat:@"Lv%d",self.homeModel.map.levelNum.intValue] forState:UIControlStateNormal];
            
            
            
            self.leveBt.backgroundColor = colorArr[self.homeModel.map.levelNum.intValue];
            if (self.homeModel.map.levelNum.intValue == 10) {
                self.r0LB.hidden = self.r1LB.hidden = self.r2LB.hidden = self.r3LB.hidden = self.r4LB.hidden = YES;
             
                [self.pViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(ScreenW - 60));
                }];
            }else {
                self.r0LB.hidden = self.r1LB.hidden = self.r2LB.hidden = self.r3LB.hidden = self.r4LB.hidden = NO;
                self.r1LB.text = [NSString stringWithFormat:@"Lv%d",self.homeModel.map.levelNum.intValue+1];
                self.r3LB.text = [NSString stringWithFormat:@"%d",self.homeModel.map.upScore.intValue - self.homeModel.map.score.intValue];
                self.danqianJiFenLB.text =  self.jiFenLB.text = self.homeModel.map.score;
                
                CGFloat ww = (self.homeModel.map.score.floatValue - self.homeModel.map.cuScore.floatValue) / (self.homeModel.map.upScore.floatValue - self.homeModel.map.cuScore.floatValue) * (ScreenW - 60);
                [self.pViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(ww));
                }];
                
            }
            
            
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak endRefrish];
    }];
}


- (void)initHeadView {
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300 + StateBarH)];
    self.headView.backgroundColor = [UIColor whiteColor];
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
    imageV.image = [UIImage imageNamed:@"shareback"];
    [self.headView addSubview:imageV];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(5,sstatusHeight , 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton * guiZeBt = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW- 60, sstatusHeight, 50, 44)];
    [guiZeBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [guiZeBt setTitle:@"规则" forState:UIControlStateNormal];
    guiZeBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [guiZeBt setImage:[UIImage imageNamed:@"guize"] forState:UIControlStateNormal];
    [self.view addSubview:guiZeBt];
    [guiZeBt addTarget:self action:@selector(guizeAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.headView;
    
    self.headBt = [[UIButton alloc] init];
    self.headBt.layer.cornerRadius = 27.5;
    self.headBt.clipsToBounds = YES;
    self.headBt.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headBt.layer.borderWidth = 0.8;
    [self.headView addSubview:self.headBt];
    [self.headBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(15);
        make.top.equalTo(self.headView).offset(50+StateBarH);
        make.width.height.equalTo(@55);
    }];
    
    self.nameLb = [[UILabel alloc] init];
    self.nameLb.textColor = [UIColor whiteColor];
    self.nameLb.font = [UIFont systemFontOfSize:18];
    self.nameLb.text = @"Dasj沙拉";
    [self.headView addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBt.mas_right).offset(15);
        make.centerY.equalTo(self.headBt);
    }];
    
    self.leveBt = [[UIButton alloc] init];
    self.leveBt.layer.cornerRadius = 8;
    self.leveBt.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leveBt.layer.borderWidth = 0.5;
    self.leveBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.leveBt setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.leveBt setTitle:@"Lv10" forState:UIControlStateNormal];
    [self.headView addSubview:self.leveBt];
    self.leveBt.backgroundColor = leve10Color;
    
    [self.leveBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(10);
        make.centerY.equalTo(self.headBt);
        make.height.equalTo(@16);
        make.width.equalTo(@55);
    }];
    
    
    UIView * whiteV = [[UIView alloc] initWithFrame:CGRectMake(15, 295+StateBarH-150, ScreenW - 30, 150)];
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.cornerRadius = 10;
    [self.headView addSubview:whiteV];
    
    
    self.whiteV = [[UIView alloc] initWithFrame:CGRectMake(15, 295+StateBarH-150, ScreenW - 30, 150)];
    self.whiteV.backgroundColor = [UIColor whiteColor];
    self.whiteV.layer.cornerRadius = 10;
    self.whiteV.clipsToBounds = YES;
    [self.headView addSubview:self.whiteV];
    
   
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imgV.image = [UIImage imageNamed:@"banyuan"];
    [self.whiteV addSubview:imgV];
    
    whiteV.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
    whiteV.layer.shadowOffset = CGSizeMake(0,3);
        // 设置阴影透明度
    whiteV.layer.shadowOpacity = 0.08;
        // 设置阴影半径
    whiteV.layer.shadowRadius = 10;

    
    UIButton  * mingXiBt = [[UIButton alloc] init];
    mingXiBt.layer.cornerRadius = 12;
    mingXiBt.clipsToBounds = YES;
    mingXiBt.layer.borderWidth = 0.5;
    mingXiBt.layer.borderColor = MainColor.CGColor;
    [mingXiBt setTitle:@"积分记录  >  " forState:UIControlStateNormal];
    [mingXiBt setTitleColor:MainColor forState:UIControlStateNormal];
    mingXiBt.titleLabel.font = [UIFont systemFontOfSize:12];
    mingXiBt.tag = 103;
    [mingXiBt addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteV addSubview:mingXiBt];

    [mingXiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteV.mas_right).offset(13);
        make.height.equalTo(@24);
        make.width.equalTo(@95);
        make.top.equalTo(self.whiteV.mas_top).offset(18);
    }];
   
    UILabel * lb = [[UILabel alloc] init];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"我的积分";
    [self.whiteV addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteV);
        make.top.equalTo(self.whiteV).offset(28);
        
    }];
    self.jiFenLB = [[UILabel alloc] init];
    self.jiFenLB.font = [UIFont boldSystemFontOfSize:16];
    self.jiFenLB.text = @"6387";
    self.jiFenLB.textColor = MainColor;
    [self.whiteV addSubview:self.jiFenLB];
    [self.jiFenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteV);
        make.top.equalTo(lb.mas_bottom).offset(15);
        
    }];
    
    self.pViewOne = [[UIView alloc] init];
    self.pViewOne.backgroundColor = RGB(231, 231, 231);
    self.pViewOne.layer.cornerRadius = 4;
    self.pViewOne.clipsToBounds = YES;
    [self.whiteV addSubview:self.pViewOne];
    [self.pViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteV).offset(15);
        make.right.equalTo(self.whiteV).offset(-15);
        make.height.equalTo(@8);
        make.top.equalTo(self.jiFenLB.mas_bottom).offset(22);
    }];
    
    self.pViewTwo = [[UIView alloc] init];
    self.pViewTwo.backgroundColor = MainColor;
    self.pViewTwo.layer.cornerRadius = 4;
    self.pViewTwo.clipsToBounds = YES;
    [self.pViewOne addSubview:self.pViewTwo];
    [self.pViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.pViewOne);
        make.height.equalTo(@8);
        make.width.equalTo(@60);
    }];
    UILabel * lb2 = [[UILabel alloc] init];
    lb2.font = [UIFont systemFontOfSize:12];
    lb2.text = @"当前积分:";
    [self.whiteV addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteV).offset(15);
        make.top.equalTo(self.pViewOne.mas_bottom).offset(5);
        
    }];
    self.danqianJiFenLB = [[UILabel alloc] init];
    self.danqianJiFenLB.font = [UIFont systemFontOfSize:12];
    self.danqianJiFenLB.text = @"12";
    self.danqianJiFenLB.textColor = MainColor;
    [self.whiteV addSubview:self.danqianJiFenLB];
    [self.danqianJiFenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lb2.mas_right);
        make.top.equalTo(lb2);
    }];
    
    self.r4LB = [[UILabel alloc] init];
    self.r4LB.font = [UIFont systemFontOfSize:12];
    self.r4LB.text = @"积分";
    [self.whiteV addSubview:self.r4LB];
    [self.r4LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pViewOne);
        make.top.equalTo(lb2);
    }];
    
    self.r3LB = [[UILabel alloc] init];
    self.r3LB.font = [UIFont systemFontOfSize:12];
    self.r3LB.text = @"199";
    self.r3LB.textColor = MainColor;
    [self.whiteV addSubview:self.r3LB];
    [self.r3LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.r4LB.mas_left);
        make.top.equalTo(lb2);
    }];
    
    self.r2LB = [[UILabel alloc] init];
    self.r2LB.font = [UIFont systemFontOfSize:12];
    self.r2LB.text = @"还差";
    [self.whiteV addSubview:self.r2LB];
    [self.r2LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.r3LB.mas_left);
        make.top.equalTo(lb2);
    }];
    
    self.r1LB = [[UILabel alloc] init];
    self.r1LB.font = [UIFont systemFontOfSize:12];
    self.r1LB.text = @"Lv4";
    self.r1LB.textColor = MainColor;
    [self.whiteV addSubview:self.r1LB];
    
    [self.r1LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.r2LB.mas_left);
        make.top.equalTo(lb2);
    }];
    
    
    self.r0LB = [[UILabel alloc] init];
    self.r0LB.font = [UIFont systemFontOfSize:12];
    self.r0LB.text = @"距离";
    [self.whiteV addSubview:self.r0LB];
    [self.r0LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.r1LB.mas_left);
        make.top.equalTo(lb2);
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//规则
- (void)guizeAction {
    
    YMRWenZhangJiFenGuiZeView * guiZeView = [[YMRWenZhangJiFenGuiZeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    guiZeView.remark = self.homeModel.map.reasonDes;
    [guiZeView show];
    
    
    
}


// 积分记录
- (void)jifenAction:(UIButton *)button {
    
    YMRJiFenGuiListTVC * vc =[[YMRJiFenGuiListTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }else {
        if (self.homeModel.list.count == 0) {
            return 400;
        }else {
            return 70*self.homeModel.list.count+10;
        }
    }
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YMRRenWuSectionView * headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    if (section == 0) {
        headV.rightBt.hidden = headV.rigthImageV.hidden = headV.rightLB.hidden = NO;
        headV.rightLB.text = @"已完成任务";
        headV.leftLB.text = @"每日任务";
    }else {
        headV.rightBt.hidden = headV.rigthImageV.hidden = headV.rightLB.hidden = YES;
        headV.rightLB.text = @"更多排行";
        headV.leftLB.text = @"排行榜";
    }
    
    headV.rightBt.tag = 100+ section;
    [headV.rightBt  addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        YMRRenWuOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"YMRRenWuOneCell" forIndexPath:indexPath];
        [cell.confirmBt  addTarget:self action:@selector(quwanAction) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.homeModel.map;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        YMRRenWuTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"YMRRenWuTableViewCell" forIndexPath:indexPath];
        cell.dataArr = self.homeModel.list;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
 
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

// 点击头部
- (void)headAction:(UIButton *)button {
    
    if(button.tag == 100) {
        // 点击已完成
        YMRWenZhangYiWanChengListTVC * vc =[[YMRWenZhangYiWanChengListTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        YMRPaiHangListTVC * vc =[[YMRPaiHangListTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

// 点击去完成呢个
- (void)quwanAction {
    
    
    
    
    if (self.homeModel.map.finishStatus.intValue == 1 && self.homeModel.map.articleId.length > 0) {
        YMRWenZhangDetailTVC * vc =[[YMRWenZhangDetailTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        vc.articleId = self.homeModel.map.articleId;
        vc.finishStatus = self.homeModel.map.finishStatus;
        if ([self.homeModel.map.shareWord isEqualToString:@"无"]) {
            vc.isZhouMo = YES;
        }else {
            vc.isZhouMo = NO;
        }
        vc.shareWord = self.homeModel.map.shareWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.homeModel.map.finishStatus.intValue == 2 && self.homeModel.map.articleId.length > 0) {
        YMRWenZhangDetailTVC * vc =[[YMRWenZhangDetailTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        vc.articleId = self.homeModel.map.articleId;
        vc.finishStatus = self.homeModel.map.finishStatus;
        if ([self.homeModel.map.shareWord isEqualToString:@"无"]) {
            vc.isZhouMo = YES;
        }else {
            vc.isZhouMo = NO;
        }
        vc.shareWord = self.homeModel.map.shareWord;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.homeModel.map.finishStatus.intValue == 3 && self.homeModel.map.articleId.length > 0) {
        YMRShareXinDeVC * vc =[[YMRShareXinDeVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.articleId = self.homeModel.map.articleId;
        vc.finishStatus = self.homeModel.map.finishStatus;
        vc.shareWord = self.homeModel.map.shareWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        YMRXueXiWenZhangListTVC * vc =[[YMRXueXiWenZhangListTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        vc.finishStatus = self.homeModel.map.finishStatus;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

@end
