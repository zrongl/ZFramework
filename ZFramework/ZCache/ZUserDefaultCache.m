//
//  ZUserDefaultCache.m
//  DeepIntoCache
//
//  Created by ronglei on 15/8/13.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZUserDefaultCache.h"

#define kUserName           @"kUserName"
#define kUserID             @"kUserID"

@implementation ZUserDefaultCache

+ (ZUserDefaultCache *)sharedInstance
{
    static ZUserDefaultCache *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 *  适用于存储Foundation提供的系统类如NSString,NSArray,NSDictionary等
 *  不适用于存储自定义类对象
 *
 *  添加全局数据过程: 向单例对象添加属性、该属性对应的唯一的key值及其setter方法
 */
- (id)init
{
    self = [super init];
    if (self) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    }
    
    return self;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
