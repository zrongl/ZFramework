//
//  ZAchiverCache.m
//  DataBaseTools
//
//  Created by ronglei on 15/5/25.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZAchiverCache.h"

#define kCacheFileName        @"com.lashou.cache.file"
#define kCacheDirectory       @"Caches/LaShouCache"

static ZAchiverCache *shareInstance = nil;

static NSString *AchiverCacheFilerPath()
{
    NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:nil]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return [dirPath stringByAppendingPathComponent:kCacheFileName];
}

@implementation ZAchiverCache

+ (ZAchiverCache *)shareInstance
{
    if (shareInstance == nil) {
        shareInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:AchiverCacheFilerPath()];
        if (shareInstance == nil) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                shareInstance = [[ZAchiverCache alloc] init];
            });
        }
    }
    
    return shareInstance;
}
/**
 *  程序第一次安装启动，unarchive文件时返回nil，此时会调用init来初始化单例shareInstance
 *  程序运行后，将单例shareInstance archive进指定文件，程序完全退出
 *  程序再次启动，unarchive文件时返回上次运行存储的对象，则不会调用init进行初始化
 *  可以添加自定义类，需要在init方法中进行初始化
 */
- (id)init
{
    self = [super init];
    if (self) {
        self.userName = nil;
        self.userID = nil;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.userID = [aDecoder decodeObjectForKey:@"userId"];
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    
    return self;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [NSKeyedArchiver archiveRootObject:shareInstance toFile:AchiverCacheFilerPath()];
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [NSKeyedArchiver archiveRootObject:shareInstance toFile:AchiverCacheFilerPath()];
}

@end
