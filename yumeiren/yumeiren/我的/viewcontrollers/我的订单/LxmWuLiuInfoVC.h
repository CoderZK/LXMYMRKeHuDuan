//
//  LxmWuLiuInfoVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmWuLiuInfoVC : BaseTableViewController

@property (nonatomic, strong) LxmWuLiuInfoRootModel *rootModel;/* 快递信息什么的 */

@property (nonatomic, strong) NSArray <LxmWuLiuInfoStateModel *>*dataArr;

@end

NS_ASSUME_NONNULL_END
