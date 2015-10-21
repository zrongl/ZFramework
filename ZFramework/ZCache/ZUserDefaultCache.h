//
//  ZUserDefaultCache.h
//  DeepIntoCache
//
//  Created by ronglei on 15/8/13.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUserDefaultCache : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userID;

+ (ZUserDefaultCache *)sharedInstance;

@end
