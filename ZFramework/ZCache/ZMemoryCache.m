//
//  ZMemoryCache.m
//  ZFramework
//
//  Created by ronglei on 16/6/6.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZMemoryCache.h"
#import <pthread.h>

#define LOCK(...) dispatch_async(_queue, ^{ \
pthread_mutex_lock(&_lock); \
__VA_ARGS__; \
pthread_mutex_unlock(&_lock); \
});

@implementation ZMemoryCache
{
    pthread_mutex_t             _lock;
    dispatch_queue_t            _queue;
    NSMapTable<NSString *, id>  *_mapTable;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _mapTable = [NSMapTable new];
        _queue = dispatch_queue_create("com.zrongl.cache.memory", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)setObject:(id)obj forKey:(NSString *)key
{
    LOCK([_mapTable setObject:obj forKey:key])
}

- (id)objectForKey:(NSString *)key
{
    return [_mapTable objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    LOCK([_mapTable removeObjectForKey:key])
}

@end
