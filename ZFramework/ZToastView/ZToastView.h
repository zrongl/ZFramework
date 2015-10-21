//
//  ZToastView.h
//  ZFramework
//
//  Created by ronglei on 15/9/30.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kToastHideDelay     0.3f

typedef NS_ENUM(NSInteger, ZToastMode)  {
    ZToastSerialMode,
    ZToastUniqueMode
};

typedef NS_ENUM(NSInteger, ZToastStyle) {
    ZToastLoadingStyle,
    ZToastMessageStyle,
    ZToastProgressStyle
};

@interface ZToastView : UIView

/**
 *  供ZToastOperation调用
 */
+ (ZToastView*)sharedToastView;
- (void)hide;
- (void)toastWithMessage:(NSString *)message;

/**
 *  直接弹出提示框，当有多个弹框时，前面的弹框会被后面的覆盖
 *
 *  @param message 提示信息
 *  @param second  显示时间
 */
+ (void)toastWithMessage:(NSString *)message stady:(float)second;

+ (void)serialToastWithMessage:(NSString *)message stady:(float)second;

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
+ (id)operationWithMessage:(NSString *)message stady:(float)second;

@end
