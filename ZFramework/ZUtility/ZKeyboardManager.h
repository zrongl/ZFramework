//
//  ZKeyboardManager.h
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZKeyboardObserver <NSObject>

- (void)keyboardWillChangeFrame:(CGRect)frame duration:(CGFloat)duration;
- (void)keyboardWillHide;

@end

@interface ZKeyboardManager : NSObject

+ (instancetype)defaultManager;
- (void)addObserver:(id<ZKeyboardObserver>)observer;
- (void)removeObserver:(id<ZKeyboardObserver>)observer;

@end
