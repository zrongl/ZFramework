//
//  ZToastManager.m
//  ZFramework
//
//  Created by ronglei on 15/9/30.
//  Copyright © 2015年 ronglei. All rights reserved.
//


#import "ZToastManager.h"
#import "ZToastView.h"

@interface ZToastManager()
{
    NSOperationQueue *_toastQueue;
}
@end

@implementation ZToastManager

+ (ZToastManager*)sharedToastManager
{
    static dispatch_once_t oncePredicate;
    static ZToastManager* sharedToastManager;
    dispatch_once(&oncePredicate, ^{
        sharedToastManager = [[ZToastManager alloc] init];
    });
    return sharedToastManager;
}

+ (void)toastWithMessage:(NSString *)message stady:(float)second
{
    ZToastOperation *operation = [[ZToastOperation alloc] initWithMessage:message stady:second];
    [[ZToastManager sharedToastManager] addToastOperation:operation];
}

- (id)init
{
    self = [super init];
    if (self) {
        _toastQueue = [NSOperationQueue new];
        [_toastQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)addToastOperation:(ZToastOperation *)oper
{
    [_toastQueue addOperation:oper];
}

@end

@interface ZToastOperation()
{
    NSString    *_message;
    float       _stadySecond;
}
@end

@implementation ZToastOperation

- (id)initWithMessage:(NSString *)message stady:(float)second
{
    self = [super init];
    if (self) {
        _stadySecond = second;
        _message = message;
    }
    
    return self;
}

- (void)main
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZToastView sharedToastView] toastWithMessage:_message];
    });
    
    [NSThread sleepForTimeInterval:_stadySecond];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZToastView sharedToastView] hide];
    });
    
    // 延迟0.1秒，使得当前toast充分hide之后，下一个toast弹出
    [NSThread sleepForTimeInterval:kToastHideDelay + 0.1f];
}

@end

