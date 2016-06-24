//
//  ZSentinel.h
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSentinel : NSObject

@property (readonly) int32_t value;

- (int32_t)increase;

@end
