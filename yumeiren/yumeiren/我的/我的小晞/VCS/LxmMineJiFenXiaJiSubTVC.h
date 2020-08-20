//
//  LxmMineJiFenXiaJiSubTVC.h
//  yumeiren
//
//  Created by zk on 2020/7/1.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmMineJiFenXiaJiSubTVC : BaseTableViewController
@property(nonatomic,assign)NSInteger type;
@property (nonatomic, assign) NSInteger page;



- (void)loadData;
@end

NS_ASSUME_NONNULL_END
