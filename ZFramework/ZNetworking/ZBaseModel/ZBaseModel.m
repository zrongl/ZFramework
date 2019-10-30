//
//  LSBaseModel.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/17.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZBaseModel.h"
#include <objc/objc.h>
#include <objc/runtime.h>
#include "EXTRuntimeExtensions.h"

static void *ZCachedPropertyNamesKey = &ZCachedPropertyNamesKey;
static void *ZCachedPermanentPropertyKeysKey = &ZCachedPermanentPropertyKeysKey;
static void *ZCachedTransitoryPropertyKeysKey = &ZCachedTransitoryPropertyKeysKey;

static BOOL ZValidateAndSetValue(id obj, NSString *key, id value, BOOL forceUpdate, NSError **error)
{
    // Mark this as being autoreleased, because validateValue may return
    // a new object to be stored in this variable (and we don't want ARC to
    // double-free or leak the old or new values).
    __autoreleasing id validatedValue = value;
    
    @try {
        if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
        
        if (forceUpdate || value != validatedValue) {
            [obj setValue:validatedValue forKey:key];
        }
        
        return YES;
    } @catch (NSException *ex) {
        NSLog(@"*** Caught exception setting key \"%@\" : %@", key, ex);
        
        // Fail fast in Debug builds.
#if DEBUG
        @throw ex;
#else
        if (error != NULL) {
            NSParameterAssert(ex != nil);
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: ex.description,
                                       NSLocalizedFailureReasonErrorKey: ex.reason
//                                       MTLModelThrownExceptionErrorKey: ex
                                       };
            
            *error = [NSError errorWithDomain:@"ZBaseModelDomain" code:@"ZBaseModelException" userInfo:userInfo];
        }
        
        return NO;
#endif
    }
}

@interface ZBaseModel()

+ (void)generateAndCacheStorageBehaviors;
+ (NSSet *)transitoryPropertyKeys;
+ (NSSet *)permanentPropertyKeys;

@end

@implementation ZBaseModel

#pragma mark - private method
+ (void)generateAndCacheStorageBehaviors
{
    NSMutableSet *transitoryKeys = [NSMutableSet set];
    NSMutableSet *permanentKeys = [NSMutableSet set];
    
    for (NSString *propertyKey in self.propertyKeys) {
        switch ([self propertyStorageWithName:propertyKey]) {
            case ZPropertyStorageNone:
                break;
                
            case ZPropertyStorageTransitory:
                [transitoryKeys addObject:propertyKey];
                break;
                
            case ZPropertyStoragePermanent:
                [permanentKeys addObject:propertyKey];
                break;
        }
    }
    
    // It doesn't really matter if we replace another thread's work, since we do
    // it atomically and the result should be the same.
    objc_setAssociatedObject(self, ZCachedTransitoryPropertyKeysKey, transitoryKeys, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, ZCachedPermanentPropertyKeysKey, permanentKeys, OBJC_ASSOCIATION_COPY);
}

+ (NSSet *)transitoryPropertyKeys
{
    NSSet *transitoryPropertyKeys = objc_getAssociatedObject(self, ZCachedTransitoryPropertyKeysKey);
    
    if (transitoryPropertyKeys == nil) {
        [self generateAndCacheStorageBehaviors];
        transitoryPropertyKeys = objc_getAssociatedObject(self, ZCachedTransitoryPropertyKeysKey);
    }
    
    return transitoryPropertyKeys;
}

+ (NSSet *)permanentPropertyKeys
{
    NSSet *permanentPropertyKeys = objc_getAssociatedObject(self, ZCachedPermanentPropertyKeysKey);
    
    if (permanentPropertyKeys == nil) {
        [self generateAndCacheStorageBehaviors];
        permanentPropertyKeys = objc_getAssociatedObject(self, ZCachedPermanentPropertyKeysKey);
    }
    
    return permanentPropertyKeys;
}

- (NSDictionary *)dictionaryValue
{
    NSSet *keys = [self.class.transitoryPropertyKeys setByAddingObjectsFromSet:self.class.permanentPropertyKeys];
    return [self dictionaryWithValuesForKeys:keys.allObjects];
}

#pragma mark - public method
- (instancetype)initWithDictionary:(NSDictionary *)keyValues error:(NSError **)error
{
    self = [super init];
    if (self) {
        
        for (NSString *key in keyValues) {
            // Mark this as being autoreleased, because validateValue may return
            // a new object to be stored in this variable (and we don't want ARC to
            // double-free or leak the old or new values).
            __autoreleasing id value = [keyValues objectForKey:key];
            
            if ([value isEqual:NSNull.null]) value = nil;
            
            BOOL success = ZValidateAndSetValue(self, key, value, YES, error);
            if (!success) return nil;
        }
    }
    
    return self;
}

+ (NSSet *)propertyKeys
{
    NSSet *cachedKeys = objc_getAssociatedObject(self, ZCachedPropertyNamesKey);
    if (cachedKeys != nil) return cachedKeys;
    
    Class cls = self;
    NSMutableSet *keys = [NSMutableSet set];
    while (![cls isEqual:ZBaseModel.class]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        cls = cls.superclass;
        if (properties == NULL) continue;
        for (int i = 0; i < count; i ++) {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property));
            // 过滤掉那些未使用默认getter/setter方法的属性
            if ([self propertyStorageWithName:name] != ZPropertyStorageNone) {
                [keys addObject:name];
            }
        }
    }
    
    objc_setAssociatedObject(self, ZCachedPropertyNamesKey, keys, OBJC_ASSOCIATION_COPY);
    
    return keys;
}

+ (ZPropertyStorage)propertyStorageWithName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty(self.class, propertyName.UTF8String);
    
    if (property == NULL) return ZPropertyStorageNone;
    
    objc_propertyAttributes *attributes = objc_copyPropertyAttributes(property);
    
    BOOL hasGetter = [self instancesRespondToSelector:attributes->getter];
    BOOL hasSetter = [self instancesRespondToSelector:attributes->setter];
    // @dynamic声明的属性并且未实现getter/setter方法不会在-hash与-descrption方法中出现
    if (!attributes->dynamic && attributes->ivar == NULL && !hasGetter && !hasSetter) {
        return ZPropertyStorageNone;
    }
    else if (attributes->readonly && attributes->ivar == NULL) {
        // ZBaseModel的只读属性
        if ([self isEqual:ZBaseModel.class]) {
            return ZPropertyStorageTransitory;
        } else {
            // Check superclass in case the subclass redeclares a property that
            // falls through
            return [self.superclass propertyStorageWithName:propertyName];
        }
    }
    else {
        return ZPropertyStoragePermanent;
    }
}

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id object = [[self alloc] init];
    NSSet *properties = self.class.propertyKeys;
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[object fieldMappingTable]];
    for (NSString *name in properties) {
        if (![mapping.allKeys containsObject:name]) {
            [mapping setValue:name forKey:name];
        }
    }
    
    NSEnumerator *keyEnum = [mapping keyEnumerator];
    id key;
    while ((key = [keyEnum nextObject])) {
        __autoreleasing id value = [keyValues objectForKey:mapping[key]];
        if ([value isEqual:NSNull.null]) value = nil;
        BOOL success = ZValidateAndSetValue(object, key, value, YES, nil);
        if (!success) return nil;
    }
    
    return object;
}

+ (NSArray *)objectsArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[keyValuesArray count]];
    for (NSDictionary *dictionary in keyValuesArray) {
        [objects addObject:[[self class] objectWithKeyValues:dictionary]];
    }
    
    return objects;
}

- (NSDictionary*)fieldMappingTable
{
    return nil;
}

#pragma mark NSCopying
- (instancetype)copyWithZone:(NSZone *)zone
{
    ZBaseModel *copy = [[self.class allocWithZone:zone] init];
    [copy setValuesForKeysWithDictionary:self.dictionaryValue];
    return copy;
}

#pragma mark NSObject
- (NSString *)description
{
    NSDictionary *permanentProperties = [self dictionaryWithValuesForKeys:self.class.permanentPropertyKeys.allObjects];
    
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, permanentProperties];
}

- (NSUInteger)hash
{
    NSUInteger value = 0;
    
    for (NSString *key in self.class.permanentPropertyKeys) {
        value ^= [[self valueForKey:key] hash];
    }
    
    return value;
}

- (BOOL)isEqual:(ZBaseModel *)model
{
    if (self == model) return YES;
    if (![model isMemberOfClass:self.class]) return NO;
    
    for (NSString *key in self.class.permanentPropertyKeys) {
        id selfValue = [self valueForKey:key];
        id modelValue = [model valueForKey:key];
        
        BOOL valuesEqual = ((selfValue == nil && modelValue == nil) || [selfValue isEqual:modelValue]);
        if (!valuesEqual) return NO;
    }
    
    return YES;
}

@end
