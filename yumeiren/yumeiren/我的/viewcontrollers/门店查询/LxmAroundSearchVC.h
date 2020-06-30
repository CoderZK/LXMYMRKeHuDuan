//
//  LxmAroundSearchVC.h
//  yumeiren
//
//  Created by 李晓满 on 2019/10/30.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmAroundSearchVC : BaseTableViewController

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) AMapGeoPoint *location;

@property (nonatomic, copy) void(^didselectBlock)(AMapPOI *poi, NSString *address);

@end

NS_ASSUME_NONNULL_END
