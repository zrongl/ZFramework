//
//  ZBaseModel+NSCoding.h
//  ZFramework
//
//  Created by ronglei on 16/5/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZBaseModel.h"

/// Defines how a MTLModel property key should be encoded into an archive.
///
/// ZModelEncodingBehaviorExcluded      - The property should never be encoded.
/// ZModelEncodingBehaviorUnconditional - The property should always be
///                                       encoded.
/// ZModelEncodingBehaviorConditional   - The object should be encoded only
///                                       if unconditionally encoded elsewhere.
///                                       This should only be used for object
///                                       properties.

typedef enum : NSUInteger {
    ZModelEncodingBehaviorExcluded = 0,
    ZModelEncodingBehaviorUnconditional,
    ZModelEncodingBehaviorConditional,
} ZModelEncodingBehavior;

@interface ZBaseModel (NSCoding) <NSCoding>

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
