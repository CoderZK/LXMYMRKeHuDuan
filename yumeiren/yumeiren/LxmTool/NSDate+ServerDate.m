//
//  NSDate+ServerDate.m
//  AAAA
//
//  Created by 宋乃银 on 2019/6/10.
//  Copyright © 2019 migu. All rights reserved.
//

#import "NSDate+ServerDate.h"

static NSInteger TimestampOffset = 0;

@implementation NSDate (ServerDate)

+ (void)updateServerTimestamp:(NSTimeInterval)timestamp {
    if (timestamp <= 0) {
        return;
    }
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970] * 1000;
    TimestampOffset = timestamp - currentTime;
}

+ (NSDate *)serverDate {
    NSDate *date = [NSDate date];
    return [date dateByAddingTimeInterval:TimestampOffset / 1000.0];
}

@end
