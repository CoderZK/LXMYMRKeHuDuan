//
//  LxmZiTiJIeSuanVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmZiTiJieSuanVC : BaseTableViewController

@property (nonatomic, strong) NSMutableArray <LxmShopCarModel *>* fahuoArr;//发货货物

@end

@interface LxmZiTiNoteCell : UITableViewCell

@property (nonatomic, strong) IQTextView *noteView;//备注

@end
