//
//  YMRXueXiModel.m
//  yumeiren
//
//  Created by zk on 2021/2/4.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRXueXiModel.h"

@implementation YMRXueXiModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",@"reasonDes":@"reason"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"YMRXueXiModel"};
}

- (void)setMap:(YMRXueXiModel *)map {
    _map = [YMRXueXiModel mj_objectWithKeyValues:map];
}

@end
