//
//  ZAchiverCache.h
//  DataBaseTool
//
//  Created by ronglei on 15/5/25.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

//#import "ZBaseModel.h"
#import <Foundation/Foundation.h>
#import "ZDemoModel.h"

#define mAchiverCache [ZAchiverCache shareInstance]

@interface ZAchiverCache : NSObject

@property (nonatomic, strong) ZDemoModel *model;

+ (ZAchiverCache *)shareInstance;

- (void)saveAvhiverCache;
- (void)resetAchiverCache;
- (void)clearAchiverCache;

@end
