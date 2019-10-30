//
//  UIControl+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (ZAddition)

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addActionBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
- (void)setActionBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;

@end
