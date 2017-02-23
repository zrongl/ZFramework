//
//  ZSqliteDB.h
//  C
//
//  Created by ronglei on 16/9/20.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBModel : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int modTime;
@property (nonatomic, assign) int accessTime;

@end

@interface ZSqliteDB : NSObject

- (void)dbClose;
- (id)dbQueryWithKey:(NSString *)key;
- (NSArray *)dbQueryWithKeys:(NSArray *)keys;
- (void)dbSaveKey:(NSString *)key value:(NSData *)value;

@end
