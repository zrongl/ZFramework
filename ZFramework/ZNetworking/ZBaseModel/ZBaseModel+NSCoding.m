//
//  ZBaseModel+NSCoding.m
//  ZFramework
//
//  Created by ronglei on 16/5/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZBaseModel+NSCoding.h"
#import "EXTRuntimeExtensions.h"

@implementation ZBaseModel (NSCoding)

- (id)initWithCoder:(NSCoder *)coder
{
    NSSet *propertyKeys = self.class.propertyKeys;
    NSMutableDictionary *dictionaryValue = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
    
    for (NSString *key in propertyKeys) {
        id value = [coder decodeObjectForKey:key];
        if (value == nil) continue;
        
        dictionaryValue[key] = value;
    }
    
    NSError *error = nil;
    self = [self initWithDictionary:dictionaryValue error:&error];
    if (self == nil) NSLog(@"*** Could not unarchive %@: %@", self.class, error);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSSet *propertyKeys = self.class.propertyKeys;
    NSMutableDictionary *behaviors = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
    
    for (NSString *key in propertyKeys) {
        objc_property_t property = class_getProperty(self.class, key.UTF8String);
        NSAssert(property != NULL, @"Could not find property \"%@\" on %@", key, self);
        
        objc_propertyAttributes *attributes = objc_copyPropertyAttributes(property);
        
        ZModelEncodingBehavior behavior = (attributes->weak ? ZModelEncodingBehaviorConditional : ZModelEncodingBehaviorUnconditional);
        behaviors[key] = @(behavior);
    }
    for (NSString *key in behaviors.allKeys) {
        // Skip nil values.
        id value = behaviors[key];
        if ([value isEqual:NSNull.null]) return;
        
        switch ([behaviors[key] unsignedIntegerValue]) {
                // This will also match a nil behavior.
            case ZModelEncodingBehaviorExcluded:
                break;
                
            case ZModelEncodingBehaviorUnconditional:
                [coder encodeObject:value forKey:key];
                break;
                
            case ZModelEncodingBehaviorConditional:
                [coder encodeConditionalObject:value forKey:key];
                break;
                
            default:
                NSAssert(NO, @"Unrecognized encoding behavior %@ on class %@ for key \"%@\"", self.class, behaviors[key], key);
        }
    }
}

@end
