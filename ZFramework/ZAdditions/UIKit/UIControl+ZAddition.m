//
//  UIControl+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "UIControl+ZAddition.h"

static const int block_key;

@interface _ZUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _ZUIControlBlockTarget

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events
{
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender
{
    if (_block) _block(sender);
}

@end

@implementation UIControl (ZAddition)

- (void)removeAllTargets
{
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _z_allUIControlBlockTargets] removeAllObjects];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (!target || !action || !controlEvents) return;
    NSSet *targets = [target allTargets];
    for (id cTarget in targets) {
        NSArray *actions = [cTarget actionsForTarget:cTarget forControlEvent:controlEvents];
        for (NSString *cAction in actions) {
            [self removeTarget:target action:NSSelectorFromString(cAction) forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addActionBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents
{
    if (!block || !controlEvents) return;
    _ZUIControlBlockTarget *target = [[_ZUIControlBlockTarget alloc] initWithBlock:block
                                                                            events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _z_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)setActionBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents
{
    if (!block || !controlEvents) return;
    [self removeAllBlocksForControlEvents:controlEvents];
    [self addActionBlock:block forControlEvents:controlEvents];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    
    NSMutableArray *targets = [self _z_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_ZUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_z_allUIControlBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
