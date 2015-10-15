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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGFloat width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    return ceil(width);
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    return ceil(height);
}

- (NSAttributedString *)attributStringWithPosition:(NSDictionary *)position color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    for (int i = 0; i < position.allKeys.count; i++) {
        NSString* key = position.allKeys[i];
        NSString* val = position[key];
        if (color) {
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([key intValue],[val intValue])];
        }
        if (font) {
            [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange([key intValue],[val intValue])];
        }
    }
    
    return attrString;
}
@end
