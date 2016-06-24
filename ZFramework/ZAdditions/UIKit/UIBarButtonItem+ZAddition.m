//
//  UIBarButtonItem+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "UIBarButtonItem+ZAddition.h"

static const int block_key;

@interface _ZUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _ZUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block
{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender
{
    if (self.block) self.block(sender);
}

@end

@implementation UIBarButtonItem (ZAddition)

- (void)setActionBlock:(void (^)(id sender))block
{
    _ZUIBarButtonItemBlockTarget *target = [[_ZUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id))actionBlock
{
    _ZUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
