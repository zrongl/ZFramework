//
//  chelper.h
//  ZFramework
//
//  Created by ronglei on 15/10/14.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#ifndef chelper_h
#define chelper_h

#include <stdio.h>
#include <objc/objc.h>
#include <objc/runtime.h>

// 获取当前时间转换为微秒并返回
long long get_micro_time();

void printPropertyList(Class cls);

#endif /* chelper_h */
