//
//  NSMutableAttributedString+CheckSetColor.m
//  54school
//
//  Created by 宋乃银 on 2018/9/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "NSMutableAttributedString+CheckSetColor.h"

@implementation NSMutableAttributedString (CheckSetColor)

- (void)setColor:(UIColor *)color forSubText:(NSString *)text {
    if (text.length > 0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:text options:0 error:nil];
        NSArray * array = [regex matchesInString:self.string options:0 range:NSMakeRange(0, self.length)];
        for (NSInteger i = array.count - 1; i >=0; --i) {
            NSTextCheckingResult *result = array[i];
            [self addAttribute:NSForegroundColorAttributeName value:color ? color : UIColor.blackColor range:result.range];
        }
    }
}

@end
