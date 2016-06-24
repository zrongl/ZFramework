//
//  ZSentinel.m
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZSentinel.h"
#import <libkern/OSAtomic.h>

@implementation ZSentinel
{
    int32_t _value;
}

- (int32_t)value
{
    return _value;
}

- (int32_t)increase
{
    return OSAtomicIncrement32(&_value);
}

@end
