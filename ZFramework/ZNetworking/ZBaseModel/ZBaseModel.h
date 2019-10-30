//
//  LSBaseModel.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/17.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Defines a property's storage behavior, which affects how it will be copied,
/// compared, and persisted.
///
/// ZPropertyStorageNone       - This property is not included in -description,
///                              -hash, or anything else.
/// ZPropertyStorageTransitory - This property is included in one-off
///                              operations like -copy and -dictionaryValue but
///                              does not affect -isEqual: or -hash.
///                              It may disappear at any time.
/// ZPropertyStoragePermanent  - The property is included in serialization
///                              (like `NSCoding`) and equality, since it can
///                              be expected to stick around.
typedef enum: NSUInteger{
    ZPropertyStorageNone,
    ZPropertyStorageTransitory,
    ZPropertyStoragePermanent
}ZPropertyStorage;

@protocol ZBaseModel <NSObject, NSCopying>

+ (NSSet *)propertyKeys;

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;
+ (NSArray *)objectsArrayWithKeyValuesArray:(NSArray *)keyValuesArray;
- (instancetype)initWithDictionary:(NSDictionary *)keyValues error:(NSError **)error;

@property (nonatomic, copy, readonly) NSDictionary *dictionaryValue;

@end

@interface ZBaseModel : NSObject <ZBaseModel>

//+ (NSSet *)propertyKeys;

/**
 *  将服务端的字典转换为model
 *
 *  @param dic 服务端数据转换成的字典
 *
 *  @return 填充数据的model
 */
//+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;
//+ (NSArray *)objectsArrayWithKeyValuesArray:(NSArray *)keyValuesArray;
//- (instancetype)initWithDictionary:(NSDictionary *)keyValues error:(NSError **)error;

/**
 *  返回model自定义字符名称与服务端字段名称之间的映射字典
 *  {"userName":"user_name"
 *   ...
 *  }
 *  注意：对于属性名称与key相同的可以不用写入字典中
 */
- (NSDictionary*)fieldMappingTable;

- (NSString *)description;
- (BOOL)isEqual:(id)object;

@end
