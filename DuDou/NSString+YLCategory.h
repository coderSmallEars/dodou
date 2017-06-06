//
//  NSString+YLCategory.h
//  AILottery
//
//  Created by jinyulong on 2017/1/19.
//  Copyright © 2017年 jinyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YLCategory)
//16位MD5
- (NSString *)MD5_16;

- (NSString *)dateStringByAddingDays:(NSInteger)days format:(NSString *)format;

- (NSDictionary *)jsonStringToDictionary;

- (NSString *)timeStringToFormat:(NSString *)format;

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;

- (NSInteger)linesWithFont:(UIFont *)font size:(CGSize)size;

- (NSString*)commentCreateTime;

- (NSString *)stringWithoutWhiteSpaceAndNewLineCharacter;

@end
