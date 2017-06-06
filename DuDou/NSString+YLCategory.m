//
//  NSString+YLCategory.m
//  AILottery
//
//  Created by jinyulong on 2017/1/19.
//  Copyright © 2017年 jinyulong. All rights reserved.
//

#import "NSString+YLCategory.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (YLCategory)
- (NSString *)MD5_16{
    const char *cStr =[self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString *)dateStringByAddingDays:(NSInteger)days format:(NSString *)format{
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8] ;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [NSDate dateWithString:self format:format timeZone:timeZone locale:locale];
    return [[date dateByAddingDays:days] stringWithFormat:@"yyyy-MM-dd"];
}

- (NSDictionary *)jsonStringToDictionary {
    if (!StringNotNull(self).length) {
        return [@{} copy];
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
    }
    return DictionaryNotNull(dic);
}

- (NSString *)timeStringToFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithString:StringNotNull(self) format:@"yyyy-MM-dd HH:mm:ss"];
    return [date stringWithFormat:StringNotNull(format)];
}

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size{
   return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (NSInteger)linesWithFont:(UIFont *)font size:(CGSize)size{
    CGFloat height = [self sizeWithFont:font size:size].height;
    NSInteger lines = (int)(height / font.lineHeight);
    if (self.length > 0 && lines == 0) {
        return 1;
    }else{
        return lines;
    }
}

- (NSString*)commentCreateTime
{
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//本地化
    [df setLocale:locale];
    NSDate *createDate = [df dateFromString:StringNotNull(self)];
    
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:createDate];
    if (timeBetween < 0) {
        [df setDateFormat:@"MM-dd HH:mm"];
        return [df stringFromDate:createDate];
    }
    int mmtime = timeBetween/60;
    int hhtime = timeBetween/3600;
    
    int a_minute = 1;
    int a_hour = 60;
    int a_day = 24*60;
    
    if (mmtime <= a_minute) {
        return @"刚刚";
    }
    if (mmtime > a_minute  &&  mmtime < a_hour) {
        return [NSString stringWithFormat:@"%d分钟前",mmtime];
    }
    if (mmtime >= a_hour && mmtime < a_day) {
        return [NSString stringWithFormat:@"%d小时前",hhtime];
    }
    [df setDateFormat:@"MM-dd HH:mm"];
    return [df stringFromDate:createDate];
}

- (NSString *)stringWithoutWhiteSpaceAndNewLineCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
