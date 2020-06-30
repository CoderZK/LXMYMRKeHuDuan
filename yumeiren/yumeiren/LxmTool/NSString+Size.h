//
//  NSString+Size.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
/**
 获得字符串的大小
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize;
/**
 获得属性字符串的大小
 */
- (CGSize)getAttSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

/**
 获得字符串的大小 粗体
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withBoldFontSize:(int)fontSize;
/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str;

+ (NSDate *)dataWithStr:(NSString *)str;
/****
 ios比较日期大小默认会比较到秒
 ****/
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


+ (NSString *)convertToJsonData:(id)dict;

/**
 转化时间
 */
+ (NSString *)stringWithTime:(NSString *)str;

/**
 转化时间月日
 */
+ (NSString *)stringChangeWithTime:(NSString *)str;

+ (NSString *)reviseString: (NSString *)str;


#pragma mark ---- 将时间戳转换成时间
//YYYY/MM/dd HH:mm
- (NSString *)getIntervalToFXXTime;

//YYYY-MM-dd HH:mm
- (NSString *)getIntervalToZHXTime;

//YYYY-MM-dd HH:mm:ss
- (NSString *)getIntervalToZHXLongTime;


//YYYY/MM/dd
- (NSString *)getIntervalToFXXTNoHHmmime;



- (BOOL)isValid;

- (BOOL)isContrainsKong;

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;

//判断是否包含数字
+ (BOOL)isContainNum:(NSString *)string;

/**
 转化时间倒计时
 */
+(double)chaWithCreateTime:(NSString *)creatTime;

+ (NSString *)durationTimeStringWithDuration:(NSInteger)time;

//格式化音视频时长
+ (NSString *)stringWithVideoTime:(NSString *)video_time;

+ (BOOL)checkPhone:(NSString *)phoneNumber;

+ (BOOL)checkEmail:(NSString *)email;

@end
