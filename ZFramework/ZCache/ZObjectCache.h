//
//  ZArchiveObjectCache.h
//  DeepIntoCache
//
//  Created by ronglei on 15/10/20.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZObjectCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    ZObjectCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    ZObjectCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    ZObjectCacheTypeMemory
};

typedef void (^removeObjectBlock)(void);
typedef void (^cleanObjectBlock)(void);
typedef void (^checkCacheBlock)(BOOL isInCache);
typedef void (^calculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface ZObjectCache : NSObject

@property (assign, nonatomic) NSInteger     maxCacheAge;    // 缓存文件保留时间
@property (assign, nonatomic) NSUInteger    maxCacheSize;   // 缓存文件大小限制
@property (assign, nonatomic) NSUInteger    maxMemoryCost;  // 内存缓存大小限制

+ (ZObjectCache *)sharedFileCache;

/**
 *  创建object cache对象
 *
 *  @param extension 缓存文件的扩展名
 *
 *  @return 返回object cache对象
 */
- (id)initWithFileExtension:(NSString *)extension;

/**
 *  存储对象到内存缓存和硬盘缓存中
 *
 *  @param object 存储对象
 *  @param key    存储对象对应的关键字
 */
- (void)storeObject:(id)object forKey:(NSString *)key;
- (void)storeObject:(id)object forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 *  从缓存中读取对象，先从内存缓存中查找，再去硬盘中查找
 *
 *  @param key 存储对象对应的关键字
 *
 *  @return 存储的对象
 */
- (id)objectFromCacheForKey:(NSString *)key;
- (id)objectFromDiskCacheForKey:(NSString *)key;

/**
 *  从内存中移除存储对象
 *
 *  @param key 存储对象对应的关键字
 */
- (void)removeObjectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key completion:(removeObjectBlock)completion;
- (void)removeObjectForKey:(NSString *)key fromDisk:(BOOL)fromDisk completion:(removeObjectBlock)completion;

/**
 *  计算硬盘中缓存大小
 */
- (NSUInteger)calculateSize;
- (void)calculateSizeWithCompletionBlock:(calculateSizeBlock)completion;

/**
 *  计算缓存目录文件数量
 */
- (NSUInteger)calculateFileCount;

/**
 *  对象是否存储
 *
 *  @param key 存储对象对应的关键字
 *
 *  @return 布尔值
*/
- (BOOL)objectExistsWithKey:(NSString *)key;
- (void)objectExistsWithKey:(NSString *)key completion:(checkCacheBlock)completion;

/**
 *  清空缓存目录中缓存文件
 */
- (void)clearCache;
- (void)clearCacheWithCompletionBlock:(cleanObjectBlock)completion;

/**
 *  清理缓存文件，过期文件删除，超过目录限制删除
 */
- (void)cleanCache;
- (void)cleanCacheWithCompletionBlock:(cleanObjectBlock)completion;

@end
