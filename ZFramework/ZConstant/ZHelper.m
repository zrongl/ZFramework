//
//  ZHelper.m
//  ZFramework
//
//  Created by ronglei on 15/9/28.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZHelper.h"
#import "ZConstant.h"

@implementation ZHelper

+ (UIView *)seperateCellWithY:(CGFloat)y
{
    return [ZHelper seperateCellWithY:y color:nil];
}

+ (UIView *)seperateCellWithY:(CGFloat)y color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 8)];
    view.backgroundColor = color ? color : kBackgroundColor;
    return view;
}

+ (UIView *)seperateLineWithY:(CGFloat)y
{
    return [ZHelper seperateLineWithY:y color:nil];
}

+ (UIView *)seperateLineWithY:(CGFloat)y color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 0.5)];
    view.backgroundColor = color ? color : kBackgroundColor;
    return view;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kMainColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return button;
}

+ (UILabel *)labelWithFrame:(CGRect)frame fontSize:(CGFloat)size color:(UIColor *)color textAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    if (alignment) {
        label.textAlignment = alignment;
    }
    
    return label;
}

+ (UIColor *)hexStringToColor: (NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
