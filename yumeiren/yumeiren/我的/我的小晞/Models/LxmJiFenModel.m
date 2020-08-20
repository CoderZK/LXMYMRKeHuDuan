//
//  LxmJiFenModel.m
//  yumeiren
//
//  Created by zk on 2020/7/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmJiFenModel.h"

@implementation LxmJiFenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}


- (void)setOther_info:(NSString *)other_info {
    
    NSArray * arr = [other_info mj_JSONObject];
    self.otherInfoList = [LxmJiFenModel mj_objectArrayWithKeyValuesArray:arr];
    
}

@end
