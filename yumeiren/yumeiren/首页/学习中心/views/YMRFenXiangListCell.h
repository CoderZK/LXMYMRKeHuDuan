//
//  YMRFenXiangListCell.h
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMRFenXiangNeiView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YMRFenXiangListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headBt;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *levelBt;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *linev;

@property(nonatomic,strong)YMRFenXiangNeiView *leftView,*rightView;


@end

NS_ASSUME_NONNULL_END
