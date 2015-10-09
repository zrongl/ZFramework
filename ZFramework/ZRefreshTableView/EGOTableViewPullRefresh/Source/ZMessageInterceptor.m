//
//  ZMessageInterceptor.m
//
//  From http://stackoverflow.com/questions/3498158/intercept-obj-c-delegate-messages-within-a-subclass
//

#import "ZMessageInterceptor.h"

@implementation ZMessageInterceptor

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([_middleMan respondsToSelector:aSelector]) { return _middleMan; }
    if ([_receiver respondsToSelector:aSelector]) { return _receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([_middleMan respondsToSelector:aSelector]) { return YES; }
    if ([_receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

@end
