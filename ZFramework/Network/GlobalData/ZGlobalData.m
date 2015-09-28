//
//  HSGlobal.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZGlobalData.h"

#define kUserName           @"kUserName"
#define kUserId             @"kUserId"
#define kUserRole           @"kUserRole"
#define kShopName           @"kShopName"
#define kAutoLogin          @"kAutoLogin"
#define kPassword           @"kPassword"
#define kTimeStamp          @"kTimeStamp"
#define kSign               @"kSign"

@implementation ZGlobalData

+ (ZGlobalData *)sharedGlobal
{
    static ZGlobalData *sharedGlobalInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobalInstance = [[self alloc] init];
    });
    return sharedGlobalInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        _userRole = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRole];
        _shopName = [[NSUserDefaults standardUserDefaults] objectForKey:kShopName];
        _autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kAutoLogin];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        _timeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeStamp];
        _sign = [[NSUserDefaults standardUserDefaults] objectForKey:kSign];
    }
    
    return self;
}

- (BOOL)isLogoin
{
    if (_userName != nil && _userName.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserRole:(NSString *)userRole
{
    _userRole = userRole;
    [[NSUserDefaults standardUserDefaults] setObject:userRole forKey:kUserRole];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setShopName:(NSString *)shopName
{
    _shopName = shopName;
    [[NSUserDefaults standardUserDefaults] setObject:shopName forKey:kShopName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setautoLogin:(BOOL)autoLogin
{
    _autoLogin = autoLogin;
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:kAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTimeStamp:(NSString *)timeStamp
{
    _timeStamp = timeStamp;
    [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:kTimeStamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSign:(NSString *)sign
{
    _sign = sign;
    [[NSUserDefaults standardUserDefaults] setObject:sign forKey:kSign];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
