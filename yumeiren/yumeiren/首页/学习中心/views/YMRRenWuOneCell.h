//
//  YMRRenWuOneCell.h
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRRenWuOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *tiemLB;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;
@property (weak, nonatomic) IBOutlet UIButton *leftBt;
@property (weak, nonatomic) IBOutlet UIView *backV;

@end

NS_ASSUME_NONNULL_END
