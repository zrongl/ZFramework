//
//  NSDate+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/6/27.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "NSDate+ZAddition.h"

@implementation NSDate (ZAddition)

+ (NSString *)currentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

@end
