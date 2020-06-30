//
//  LxmDetailAddressVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/9/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LxmDetailAddressVC : BaseTableViewController

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) AMapPOI *poi;

@property (nonatomic, copy) void(^didselectPoi)(AMapPOI *poi);

@end


@interface LxmMapCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) AMapPOI *poi;

@end


@interface LxmMapAnnotionView : MAAnnotationView

@property (nonatomic, strong) UIImageView *imgView;

@end

