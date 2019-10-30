//
//  NSTimer+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZAddition)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats
                                      block:(void (^)(NSTimer *timer))block;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                           repeats:(BOOL)repeats
                             block:(void (^)(NSTimer *timer))block;
@end
