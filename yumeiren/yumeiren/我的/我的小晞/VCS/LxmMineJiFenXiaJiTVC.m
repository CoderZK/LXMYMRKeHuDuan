//
//  LxmMineJiFenXiaJiTVC.m
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmMineJiFenXiaJiTVC.h"
#import "LxmMineJifenMingXiTVC.h"
#import "LxmJiFenDeatilOneTVC.h"
#import "LxmZhuanChuJiFenVC.h"
#import "LxmMineYeJiKaoTVC.h"
#import "LxmMineTeamJiFenMingXiTVC.h"
#import "LxmMineJiFenXiaJiSubTVC.h"
#import "LxmTiXianVC.h"
#import "LxmShengYuDaiZhuanJiFenListTVC.h"
#import "LxmLiShiXiaoXiVC.h"
@interface LxmMineJiFenXiaJiTVC ()
@property(nonatomic,strong)UIButton *leftButton,*rightButton;
@property(nonatomic,strong)UIView *navTitleV;
@property(nonatomic,strong)UIView *headViewOne,*headViewTwo;
@property(nonatomic,strong)UILabel *numberLB,*LB1,*LB2,*LB3,*LB4,*JifenLB;
@property(nonatomic,strong)UIButton  *tixianBt,*mineJiFenBt,*shengYujiFenBt,*liShiXiaoXiBt;
@property(nonatomic,strong)UIImageView *imgV1,*imgV2;
@property(nonatomic,strong)UIView  *redV;
@property(nonatomic,strong)UIView *btView;
@property(nonatomic,strong)LxmMineJiFenXiaJiSubTVC *subTVC;
@property(nonatomic,strong)UIView *bottomV;
@property(nonatomic,strong)UILabel *allXiaoXiLB,*monthXiaoXiLB;




@end

@implementation LxmMineJiFenXiaJiTVC

-(UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_leftButton setTitle:@"我的小煜" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.selected = YES;
        _leftButton.tag = 443;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateSelected];
        [_rightButton setTitle:@"我的小煜" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 444;
    }
    return _rightButton;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initBottomV];
    
    [self getScoreData];
    
//    if  (self.jifenModel != nil) {
//           [self addNavTitleV];
////           [self addHeadViewOne];
//           [self addheadViewTwo];
//
//        self.leftButton.selected = NO;
//        self.rightButton.selected = YES;
//        self.headViewTwo.hidden = NO;
////        self.headViewOne.hidden = YES;
////        self.subTVC.view.hidden = YES;
////        self.bottomV.hidden = YES;
//
//    }else {
//        [self getScoreData];
//    }
//    [self loadGroupData];
   
    
     WeakObj(self);
    [LxmEventBus registerEvent:@"jifentiqu" block:^(NSDictionary  * data) {
         StrongObj(self);
        if ([data.allKeys containsObject:@"scoreType"]) {
            if ([data.allKeys containsObject:@"money"]) {
                
                CGFloat money = [data[@"money"] doubleValue];
                
                if ([data[@"scoreType"] intValue] == 2) {
                    self.jifenModel.my_score = [NSString stringWithFormat:@"%0.2f",self.jifenModel.my_score.doubleValue - money];
                    
                    self.LB1.text = [[NSString stringWithFormat:@"%0.2f",self.jifenModel.my_score.doubleValue + self.jifenModel.group_score.doubleValue] getPriceStr];
                    self.LB2.text = [self.jifenModel.my_score getPriceStr];
                    
                }else {
                    self.jifenModel.direct_score = [NSString stringWithFormat:@"%0.2f",self.jifenModel.direct_score.doubleValue - money];
                    self.LB3.text =   [self.jifenModel.direct_score getPriceStr];
                }
            }
            
            
            
        }
    
        
        
    }];
    
    
}


//获取小煜
- (void)getScoreData {
    
    //获取个人信息
    [LxmNetworking networkingPOST:my_inner_score parameters:@{@"token":TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            
            if (responseObject[@"result"] != nil && [[responseObject[@"result"] allKeys] containsObject:@"map"]) {
                self.jifenModel  = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
              
                [self addNavTitleV];
//                [self addHeadViewOne];
                [self addheadViewTwo];
                self.headViewTwo.hidden = NO;
                self.leftButton.selected = NO;
                self.rightButton.selected = YES;
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

- (void)addHeadViewOne {
    
    self.subTVC = [[LxmMineJiFenXiaJiSubTVC alloc] init];
    [self addChildViewController:self.subTVC];
    self.subTVC.type = 1;
    [self.view addSubview:self.subTVC.view];
    
    
    
    
    
    
    self.headViewOne = [[UIView alloc] init];
    self.headViewOne.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headViewOne];
    
    
    //    UIView * backV =[[UIView alloc] init];
    //    backV.backgroundColor = CharacterLightGrayColor;
    //    [self.headViewOne addSubview:backV];
    
    
    
    UILabel * numberLb = [[UILabel alloc] init];
    numberLb.text = [NSString stringWithFormat:@"同级别业绩排名:%@",self.jifenModel.rank];;
    numberLb.font = [UIFont systemFontOfSize:14];
    numberLb.textColor = CharacterDarkColor;
    [self.headViewOne addSubview:numberLb];
    self.numberLB = numberLb;
    
    
    self.liShiXiaoXiBt  = [[UIButton alloc] init];
    [self.liShiXiaoXiBt setTitle:@"历史小煜 >" forState:UIControlStateNormal];
    [self.liShiXiaoXiBt setTitleColor:MainColor forState:UIControlStateNormal];
    self.liShiXiaoXiBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.headViewOne addSubview:self.liShiXiaoXiBt];
    self.liShiXiaoXiBt.layer.cornerRadius = 10;
    self.liShiXiaoXiBt.clipsToBounds = YES;
    self.liShiXiaoXiBt.layer.borderColor = MainColor.CGColor;
    self.liShiXiaoXiBt.layer.borderWidth = 0.5;
    [self.liShiXiaoXiBt addTarget:self action:@selector(lishiAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"kkjifenback"];
    imageV.userInteractionEnabled = YES;
    [self.headViewOne addSubview:imageV];
    
    
    UILabel * tuanDuiJiFen  = [[UILabel alloc] init];
    tuanDuiJiFen.font = [UIFont systemFontOfSize:30 weight:0.2];
    tuanDuiJiFen.text = [[NSString stringWithFormat:@"%0.2f",self.jifenModel.my_score.doubleValue + self.jifenModel.group_score.doubleValue] getPriceStr];
    self.LB1 = tuanDuiJiFen;
    tuanDuiJiFen.textAlignment = NSTextAlignmentCenter;
    tuanDuiJiFen.textColor = [UIColor whiteColor];
    [imageV  addSubview:tuanDuiJiFen];
    
    UILabel * tuanDuiJiFendes  = [[UILabel alloc] init];
    tuanDuiJiFendes.font = [UIFont systemFontOfSize:14];
    tuanDuiJiFendes.text = @"团队小煜";
    tuanDuiJiFendes.textAlignment = NSTextAlignmentCenter;
    tuanDuiJiFendes.textColor = [UIColor whiteColor];
    [imageV  addSubview:tuanDuiJiFendes];
    

    
    
    UILabel * jiFenLB  = [[UILabel alloc] init];
    jiFenLB.font = [UIFont systemFontOfSize:20 weight:0.2];
    jiFenLB.text = [[NSString stringWithFormat:@"%0.2f",self.jifenModel.my_score.doubleValue]  getPriceStr];
    jiFenLB.textAlignment = NSTextAlignmentCenter;
    jiFenLB.textColor = [UIColor whiteColor];
    [imageV  addSubview:jiFenLB];
    self.LB2 = jiFenLB;
    
    
    
    UIButton  * mingXiBt = [[UIButton alloc] init];
    [mingXiBt setTitle:@"我的小煜 >" forState:UIControlStateNormal];
    [mingXiBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mingXiBt.titleLabel.font = [UIFont systemFontOfSize:13];
    mingXiBt.userInteractionEnabled = NO;
    [imageV addSubview:mingXiBt];
    
    UIButton  * mingXiBtOO = [[UIButton alloc] init];
    mingXiBtOO.titleLabel.font = [UIFont systemFontOfSize:13];
    mingXiBtOO.tag = 100;
    [imageV addSubview:mingXiBtOO];
    [mingXiBtOO addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * jiFenLBTwo  = [[UILabel alloc] init];
    jiFenLBTwo.font = [UIFont systemFontOfSize:20 weight:0.2];
    jiFenLBTwo.text = [[NSString stringWithFormat:@"%@", @(self.jifenModel.group_score.doubleValue).stringValue] getPriceStr] ;
    jiFenLBTwo.textAlignment = NSTextAlignmentCenter;
    jiFenLBTwo.textColor = [UIColor whiteColor];
    [imageV  addSubview:jiFenLBTwo];
    
    
    
    UIButton  * mingXiBtTwo = [[UIButton alloc] init];
    [mingXiBtTwo setTitle:@"剩余待转小煜 >" forState:UIControlStateNormal];
    [mingXiBtTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mingXiBtTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    [imageV addSubview:mingXiBtTwo];
    mingXiBtTwo.userInteractionEnabled = NO;

    
    UIButton  * mingXiBtTTT = [[UIButton alloc] init];
    mingXiBtTTT.titleLabel.font = [UIFont systemFontOfSize:13];
    mingXiBtTTT.tag = 101;
    [imageV addSubview:mingXiBtTTT];

    [mingXiBtTTT addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    mingXiBtTTT.backgroundColor = mingXiBtOO.backgroundColor = [UIColor redColor];
    
    
    UIView * lineVOne = [[UIView alloc] init];
    lineVOne.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:lineVOne];
    
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:lineV];
    
    
    
    UIButton * tixianBt  =[[UIButton alloc] init];
    [tixianBt setTitle:@"转出" forState:UIControlStateNormal];
    if ([self.jifenModel.top_status isEqualToString:@"1"]) {
        [tixianBt setTitle:@"提取" forState:UIControlStateNormal];
    }
    [tixianBt setTitleColor:MainColor forState:UIControlStateNormal];
    tixianBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [tixianBt setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
    [imageV addSubview:tixianBt];
    tixianBt.layer.cornerRadius = 5;
    tixianBt.tag = 102;
    [tixianBt addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    tixianBt.clipsToBounds = YES;
    
    self.btView = [[UIView alloc] init];
    self.btView.backgroundColor = [UIColor whiteColor];
    [self.headViewOne addSubview:self.btView];
    
    UIView * backVTwo =[[UIView alloc] init];
    backVTwo.backgroundColor = CharacterLightGrayColor;
    [self.btView addSubview:backVTwo];
    
    UIButton  * leftBt = [[UIButton alloc] init];
    [leftBt setTitle:@"同级直属" forState:UIControlStateNormal];
    [leftBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBt.tag = 100;
    [self.btView addSubview:leftBt];
    
    
    UIButton  * rightBt = [[UIButton alloc] init];
    [rightBt setTitle:@"同级非直属" forState:UIControlStateNormal];
    [rightBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBt.tag = 101;
    [self.btView addSubview:rightBt];
    
    self.redV = [[UIView alloc] init];
    self.redV.backgroundColor = MainColor;
    [self.btView addSubview:self.redV];
    
    [self.headViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        //        make.height.equalTo(@270);
    }];
    
    
    [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headViewOne).offset(15);
        make.height.equalTo(@20);
        make.top.equalTo(self.headViewOne).offset(5);
        
        if  ([self.jifenModel.rank isEqualToString:@"-1"]) {
//            make.height.equalTo(@0);
//            make.top.equalTo(self.headViewOne).offset(0);
            self.numberLB.hidden = YES;
        }else {
//            make.height.equalTo(@20);
//            make.top.equalTo(self.headViewOne).offset(5);
            self.numberLB.hidden = NO;
        }
        
        
    }];
    
    [self.liShiXiaoXiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headViewOne).offset(-15);
        make.centerY.equalTo(self.numberLB);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    
    
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@260);
        make.width.equalTo(@(ScreenW - 30));
        make.centerX.equalTo(self.headViewOne);
        make.top.equalTo(numberLb.mas_bottom).offset(15);
    }];
    
    [tuanDuiJiFen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(15);
        make.width.equalTo(@(ScreenW - 60));
        make.top.equalTo(imageV).offset(20);
        make.height.equalTo(@35);
    }];
    
    [tuanDuiJiFendes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(15);
        make.width.equalTo(@(ScreenW - 60));
        make.top.equalTo(tuanDuiJiFen.mas_bottom).offset(0);
        make.height.equalTo(@17);
    }];

    
    [lineVOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(15);
        make.left.equalTo(imageV).offset(-15);
        make.top.equalTo(tuanDuiJiFendes.mas_bottom).offset(15);
        make.height.equalTo(@0.5);
    }];
    
    [jiFenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(15);
        make.width.equalTo(@((ScreenW - 51)/ 2));
        make.top.equalTo(lineVOne.mas_bottom).offset(15);
        make.height.equalTo(@25);
    }];
    [mingXiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiFenLB);
        make.width.equalTo(jiFenLB.mas_width);
        make.height.equalTo(@20);
        make.top.equalTo(jiFenLB.mas_bottom).offset(5);
    }];
    
    [mingXiBtOO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(jiFenLB);
        make.bottom.equalTo(mingXiBt);
    }];
    
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(jiFenLB);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(imageV);
    }];
    
    [jiFenLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV);
        make.top.equalTo(jiFenLB);
        make.width.equalTo(@((ScreenW - 51)/ 2));
        make.height.equalTo(@25);
    }];
    [mingXiBtTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiFenLBTwo.mas_left);
        make.width.equalTo(jiFenLBTwo.mas_width);
        make.height.equalTo(@20);
        make.top.equalTo(mingXiBt);
    }];
    
    [mingXiBtTTT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(jiFenLBTwo);
        make.bottom.equalTo(mingXiBtTwo);
    }];

    [tixianBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageV);
        make.width.equalTo(@180);
        make.height.equalTo(@35);
        make.bottom.equalTo(imageV).offset(-44);
    }];
    
    [self.btView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headViewOne);
        make.top.equalTo(imageV.mas_bottom);
        make.bottom.equalTo(self.headViewOne);
        make.height.equalTo(@50);
    }];
    
    [leftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenW /2));
        make.height.equalTo(@40);
        make.left.equalTo(self.btView);
        make.centerY.equalTo(self.btView);
    }];
    
    [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenW /2));
        make.height.equalTo(@40);
        make.left.equalTo(leftBt.mas_right);
        make.centerY.equalTo(self.btView);
    }];
    
    [self.redV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@3);
        make.top.equalTo(self.btView).offset(40);
        make.centerX.equalTo(leftBt);
    }];
    
    [backVTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.2));
        make.bottom.right.left.equalTo(self.btView);
    }];
    
     
      [self.subTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self.view);
          make.bottom.equalTo(self.bottomV.mas_top);
          make.top.equalTo(self.headViewOne.mas_bottom);
      }];
    
    
}

- (void)initBottomV {
    
    self.bottomV = [[UIView alloc] init];
    self.bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomV];
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (StateBarH >20) {
            make.bottom.equalTo(self.view).offset(-34);
        }else {
            make.bottom.equalTo(self.view);
        }
        make.height.equalTo(@50);
    }];
    self.bottomV.layer.shadowColor = CharacterDarkColor.CGColor;
    self.bottomV.layer.shadowOpacity = 0.1;
    self.bottomV.layer.shadowRadius = 3;
    
    
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.bottomV.mas_top);
//    }];
    
    UILabel * lb1  =[[UILabel alloc] init];
    lb1.font = [UIFont systemFontOfSize:13];
    lb1.text = @"当月团队总业绩: ";
    lb1.textColor = CharacterDarkColor;
    [self.bottomV addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.left.equalTo(self.bottomV).offset(15);
    }];
    
    
    UILabel * lb2  =[[UILabel alloc] init];
    lb2.font = [UIFont systemFontOfSize:14];
    lb2.text = @"";
    lb2.textColor = MainColor;
    [self.bottomV addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomV);
        make.height.equalTo(@20);
        make.left.equalTo(lb1.mas_right).offset(15);
    }];
    self.allXiaoXiLB = lb2;
    
    
    
    
    
//    UILabel * lb4  =[[UILabel alloc] init];
//    lb4.font = [UIFont systemFontOfSize:14];
//    lb4.text = @"2000";
//    lb4.textColor = MainColor;
//    [self.bottomV addSubview:lb4];
//    [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bottomV);
//        make.height.equalTo(@20);
//        make.right.equalTo(self.bottomV).offset(-15);
//    }];
//    self.monthXiaoXiLB = lb4;
//
//
//    UILabel * lb3  =[[UILabel alloc] init];
//    lb3.font = [UIFont systemFontOfSize:13];
//    lb3.text = @"当月提取小煜: ";
//    lb3.textColor = CharacterDarkColor;
//    [self.bottomV addSubview:lb3];
//    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bottomV);
//        make.height.equalTo(@20);
//        make.right.equalTo(self.monthXiaoXiLB.mas_left).offset(-10);
//    }];
    
    
}


- (void)loadGroupData {
    
    
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"id"] =  [LxmTool ShareTool].userModel.id;
  
    [LxmNetworking networkingPOST:my_group_total_sale parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      
        if ([responseObject[@"key"] intValue] == 1000) {
            self.allXiaoXiLB.text = [[NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"group_sale"]] getPriceStr];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
    
}

- (void)addheadViewTwo {
    
    if (self.headViewTwo != nil) {
        return;
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kkzhixi"]];
    
    self.headViewTwo = [[UIView alloc] init];
    self.headViewTwo.backgroundColor  = [UIColor whiteColor];
    self.headViewTwo.hidden = YES;
    //    [self.headViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view addSubview:self.headViewTwo];
    
    [self.headViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-40);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@320);
    }];
    self.headViewTwo.layer.cornerRadius = 5;
    self.headViewTwo.clipsToBounds = YES;
    
    
    UIButton  * mingXiBt = [[UIButton alloc] init];
    mingXiBt.layer.cornerRadius = 12;
    mingXiBt.clipsToBounds = YES;
    mingXiBt.layer.borderWidth = 0.5;
    mingXiBt.layer.borderColor = MainColor.CGColor;
    [mingXiBt setTitle:@"明细 >   " forState:UIControlStateNormal];
    [mingXiBt setTitleColor:MainColor forState:UIControlStateNormal];
    mingXiBt.titleLabel.font = [UIFont systemFontOfSize:12];
    mingXiBt.tag = 103;
    [mingXiBt addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headViewTwo addSubview:mingXiBt];
    
    [mingXiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headViewTwo.mas_right).offset(13);
        make.height.equalTo(@24);
        make.width.equalTo(@72);
        make.top.equalTo(self.headViewTwo.mas_top).offset(12);
    }];
    
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"kk629"];
    [self.headViewTwo addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headViewTwo.mas_centerX);
        make.width.height.equalTo(@39);
        make.top.equalTo(self.headViewTwo.mas_top).offset(53);
    }];
    
    UILabel * tuiJianJifen  = [[UILabel alloc] init];
    tuiJianJifen.font = [UIFont systemFontOfSize:15];
    tuiJianJifen.text = @"我的小煜";
    tuiJianJifen.textAlignment = NSTextAlignmentCenter;
    [self.headViewTwo  addSubview:tuiJianJifen];
    
    [tuiJianJifen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headViewTwo);
        make.top.equalTo(imageV.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
    
    
    UILabel * jiFenLB  = [[UILabel alloc] init];
    jiFenLB.font = [UIFont systemFontOfSize:20 weight:0.2];
    jiFenLB.text = [self.jifenModel.direct_score getPriceStr];
    jiFenLB.textAlignment = NSTextAlignmentCenter;
    self.LB3 = jiFenLB;
    jiFenLB.textColor = MainColor;
    [self.headViewTwo  addSubview:jiFenLB];
    
    [jiFenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headViewTwo);
        make.top.equalTo(tuiJianJifen.mas_bottom).offset(15);
        make.height.equalTo(@25);
    }];
    self.JifenLB = jiFenLB;
    
    UIButton * tixianBt  =[[UIButton alloc] init];
    [tixianBt setTitle:@"申请提取" forState:UIControlStateNormal];
    [tixianBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tixianBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [tixianBt setBackgroundImage:[UIImage imageNamed:@"deepPink"] forState:UIControlStateNormal];
    [self.headViewTwo addSubview:tixianBt];
    tixianBt.tag = 104;
    [tixianBt addTarget:self action:@selector(jifenAction:) forControlEvents:UIControlEventTouchUpInside];
    [tixianBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headViewTwo.mas_centerX);
        make.width.equalTo(@180);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.headViewTwo.mas_bottom).offset(-50);
    }];
    tixianBt.layer.cornerRadius = 5;
    tixianBt.clipsToBounds = YES;
    
    
}



- (void)addNavTitleV {
    
//    self.navTitleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    self.navTitleV.layer.cornerRadius = 15;
//    self.navTitleV.clipsToBounds  = YES;
//    self.navTitleV.layer.borderColor = MainColor.CGColor;
//    self.navTitleV.layer.borderWidth = 0.5;
//    [self.navTitleV addSubview:self.leftButton];
//    self.leftButton.frame = CGRectMake(0, 0, 100, 30);
//    [self.navTitleV addSubview:self.rightButton];
//    self.rightButton.frame = CGRectMake(100, 0, 100, 30);
//
//    self.navigationItem.titleView = self.navTitleV;
    
    self.navigationItem.title = @"我的小煜";
    
}


- (void)buttonClick:(UIButton *)button {
    
    if (button.tag == 443) {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
        self.headViewTwo.hidden = YES;
        self.headViewOne.hidden = NO;
        self.subTVC.view.hidden = NO;
        self.bottomV.hidden = NO;
    }else {
        self.leftButton.selected = NO;
        self.rightButton.selected = YES;
        self.headViewTwo.hidden = NO;
        self.headViewOne.hidden = YES;
        self.subTVC.view.hidden = YES;
        self.bottomV.hidden = YES;
        
    }
    
}

- (void)clickAction:(UIButton *)button {
    
    if (button.tag == 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.redV.mj_x = ScreenW  / 4 - 20;
        }];
        self.subTVC.type = 1;
        self.subTVC.page = 1;
        [self.subTVC loadData];
    }else if (button.tag == 101){
        [UIView animateWithDuration:0.2 animations:^{
            self.redV.mj_x = ScreenW * 3 / 4 - 20;
        }];
        self.subTVC.type = 2;
        self.subTVC.page = 1;
        [self.subTVC loadData];
    }
    
    
    
}

// 100 我的小煜 101 剩余待转小煜 102 提现(或者转出小煜) 103 明细 104 申请提现
- (void)jifenAction:(UIButton *)button {
    if (button.tag == 100) {
        
        LxmMineJifenMingXiTVC * vc =[[LxmMineJifenMingXiTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        vc.scoreType = 2;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 101) {
        LxmShengYuDaiZhuanJiFenListTVC * vc =[[LxmShengYuDaiZhuanJiFenListTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 102) {
        if ([button.titleLabel.text isEqualToString:@"转出"]) {
            LxmZhuanChuJiFenVC * vc =[[LxmZhuanChuJiFenVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.top_name = self.jifenModel.top_name;
            vc.jifen = self.jifenModel.my_score.doubleValue;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //提现
            LxmTiXianVC *vc = [[LxmTiXianVC alloc] init];
            vc.isJiFen = YES;
            vc.scoreType = 2;
            vc.score = self.jifenModel.my_score.doubleValue;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else if (button.tag == 103) {
        
        LxmMineJifenMingXiTVC * vc =[[LxmMineJifenMingXiTVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
        vc.hidesBottomBarWhenPushed = YES;
        vc.scoreType = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (button.tag == 104) {
        
        LxmTiXianVC *vc = [[LxmTiXianVC alloc] init];
        vc.isJiFen = YES;
        vc.score = self.jifenModel.direct_score.doubleValue;
        vc.scoreType = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}


- (void)lishiAction{
    LxmLiShiXiaoXiVC * vc =[[LxmLiShiXiaoXiVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
