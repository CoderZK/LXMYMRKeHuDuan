//
//  LxmMineYeJiKaoCell.h
//  yumeiren
//
//  Created by zk on 2020/7/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmMineYeJiKaoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *leftBt;
@property (weak, nonatomic) IBOutlet UIButton *rightBt;
@property (weak, nonatomic) IBOutlet UILabel *leftOneLB;
@property (weak, nonatomic) IBOutlet UILabel *leftTwoLB;
@property (weak, nonatomic) IBOutlet UILabel *leftThreeLB;
@property (weak, nonatomic) IBOutlet UILabel *rightOneLB;
@property (weak, nonatomic) IBOutlet UILabel *rightTwoLB;
@property (weak, nonatomic) IBOutlet UIView *yjView;
@property (weak, nonatomic) IBOutlet UILabel *numberOneLB;
@property (weak, nonatomic) IBOutlet UILabel *numberTwoLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YConstrint;
@property (weak, nonatomic) IBOutlet UILabel *leftFourLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Hconstraint;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desCon;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTwoCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBottomCon;

@property(nonatomic,assign)NSInteger type; // 1 经理

@property(nonatomic,assign)BOOL isJingLi; // 100 月 101 季

@end

NS_ASSUME_NONNULL_END
