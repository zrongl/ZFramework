//
//  ZArchiveCache.h
//  DataBaseTool
//
//  Created by ronglei on 15/5/25.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

//#import "ZBaseModel.h"
#import <Foundation/Foundation.h>
#import "ZDemoModel.h"

#define mArchiveCache [ZArchiveCache shareInstance]

@interface ZArchiveCache : NSObject

@property (nonatomic, strong) ZDemoModel *model;

+ (ZArchiveCache *)shareInstance;

- (void)saveAvhiverCache;
- (void)resetArchiveCache;
- (void)clearArchiveCache;

@end
