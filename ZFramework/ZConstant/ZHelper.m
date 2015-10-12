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

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kMainColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(CGFloat)size color:(UIColor *)color textAlignment:(NSTextAlignment)alignment
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

@end
