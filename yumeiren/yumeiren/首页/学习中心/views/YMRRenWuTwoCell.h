//
//  YMRRenWuTwoCell.h
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRRenWuTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *numberBt;
@property (weak, nonatomic) IBOutlet UIButton *headBt;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *leveBt;
@property (weak, nonatomic) IBOutlet UILabel *scoreLB;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end

NS_ASSUME_NONNULL_END
