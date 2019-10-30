//
//  UIGestureRecognizer+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (ZAddition)

- (instancetype)initWithActionBlock:(void (^)(id sender))block;
- (void)addActionBlock:(void (^)(id sender))block;
- (void)removeAllActionBlocks;

@end
