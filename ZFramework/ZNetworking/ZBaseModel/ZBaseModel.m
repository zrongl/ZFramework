//
//  LSBaseModel.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/17.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZBaseModel.h"

@implementation ZBaseModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        NSDictionary *mappingTable = [self fieldMappingTable];
        if (mappingTable != nil) {
            NSEnumerator *keyEnum = [mappingTable keyEnumerator];
            id propertyName;
            while ((propertyName = [keyEnum nextObject])) {
                SEL setterSelector = [self setterSelectorFrom:propertyName];
                if ([self respondsToSelector:setterSelector]) {
                    NSString *fieldName = mappingTable[propertyName];
                    id value = nil;
                    if ([[dictionary objectForKey:fieldName] isKindOfClass:[NSNumber class]]) {
                        value = [[dictionary objectForKey:fieldName] stringValue];
                    }else if([[dictionary objectForKey:fieldName] isKindOfClass:[NSNull class]]){
                        value = nil;
                    }else{
                        value = [dictionary objectForKey:fieldName];
                    }
                    
                    [self performSelectorOnMainThread:setterSelector
                                           withObject:value
                                        waitUntilDone:[NSThread isMainThread]];
                }
            }
        }
    }
    
    return self;
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
