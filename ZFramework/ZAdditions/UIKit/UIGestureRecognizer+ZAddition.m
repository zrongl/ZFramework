//
//  UIGestureRecognizer+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "UIGestureRecognizer+ZAddition.h"

static const int block_key;

@interface _ZUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _ZUIGestureRecognizerBlockTarget

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
    if (_block) _block(sender);
}

@end

@implementation UIGestureRecognizer (ZAddition)

- (instancetype)initWithActionBlock:(void (^)(id sender))block
{
    self = [self init];
    [self addActionBlock:block];
    return self;
}

- (void)addActionBlock:(void (^)(id sender))block
{
    _ZUIGestureRecognizerBlockTarget *target = [[_ZUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _z_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)removeAllActionBlocks
{
    NSMutableArray *targets = [self _z_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_z_allUIGestureRecognizerBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
