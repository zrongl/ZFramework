//
//  ZArchivingMacro.h
//  ZFramework
//
//  Created by ronglei on 16/9/14.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#ifndef ZArchivingMacro_h
#define ZArchivingMacro_h

#import <objc/runtime.h>

/* (EN)Provide Serialization kit for class (in ARC mode). With this serialize kit, there is no need any more
 * to implement (encode:) or )decode:) everywhere, like:
 *
 *      self.name = [coder decodeObjectForKey:@"name"];
 self.age = [[coder decodeObjectForKey:@"age"] integerValue];
 _father = [coder decodeObjectForKey:@"_father"];
 
 [coder encodeObject:self.name forKey:@"name"];
 [coder encodeObject:@(self.age) forKey:@"age"];
 [coder encodeObject:_father forKey:@"_father"];
 *
 *  (CN)本文件提供iOS下的序列化与反序列集成方案，几行代码即可轻松实现。
 *  在传统方式中当你需要对某个对象进行序列化与反序列化时，往往需要实现<NSCoding>协议以及<NSCopying>协议(非必须)，
 *  在协议方法中对需要序列化的变量执行encode&decode操作。当变量较多并且需要序列化的自定义对象较多时容易出现过多冗余代码，稍有不慎容易出错。
 *  ZSerializeKit在运行时对类以及所有层级父类的变量进行遍历，避免遗漏。属性越多，优势越明显。
 *
 * Usage:
 *
 * Person.h:
 * ========================================
 *	#import "ZSerializeKit.h"
 *
 *	@interface Person: SomeSuperclass<NSCoding, NSCopying>
 *	{
 *		...
 *	}
 *
 *	@end
 * ========================================
 *
 *
 *	Person.m:
 * ========================================
 *	#import "Person.h"
 *
 *	@implementation Person
 *
 *  ZSERIALIZE_CODER_DECODER();
 *  ZSERIALIZE_COPY_WITH_ZONE();
 *  ZSERIALIZE_DESCRIPTION();//(NOT NECESSARY)
 *
 *	@end
 * ========================================
 *
 *
 *  at the place where you want to serialize Person instance:
 *  eg:
 *      //archive object to NSData
 *      ZSERIALIZE_ARCHIVE(person, @"Person", [self filePath]);
 *
 *      //unarchive NSData to object
 *      Person *thePerson = nil;
 *      ZSERIALIZE_UNARCHIVE(thePerson, @"Person", [self filePath]);
 */

// NSCoding
#define ZSERIALIZE_CODER_DECODER()     \
\
- (id)initWithCoder:(NSCoder *)coder    \
{   \
NSLog(@"%s",__func__);  \
Class cls = [self class];   \
while (cls != [NSObject class]) {   \
/*判断是自身类还是父类*/    \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];   \
id varValue = [coder decodeObjectForKey:key];   \
if (varValue) { \
[self setValue:varValue forKey:key];    \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
return self;    \
}   \
\
- (void)encodeWithCoder:(NSCoder *)coder    \
{   \
NSLog(@"%s",__func__);  \
Class cls = [self class];   \
while (cls != [NSObject class]) {   \
/*判断是自身类还是父类*/    \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/ \
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];    \
/*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
id varValue = [self valueForKey:key];   \
if (varValue) { \
[coder encodeObject:varValue forKey:key];   \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
}

// NSCopying
#define ZSERIALIZE_COPY_WITH_ZONE()  \
\
/*如果不实现copyWithZone:方法，则[personObject copy]时会崩溃*/   \
- (id)copyWithZone:(NSZone *)zone   \
{   \
NSLog(@"%s",__func__);  \
id copy = [[[self class] allocWithZone:zone] init];    \
Class cls = [self class];   \
while (cls != [NSObject class]) {  \
/*判断是自身类还是父类*/    \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];    \
/*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
id varValue = [self valueForKey:key];   \
if (varValue) { \
[copy setValue:varValue forKey:key];    \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
return copy;    \
}

// Description
#define ZSERIALIZE_DESCRIPTION() \
\
/* 用来打印本类的所有变量(成员变量+属性变量)，所有层级父类的属性变量及其对应的值 */  \
- (NSString *)description   \
{   \
NSString  *despStr = @"";   \
Class cls = [self class];   \
while (cls != [NSObject class]) {   \
/*判断是自身类还是父类*/  \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];    \
/*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
id varValue = [self valueForKey:key];   \
if (varValue) { \
despStr = [despStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, varValue]]; \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
return despStr; \
}

#endif /* ZArchivingMacro_h */