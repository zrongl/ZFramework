//
//  ZKeyboardManager.m
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZKeyboardManager.h"

@implementation ZKeyboardManager
{
    NSHashTable *_observers;
}

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self defaultManager];
    });
}

+ (instancetype)defaultManager
{
    static ZKeyboardManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![UIApplication isAppExtension]) {
            manager = [[self alloc] _init];
        }
    });
    return manager;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"YYTextKeyboardManager init error" reason:@"Use 'defaultManager' to get instance." userInfo:nil];
    return [super init];
}

- (instancetype)_init
{
    self = [super init];
    _observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)_keyboardWillChangeFrameNotification:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(_notifyObserverskeyboardWillChangeFrame:)
                                               object:nil];
    [self performSelector:@selector(_notifyObserverskeyboardWillChangeFrame:)
               withObject:notify
               afterDelay:0
                  inModes:@[NSRunLoopCommonModes]];
}

- (void)_notifyObserverskeyboardWillChangeFrame:(NSNotification *)notify
{
    UIApplication *app = [UIApplication sharedExtensionApplication];
    if (!app) return;
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    for (id<ZKeyboardObserver> observer in _observers.copy) {
        if ([observer respondsToSelector:@selector(keyboardWillChangeFrame:duration:)]) {
            [observer keyboardWillChangeFrame:keyboardFrame duration:duration];
        }
    }
}

- (void)_keyboardWillHideNotification:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(_notifyObserversKeyboardWillHide)
                                               object:nil];
    [self performSelector:@selector(_notifyObserversKeyboardWillHide)
               withObject:nil
               afterDelay:0
                  inModes:@[NSRunLoopCommonModes]];
}

- (void)_notifyObserversKeyboardWillHide
{
    UIApplication *app = [UIApplication sharedExtensionApplication];
    if (!app) return;
    for (id<ZKeyboardObserver> observer in _observers.copy) {
        if ([observer respondsToSelector:@selector(keyboardWillHide)]) {
            [observer keyboardWillHide];
        }
    }
}

- (void)addObserver:(id<ZKeyboardObserver>)observer
{
    if (!observer) return;
    [_observers addObject:observer];
}

- (void)removeObserver:(id<ZKeyboardObserver>)observer
{
    if (!observer) return;
    [_observers removeObject:observer];
}

@end
