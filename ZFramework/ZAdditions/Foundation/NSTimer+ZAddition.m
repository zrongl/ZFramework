//
//  NSTimer+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "NSTimer+ZAddition.h"

@implementation NSTimer (ZAddition)

+ (void)_zExecuteBlock:(NSTimer *)timer
{
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats
                                      block:(void (^)(NSTimer *timer))block
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds
                                            target:self
                                          selector:@selector(_zExecuteBlock:)
                                          userInfo:[block copy]
                                           repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                           repeats:(BOOL)repeats
                             block:(void (^)(NSTimer *timer))block
{
    return [NSTimer timerWithTimeInterval:seconds
                                   target:self
                                 selector:@selector(_zExecuteBlock:)
                                 userInfo:[block copy]
                                  repeats:repeats];
}

@end
