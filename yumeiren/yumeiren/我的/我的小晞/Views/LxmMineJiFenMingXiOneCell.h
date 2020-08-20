//
//  LxmMineJiFenMingXiOneCell.h
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxmJiFenModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LxmMineJiFenMingXiOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *typeBt;
@property(nonatomic,strong)LxmJiFenModel *model;

@property(nonatomic,assign)NSInteger type; // 0 团队小晞明细 , 1 直属小晞明细 


@end

NS_ASSUME_NONNULL_END
