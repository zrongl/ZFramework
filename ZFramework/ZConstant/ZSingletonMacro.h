//
//  ZSingletonMacro.h
//  ZFramework
//
//  Created by ronglei on 16/9/14.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#ifndef ZSingletonMacro_h
#define ZSingletonMacro_h

#define ZSINGLETON_Macro(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
    @synchronized(self) {                            \
        if (z##_shared_obj_name_ == nil) {             \
            static dispatch_once_t done;\
            dispatch_once(&done, ^{ z##_shared_obj_name_ = [[self alloc] init]; });\
        }\
    }                                                \
    return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
    @synchronized(self) {                            \
        if (z##_shared_obj_name_ == nil) {             \
            z##_shared_obj_name_ = [super allocWithZone:NULL]; \
            return z##_shared_obj_name_;                 \
        }                                              \
    }                                                \
    return nil;                                    \
}                                                  \

#endif /* ZSingletonMacro_h */
