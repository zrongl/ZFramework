//
//  ZAchiverObjectCache.m
//  DeepIntoCache
//
//  Created by ronglei on 15/10/20.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZAchiverObjectCache.h"
#import <CommonCrypto/CommonDigest.h>

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week
#define kFileCacheDirectory     @"Caches/LaShouCache"

typedef void (^obtainObjectBlock)(id object, ZObjectCacheType type);

@interface ZAchiverObjectCache()

{
    dispatch_queue_t    _ioQueue;
    NSCache             *_memoryCache;
    NSString            *_cachePath;
}

- (void)backgroundClean;
- (void)clearMemoryCache;
- (id)objectFromDiskCacheForKey:(NSString *)key;
- (id)objectFromMemoryCacheForKey:(NSString *)key;
- (NSOperation *)objectFromCacheForKey:(NSString *)key completion:(obtainObjectBlock)completion;

@end

@implementation ZAchiverObjectCache
{
    NSFileManager *_fileManager;
}

+ (ZAchiverObjectCache *)sharedFileCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)initWithFileExtension:(NSString *)extension
{
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.zrongl.ZObjectCache." stringByAppendingString:extension];
        
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.zrongl.ZObjectCache", DISPATCH_QUEUE_SERIAL);
        
        // Init default values
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        
        // Init the memory cache
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = fullNamespace;
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
        
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        
#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanCache)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundClean)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
    }
    
    return self;
}

- (void)storeObject:(id)object forKey:(NSString *)key
{
    [self storeObject:object forKey:key toDisk:YES];
}

- (void)storeObject:(id)object forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!object || !key) {
        return;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [_memoryCache setObject:object forKey:key cost:data.length];
    if (toDisk) {
        dispatch_async(_ioQueue, ^{
            [NSKeyedArchiver archiveRootObject:object toFile:[self defaultCachePathForKey:key]]; 
        });
    }
}

- (BOOL)objectExistsWithKey:(NSString *)key
{
    BOOL exists = NO;
    // this is an exception to access the filemanager on another queue than ioQueue, but we are using the shared instance
    // from apple docs on NSFileManager: The methods of the shared NSFileManager object can be called from multiple threads safely.
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
    
    return exists;
}

- (void)objectExistsWithKey:(NSString *)key completion:(checkCacheBlock)completion
{
    dispatch_async(_ioQueue, ^{
        BOOL exists = [_fileManager fileExistsAtPath:[self defaultCachePathForKey:key]];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(exists);
            });
        }
    });
}

- (id)objectFromMemoryCacheForKey:(NSString *)key
{
    return [_memoryCache objectForKey:key];
}

- (id)objectFromDiskCacheForKey:(NSString *)key
{
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self defaultCachePathForKey:key]];
    if (object) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        [_memoryCache setObject:object forKey:key cost:data.length];
    }
    
    return object;
}

- (id)objectFromCacheForKey:(NSString *)key
{
    id object = [self objectFromMemoryCacheForKey:key];
    if (object) {
        return object;
    }
    
    object = [self objectFromDiskCacheForKey:key];
    if (object) {
        return object;
    }
    
    return nil;
}

- (NSOperation *)objectFromCacheForKey:(NSString *)key completion:(obtainObjectBlock)completion
{
    if (!completion) {
        return nil;
    }
    
    if (!key) {
        completion(nil, ZObjectCacheTypeNone);
        return nil;
    }
    
    // First check the in-memory cache...
    // 首先检测内存缓存
    id object = [self objectFromMemoryCacheForKey:key];
    if (object) {
        completion(object, ZObjectCacheTypeMemory);
        return nil;
    }
    
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        // 设置一个operation
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            // 检测硬盘是否存储了图片
            id object = [self objectFromDiskCacheForKey:key];
            if (object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(object, ZObjectCacheTypeDisk);
                });
            }
        }
    });
    
    return operation;
}

- (void)removeObjectForKey:(NSString *)key
{
    [self removeObjectForKey:key fromDisk:YES completion:nil];
}

- (void)removeObjectForKey:(NSString *)key completion:(removeObjectBlock)completion
{
    [self removeObjectForKey:key fromDisk:YES completion:completion];
}

- (void)removeObjectForKey:(NSString *)key fromDisk:(BOOL)fromDisk completion:(removeObjectBlock)completion
{
    if (!key) {
        return;
    }
    
    if (fromDisk) {
        dispatch_async(_ioQueue, ^{
            [_fileManager removeItemAtPath:[self defaultCachePathForKey:key] error:nil];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        });
    }else if (completion){
        completion();
    }
}

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost
{
    _memoryCache.totalCostLimit = maxMemoryCost;
}

- (NSUInteger)maxMemoryCost
{
    return _memoryCache.totalCostLimit;
}

- (void)clearMemoryCache
{
    [_memoryCache removeAllObjects];
}

- (void)clearCache
{
    [self clearCacheWithCompletionBlock:nil];
}

- (void)clearCacheWithCompletionBlock:(cleanObjectBlock)completion
{
    dispatch_async(_ioQueue, ^{
        [_fileManager removeItemAtPath:_cachePath error:nil];
        [_fileManager createDirectoryAtPath:_cachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)cleanCache
{
    [self cleanCacheWithCompletionBlock:nil];
}

- (void)cleanCacheWithCompletionBlock:(cleanObjectBlock)completion
{
    dispatch_async(_ioQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:_cachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)backgroundClean
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    [self cleanCacheWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (NSUInteger)calculateSize
{
    __block NSUInteger size = 0;
    dispatch_sync(_ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_cachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)calculateFileCount
{
    __block NSUInteger count = 0;
    dispatch_sync(_ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_cachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}

- (void)calculateSizeWithCompletionBlock:(calculateSizeBlock)completion;
{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:_cachePath isDirectory:YES];
    
    dispatch_async(_ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(fileCount, totalSize);
            });
        }
    });
}

#pragma mark - private method
- (NSString *)cachedFileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path
{
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key
{
    return [self cachePathForKey:key inPath:_cachePath];
}

@end
