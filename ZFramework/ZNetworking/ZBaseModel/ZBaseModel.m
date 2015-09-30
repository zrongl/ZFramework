//
//  LSBaseModel.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/17.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZBaseModel.h"

@implementation ZBaseModel

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        [self setAttributes:dic];
    }
    
    return self;
}

- (NSDictionary*)attributeMapDictionary
{
    return nil;
}

#pragma mark - private methods
- (SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

/**
 *  将服务端字段对应的值赋值给在attributeMapDictionary中与服务端字段相对应的model中属性
 *
 *  @param dic 服务端数据字典
 */
- (void)setAttributes:(NSDictionary*)dic
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = attrMapDic[attributeName];
            NSString *value = nil;
            if ([[dic objectForKey:dataDicKey] isKindOfClass:[NSNumber class]]) {
                value = [[dic objectForKey:dataDicKey] stringValue];
            }
            else if([[dic objectForKey:dataDicKey] isKindOfClass:[NSNull class]]){
                value = nil;
            }
            else{
                value = [dic objectForKey:dataDicKey];
            }
            [self performSelectorOnMainThread:sel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}


@end
