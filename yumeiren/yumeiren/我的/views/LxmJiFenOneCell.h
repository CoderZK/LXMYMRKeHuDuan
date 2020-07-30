//
//  LxmJiFenOneCell.h
//  yumeiren
//
//  Created by zk on 2020/7/28.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmJiFenOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftOneLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *socreLB;
@property(nonatomic,strong)LxmHomeBannerModel *model;
@end

NS_ASSUME_NONNULL_END
