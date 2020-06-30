//
//  NSString+Size.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "NSString+Size.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+ServerDate.h"

@implementation NSString (Size)

/**
 获得属性字符串的大小
 */
- (CGSize)getAttSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle {
    CGRect rect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
     return rect.size;
}

- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize {
    static UILabel *_label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _label = [UILabel new];
        _label.numberOfLines = 0;
    });
    _label.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
    _label.font = [UIFont systemFontOfSize:fontSize];
    _label.text = self;
    [_label sizeToFit];
    CGSize size = _label.frame.size;
    
//    CGSize size=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withBoldFontSize:(int)fontSize {
    CGSize size=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size;
    return size;
}

/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str {
    const char *fooData = [str UTF8String];//UTF-8编码字符串
    unsigned char result[CC_MD5_DIGEST_LENGTH];//字符串数组，接收MD5
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);//计算并存入数组
    NSMutableString *saveResult = [NSMutableString string];//字符串保存加密结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}

+ (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

+(NSDate *)dataWithStr:(NSString *)str
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [formatter dateFromString:str];
}
/****
 ios比较日期大小默认会比较到秒
 ****/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}


+ (NSString *)convertToJsonData:(id )dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString = @"";
    if(!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**
 转化时间
 */

+(NSString *)stringWithTime:(NSString *)str {
    NSTimeInterval beTime = 0;
    if (str.length > 10) {
        //以毫秒为单位 就除以1000 默认以秒为单位
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        if([str containsString:@"."]){
            [df0 setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        } else if([str containsString:@"-"]){
            [df0 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        } else if([str containsString:@"/"]){
            [df0 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
        }
        
        NSDate *date0 = [df0 dateFromString:str];
        beTime = [date0 timeIntervalSince1970];
        
    } else {
        
        beTime = [str longLongValue];
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"yyyy"];
    NSString * nowYear = [df stringFromDate:[NSDate date]];
    NSString * lastYear = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {   //小于一分钟
        distanceStr = @"刚刚";
    } else if (distanceTime < 60*60) {   //时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    } else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]) {  //时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    } else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]) {
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        } else {
            [df setDateFormat:@"HH:mm"];
            distanceStr = [NSString stringWithFormat:@"前天 %@",[df stringFromDate:beDate]];
        }
        
    } else if(distanceTime < 24*60*60*365) {
        if ([nowDay integerValue] - [lastDay integerValue] == 2 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {//包含前天的部分
            [df setDateFormat:@"HH:mm"];
            distanceStr = [NSString stringWithFormat:@"前天 %@",[df stringFromDate:beDate]];
        } else {
            if ([nowYear integerValue] == [lastYear integerValue]) {//包含今年的部分
                [df setDateFormat:@"MM-dd HH:mm"];
                distanceStr = [df stringFromDate:beDate];
            } else {
                [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                distanceStr = [df stringFromDate:beDate];
            }
        }
    } else {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+ (NSString *)stringChangeWithTime:(NSString *)str {
    NSTimeInterval beTime = 0;
    if (str.length == 10) {
        //以毫秒为单位 就除以1000 默认以秒为单位
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        [df0 setDateFormat:@"yyyy-MM-dd"];
        NSDate *date0 = [df0 dateFromString:str];
        beTime = [date0 timeIntervalSince1970];
    }else {
        beTime = [str longLongValue];
    }
    
    NSString * distanceStr;
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    [df setDateFormat:@"yyyy"];
    NSString * nowYear = [df stringFromDate:[NSDate date]];
    NSString * lastYear = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    if ([nowYear integerValue] == [lastYear integerValue])
    {//包含今年的部分
        [df setDateFormat:@"MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    } else {
        [df setDateFormat:@"yyyy-MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

- (BOOL)isValid {
    if (self.length > 0 && ![[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isContrainsKong {
    if ([self containsString:@" "]) {
        return YES;
    }
    return NO;
}

+ (NSString *)reviseString: (NSString *)str {
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

//YYYY/MM/dd HH:mm
- (NSString *)getIntervalToFXXTime {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

//YYYY/MM/dd
- (NSString *)getIntervalToFXXTNoHHmmime {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

//YYYY-MM-dd HH:mm
- (NSString *)getIntervalToZHXTime {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

//YYYY-MM-dd HH:mm:ss
- (NSString *)getIntervalToZHXLongTime {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

//判断是否包含数字
+ (BOOL)isContainNum:(NSString *)string {
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = [tNumRegularExpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    return count > 0 ? YES : NO;
}

/**
 转化时间倒计时
 */
+(double)chaWithCreateTime:(NSString *)creatTime {
    NSTimeInterval beTime = 0;
    if (creatTime.length > 10) {
        //以毫秒为单位 就除以1000 默认以秒为单位
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        [df0 setTimeZone:[NSTimeZone localTimeZone]];
        if([creatTime containsString:@"."]){
            [df0 setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        } else if([creatTime containsString:@"-"]){
            [df0 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        } else if([creatTime containsString:@"/"]){
            [df0 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
        }
        NSDate *date0 = [df0 dateFromString:creatTime];
        date0 = [date0 dateByAddingTimeInterval:1800];
        beTime = [date0 timeIntervalSince1970];
    } else {
        beTime = [creatTime longLongValue];
        beTime = beTime + 1800;
    }
    NSTimeInterval now = [[NSDate serverDate] timeIntervalSince1970];
    double distanceTime = beTime - now;
    return distanceTime;
}

+ (NSString *)durationTimeStringWithDuration:(NSInteger)time {
    NSString *h = [NSString stringWithFormat:@"%02ld", time / 3600];
    NSString *m = [NSString stringWithFormat:@"%02ld", (time % 3600) / 60];
    NSString *s = [NSString stringWithFormat:@"%02ld", time % 60];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
    return timeStr;
}


+ (NSString *)stringWithVideoTime:(NSString *)video_time {
    NSArray * arr = [video_time  componentsSeparatedByString:@"."];
    if (arr.count>0) {
        if (arr.count == 1) {
            arr = @[arr.firstObject,@"0"];
        }
        NSInteger m = [arr.firstObject integerValue];
        NSString *str = arr.lastObject;
        NSInteger s = [arr.lastObject integerValue]*60/100;
        if (str.length > 2) {
            s = [[arr.lastObject substringToIndex:2] integerValue]*60/100;
        }

        NSInteger h = m/60;
        if (h>0) {
            m = m%6;
            return [NSString stringWithFormat:@"%ld:%.2ld:%.2ld",(long)h,(long)m,(long)s];
        } else {
            if (m>0) {
                NSString * time = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)m,(long)s];
                return time;
            } else {
                return [NSString stringWithFormat:@"00:%0.2ld",(long)s];
            }
        }
    } else {
        return @"0s";
    }
}

+ (BOOL)checkPhone:(NSString *)phoneNumber {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkEmail:(NSString *)email {
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}

@end
