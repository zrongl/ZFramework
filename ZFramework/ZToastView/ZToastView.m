//
//  ZToastView.m
//  ZFramework
//
//  Created by ronglei on 15/9/30.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZToastView.h"
#import "ZConstant.h"
#import "NSString+ZAddition.h"

#define kToastWidthScale    0.5f

@interface ZToastView()
{
    UILabel     *_messageLabel;
    NSString    *_message;
    NSOperationQueue *_queue;
    
}
@end

@implementation ZToastView

+ (ZToastView*)sharedToastView
{
    static dispatch_once_t oncePredicate;
    static ZToastView* shareToastView;
    dispatch_once(&oncePredicate, ^{
        shareToastView = [[ZToastView alloc] init];
    });
    return shareToastView;
}

+ (void)toastWithMessage:(NSString *)message
{
    [[ZToastView sharedToastView] toastWithMessage:message stady:2.f];
}

+ (void)toastWithMessage:(NSString *)message stady:(float)second
{
    [[ZToastView sharedToastView] toastWithMessage:message stady:second];
}

+ (void)serialToastWithMessage:(NSString *)message stady:(float)second
{
    [[ZToastView sharedToastView] addOperation:[ZToastOperation operationWithMessage:message stady:second]];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.cornerRadius = 3.f;
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14.f];
        _messageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_messageLabel];
        
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

- (void)toastWithMessage:(NSString *)message
{
    [self toastWithMessage:message stady:0];
}

- (void)toastWithMessage:(NSString *)message stady:(float)second
{
    _message = message;
    [self setNeedsLayout];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    if (second > 0) {
        [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
        [self performSelector:@selector(hide) withObject:nil afterDelay:second];
    }
}

- (void)hide
{
    [UIView animateWithDuration:kToastHideDelay animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = [_message widthWithFont:[UIFont systemFontOfSize:14] height:30];
    if (width > kScreenWidth*kToastWidthScale - 20 && width < kScreenWidth - 20) {
        self.frame = CGRectMake((kScreenWidth - width - 20)/2, kScreenHeight - 130, width + 20, 30);
        _messageLabel.frame = CGRectMake(10, 0, width, 30);
    }else if (width > kScreenWidth - 20){
        self.frame = CGRectMake(10, kScreenHeight - 130, kScreenWidth - 20, 30);
        _messageLabel.frame = CGRectMake(10, 0, kScreenWidth - 40, 30);
    }else{
        self.frame = CGRectMake(kScreenWidth*(1 - kToastWidthScale)/2, kScreenHeight - 130, kScreenWidth*kToastWidthScale, 30.f);
        _messageLabel.frame = self.bounds;
    }
    self.alpha = 1.f;
    _messageLabel.text = _message;
}

- (void)addOperation:(NSOperation *)operation
{
    [_queue addOperation:operation];
}

@end

@interface ZToastOperation()
{
    NSString    *_message;
    float       _stadySecond;
}

@end

@implementation ZToastOperation

+ (id)operationWithMessage:(NSString *)message stady:(float)second
{
    return [[ZToastOperation alloc] initWithMessage:message stady:second];
}

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
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, _stadySecond);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [[ZToastView sharedToastView] hide];
    });
    
    // 延迟0.1秒，使得当前toast充分hide之后，下一个toast弹出
    [NSThread sleepForTimeInterval:kToastHideDelay + 0.1f];
}

@end