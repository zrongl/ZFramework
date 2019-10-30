//
//  HSGlobal.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGlobalData : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *shopName;
@property (strong, nonatomic) NSString *userRole;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *timeStamp;
@property (strong, nonatomic) NSString *sign;
@property (assign, nonatomic) BOOL autoLogin;

+ (ZGlobalData*)sharedGlobal;
- (BOOL)isLogoin;

@end
