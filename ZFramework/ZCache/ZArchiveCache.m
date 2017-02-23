//
//  ZArchiveCache.m
//  DataBaseTools
//
//  Created by ronglei on 15/5/25.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZArchiveCache.h"
#import "ZArchivingMacro.h"

#define kCacheFileName        @"com.lashou.cache.file"
#define kCacheDirectory       @"Caches/LaShouCache"

static ZArchiveCache *shareInstance = nil;

static NSString *ArchiveCacheFilerPath()
{
    NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:nil]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return [dirPath stringByAppendingPathComponent:kCacheFileName];
}

static void clearArchiveCache()
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:ArchiveCacheFilerPath()]) {
        [manager removeItemAtPath:ArchiveCacheFilerPath() error:nil];
    }
}

@implementation ZArchiveCache

ZSERIALIZE_CODER_DECODER() // NSCoding

+ (ZArchiveCache *)shareInstance
{
    if (shareInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareInstance = [[ZArchiveCache alloc] init];
        });
    }
    
    return shareInstance;
}
/**
 *  程序第一次安装启动，unarchive文件时返回nil，此时会调用init来初始化单例shareInstance
 *  程序运行后，将单例shareInstance archive进指定文件，程序完全退出
 *  程序再次启动，unarchive文件时返回上次运行存储的对象，则不会调用init进行初始化
 *  可以添加自定义类，需要在init方法中进行初始化
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[ZDemoModel alloc] init];
    }
    
    return self;
}

- (void)resetArchiveCache
{
    ZArchiveCache *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:ArchiveCacheFilerPath()];
    if (!cache) return;
    mArchiveCache.model = cache.model;
}

- (void)saveAvhiverCache
{
    [NSKeyedArchiver archiveRootObject:mArchiveCache toFile:ArchiveCacheFilerPath()];
}

- (void)clearArchiveCache
{
    clearArchiveCache();
    mArchiveCache.model = nil;
}

@end
