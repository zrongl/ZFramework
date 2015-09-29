//
//  ZHelper.m
//  ZFramework
//
//  Created by ronglei on 15/9/28.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZHelper.h"
#import "Macro.h"

@implementation ZHelper

+ (UIButton *)createButtonWithPoint:(CGPoint)origin title:(NSString *)title action:(SEL)action target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectZero;
    frame.origin = origin;
    frame.size = CGSizeMake(110, 32);
    button.frame = frame;
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kThemeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
