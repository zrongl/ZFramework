//
//  NSString+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "NSString+ZAddition.h"

@implementation NSString (ZAddition)

- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)height
{
    CGFloat width = 0;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes context:nil].size.width;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        width = [self sizeWithFont:font
                 constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                     lineBreakMode:NSLineBreakByWordWrapping].width;
#pragma clang diagnostic pop
    }
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    return ceil(width);
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGFloat height = 0;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        height = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes context:nil].size.height;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        height = [self sizeWithFont:font
                  constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                      lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    return ceil(height);
}

+ (NSString *)stringWithUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

NSInteger const kMaxCharacterCount = 9;
+ (BOOL)controlContent:(NSString *)content
   shouldChangeInRange:(NSRange)range
     replacementString:(NSString *)string
{
    if (string.length > 0) {
        NSMutableString * futureString = [NSMutableString stringWithString:content];
        // 不允许输入一个以上的小数点
        if ([futureString containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        }
        [futureString insertString:string atIndex:range.location];
        if ([futureString containsString:@"."]) {
            // 检查小数点儿两边的位数
            NSArray *array = [futureString componentsSeparatedByString:@"."];
            NSString *integer = array[0];
            NSString *decimal = array[1];
            if (integer.length > kMaxCharacterCount || decimal.length > 2) {
                return NO;
            }
        }else{
            // 没有小数点限制整数为不能超过9
            if ((content.length + 1) > kMaxCharacterCount){
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSString *)timeStringToYearString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date = [formatter dateFromString:self];
    [formatter setDateFormat:@"YYYY"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)timeStampToTimeString
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}
@end
