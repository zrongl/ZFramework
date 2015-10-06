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

+ (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kThemeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake((kMainBoundsWidth - 220)/2, kMainBoundsHeight*0.5, 220, 40.f) ];
    
    return button;
}

@end
