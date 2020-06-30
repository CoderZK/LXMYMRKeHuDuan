//
//  NSDate+ServerDate.h
//  AAAA
//
//  Created by 宋乃银 on 2019/6/10.
//  Copyright © 2019 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ServerDate)

+ (void)updateServerTimestamp:(NSTimeInterval)timestamp;

+ (NSDate *)serverDate;

@end
