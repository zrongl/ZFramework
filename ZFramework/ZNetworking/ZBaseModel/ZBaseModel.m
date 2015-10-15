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

static NSArray *propertiesOfClass(id cls)
{
    unsigned int outCount, i;
    NSMutableArray *propertiesArray = [NSMutableArray new];
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [propertiesArray addObject:[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]];
    }
    
    return propertiesArray;
}

@implementation ZBaseModel

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
{
    id object = [[self alloc] init];
    
    NSArray *properties = propertiesOfClass([self class]);
    NSMutableDictionary *mappingTable = [NSMutableDictionary dictionaryWithDictionary:[object fieldMappingTable]];
    for (NSString *propertyName in properties) {
        if (![mappingTable.allKeys containsObject:propertyName]) {
            [mappingTable setValue:propertyName forKey:propertyName];
        }
    }
    
    NSEnumerator *keyEnum = [mappingTable keyEnumerator];
    id propertyName;
    while ((propertyName = [keyEnum nextObject])) {
        SEL setterSelector = [object setterSelectorFrom:propertyName];
        if ([object respondsToSelector:setterSelector]) {
            NSString *fieldName = mappingTable[propertyName];
            id value = nil;
            if ([[keyValues objectForKey:fieldName] isKindOfClass:[NSNumber class]]) {
                value = [[keyValues objectForKey:fieldName] stringValue];
            }else if([[keyValues objectForKey:fieldName] isKindOfClass:[NSNull class]]){
                value = nil;
            }else{
                value = [keyValues objectForKey:fieldName];
            }
            
            [object performSelectorOnMainThread:setterSelector
                                     withObject:value
                                  waitUntilDone:[NSThread isMainThread]];
        }
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

- (SEL)setterSelectorFrom:(NSString *)propertyName
{
    NSString *capitalInital = [[propertyName substringToIndex:1] uppercaseString];
    NSString *selectorString = [NSString stringWithFormat:@"set%@%@:",capitalInital,[propertyName substringFromIndex:1]];
    return NSSelectorFromString(selectorString);
}

- (NSDictionary*)fieldMappingTable
{
    return nil;
}

@end
