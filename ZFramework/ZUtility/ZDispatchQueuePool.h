//
//  ZDispatchQueuePool.h
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ZDispatchQueuePool_h
#define ZDispatchQueuePool_h

NS_ASSUME_NONNULL_BEGIN

@interface ZDispatchQueuePool : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithName:(nullable NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos;
@property (nullable, nonatomic, readonly) NSString *name;
- (dispatch_queue_t)queue;

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos;

@end

extern dispatch_queue_t ZDispatchQueueGetForQOS(NSQualityOfService qos);

NS_ASSUME_NONNULL_END

#endif