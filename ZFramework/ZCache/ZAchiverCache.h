//
//  ZAchiverCache.h
//  DataBaseTool
//
//  Created by ronglei on 15/5/25.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAchiverCache : NSObject <NSCoding>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userID;

+ (ZAchiverCache *)shareInstance;

@end
