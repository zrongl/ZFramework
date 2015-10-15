//
//  ZToastManager.h
//  ZFramework
//
//  Created by ronglei on 15/9/30.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZToastManager : NSObject

/**
 *  弹出提示框，当有多个弹框时，会依次弹出提示框，不会出现被覆盖的情况
 *
 *  @param message 提示信息
 *  @param second  显示时间
 */
+ (void)toastWithMessage:(NSString *)message stady:(float)second;

@end

@interface ZToastOperation : NSOperation

/**
 *  供ZToastManager调用
 *
 *  @param message 提示信息
 *  @param second  显示秒数
 *
 *  @return 返回ZToastOperation实例
 */
- (id)initWithMessage:(NSString *)message stady:(float)second;

@end