//
//  ZMemoryCache.h
//  ZFramework
//
//  Created by ronglei on 16/6/6.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMemoryCache : NSObject

- (id)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)setObject:(id)obj forKey:(NSString *)key;

@end
