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

#define kToastWidthScale    0.6f

@interface ZToastView()
{
    UILabel *_messageLabel;
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

+ (void)toastWithMessage:(NSString *)message stady:(float)second
{
    [[ZToastView sharedToastView] toastWithMessage:message stady:second];
}

- (void)toastWithMessage:(NSString *)message stady:(float)second
{
    [self layoutWithMessage:message];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self performSelector:@selector(hide) withObject:nil afterDelay:second];
}

- (id)init
{
    CGRect frame = CGRectMake(kMainBoundsWidth*(1 - kToastWidthScale)/2, kMainBoundsHeight - 130, kMainBoundsWidth*kToastWidthScale, 30.f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.cornerRadius = 3.f;
        _messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14.f];
        _messageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_messageLabel];
    }
    
    return self;
}

- (void)toastWithMessage:(NSString *)message
{
    [self layoutWithMessage:message];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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

- (void)layoutWithMessage:(NSString *)message
{
    CGFloat width = [message widthWithFont:[UIFont systemFontOfSize:14] height:30];
    if (width > kMainBoundsWidth*kToastWidthScale - 20 && width < kMainBoundsWidth - 20) {
        self.frame = CGRectMake((kMainBoundsWidth - width - 20)/2, kMainBoundsHeight - 130, width + 20, 30);
        _messageLabel.frame = CGRectMake(10, 0, width, 30);
    }else if (width > kMainBoundsWidth - 20){
        self.frame = CGRectMake(10, kMainBoundsHeight - 130, kMainBoundsWidth - 20, 30);
        _messageLabel.frame = CGRectMake(10, 0, kMainBoundsWidth - 40, 30);
    }
    self.alpha = 1.f;
    _messageLabel.text = message;
}
@end
