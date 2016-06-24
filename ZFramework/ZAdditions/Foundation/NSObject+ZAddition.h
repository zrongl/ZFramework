//
//  NSObject+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZAddition)

- (id)deepCopy;

/**
 *  Associate  Property
 */
- (void)removeAssociatedValues;
- (id)getAssociatedValueForKey:(void *)key;
- (void)setAssociateValue:(id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(id)value withKey:(void *)key;

@end
