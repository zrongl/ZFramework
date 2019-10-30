//
//  NSThread+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "NSThread+ZAddition.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

static NSString *const ZNSThreadAutoleasePoolKey = @"ZNSThreadAutoleasePoolKey";
static NSString *const ZNSThreadAutoleasePoolStackKey = @"ZNSThreadAutoleasePoolStackKey";

static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    CFRelease((CFTypeRef)value);
}


static inline void ZAutoreleasePoolPush() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[ZNSThreadAutoleasePoolStackKey];
    
    if (!poolStack) {
        /*
         do not retain pool on push,
         but release on pop to avoid memory analyze warning
         */
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[ZNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; //< create
    [poolStack addObject:pool]; // push
}

static inline void ZAutoreleasePoolPop() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[ZNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject]; // pop
}

static void ZRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            ZAutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting: {
            ZAutoreleasePoolPop();
            ZAutoreleasePoolPush();
        } break;
        case kCFRunLoopExit: {
            ZAutoreleasePoolPop();
        } break;
        default: break;
    }
}

static void ZRunloopAutoreleasePoolSetup() {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    CFRunLoopObserverRef pushObserver;
    pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopEntry,
                                           true,         // repeat
                                           -0x7FFFFFFF,  // before other observers
                                           ZRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
    
    CFRunLoopObserverRef popObserver;
    popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                          true,        // repeat
                                          0x7FFFFFFF,  // after other observers
                                          ZRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
    CFRelease(popObserver);
}

@implementation NSThread (ZAddition)

+ (void)addAutoreleasePoolToCurrentRunloop
{
    if ([NSThread isMainThread]) return; // The main thread already has autorelease pool.
    NSThread *thread = [self currentThread];
    if (!thread) return;
    if (thread.threadDictionary[ZNSThreadAutoleasePoolKey]) return; // already added
    ZRunloopAutoreleasePoolSetup();
    thread.threadDictionary[ZNSThreadAutoleasePoolKey] = ZNSThreadAutoleasePoolKey; // mark the state
}

@end
