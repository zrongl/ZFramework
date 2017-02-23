//
//  ZSqliteDB.m
//  C
//
//  Created by ronglei on 16/9/20.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZSqliteDB.h"
#import <sqlite3.h>

static NSString *_dbName = @"dbCache.sqlite";

@implementation DBModel

@end

@implementation ZSqliteDB{
    sqlite3 *_db;
    NSString *_cachePath;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![self dbOpen] || ![self dbInitialize]) {
            [self dbClose];
            return nil;
        }
    }
    return self;
}

- (int)dbInitialize
{
    NSString *sql = @"pragma journal_mode = wal;\
                    pragma synchronous = normal;\
                    create table if not exists dbtable (key text, size integer, inline_data blob, modification_time integer, last_access_time integer, extended_data blob, primary key(key));\
                    create index if not exists last_access_time_idx on dbtable(last_access_time);";
    
    char *error = NULL;
    int rc = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    if (error) {
        sqlite3_free(error);
    }
    
    return rc == SQLITE_OK;
}

- (int)dbOpen
{
    sqlite3_initialize();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    _cachePath = [paths[0] stringByAppendingPathComponent:_dbName];
    int rc = sqlite3_open_v2(_cachePath.UTF8String, &_db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL);
    return rc == SQLITE_OK;
}

- (void)dbClose
{
    sqlite3_close(_db);
    sqlite3_shutdown();
}

- (NSArray *)dbQueryWithKeys:(NSArray *)keys
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from dbtable where key = ?1;";
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    
    for (NSString *key in keys) {
        sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
        
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            DBModel *model = [DBModel new];
            model.key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            model.size = sqlite3_column_int(stmt, 1);
            model.data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:model.size];
            model.modTime = sqlite3_column_int(stmt, 3);
            model.accessTime = sqlite3_column_int(stmt, 4);
            [models addObject:model];
        }
        
        sqlite3_reset(stmt);
        sqlite3_clear_bindings(stmt);
    }
    
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    return models;
}

- (id)dbQueryWithKey:(NSString *)key
{
    DBModel *model = [DBModel new];
    
    NSString *sql = @"select * from dbtable where key = ?1;";
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        model.key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        model.size = sqlite3_column_int(stmt, 1);
        model.data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:model.size];
        model.modTime = sqlite3_column_int(stmt, 3);
        model.accessTime = sqlite3_column_int(stmt, 4);
    }
    
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    return model;
}

//{
//    // 分配资源，初始化一些必要的数据结构
//    sqlite3_initialize();
//    sqlite3 *db = NULL;
//    // 以指定方式打开path路径下的数据库文件，并返回数据库指针
//    sqlite3_open_v2(path, &db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL);
//    
//    NSString *sql = @"select * from dbtable where key = ?1;";
//    NSArray *keys = @[@"1", @"2", @"3"];
//    sqlite3_stmt *stmt = NULL;
//    // 将一个SQL命令字符串转换成能在VDBE中运行的一系列操作码，存储在sqlite3_stmt类型结构体中
//    sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
//    
//    for (NSString *key in keys) {
//        // 绑定SQL中指定位置的参数
//        // sql语句变为"select * from dbtable where key = key.UTF8String;"
//        sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
//        // 每次调用都会返回结果集中的其中一行(返回SQLITE_ROW)，直到再没有有效数据行了(返回SQLITE_OK)
//        while (SQLITE_ROW == sqlite3_step(stmt)) {
//            // 获取执行结果的列数
//            int col_count = sqlite3_column_count(stmt);
//            // 逐列的获取数据
//            while(col_count-- >= 0){
//                // 根据类型使用对应的"sqlite3_column_xxx"函数取值
//                int col_data = sqlite3_column_int(stmt, col_count);
//            }
//        }
//        // 重置stmt结构的状态，尽量对stmt进行复用，提高性能
//        sqlite3_reset(stmt);
//        // 清楚绑定参数信息，方便再次进行参数绑定
//        sqlite3_clear_bindings(stmt);
//    }
//    // 释放申请的stmt结构的内存
//    sqlite3_finalize(stmt);
//    stmt = NULL;
//    
//    // 关闭数据库连接，释放数据结构所关联的内存，删除所有的临时数据项
//    // 如果遇到返回SQLITE_BUSY或SQLITE_LOCKED的情况，需要执行完所有的stmt后再关闭，参见fmdb
//    sqlite3_close(_db);
//    // 释放由sqlite3_initialize分配的资源
//    sqlite3_shutdown();
//}

- (void)dbSaveKey:(NSString *)key value:(NSData *)value
{
    NSString *sql = @"insert or replace into dbtable (key, size, inline_data, modification_time, last_access_time, extended_data) values (?1, ?2, ?3, ?4, ?5, ?6);";
    
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    
    int timestamp = (int)time(NULL);
    sqlite3_bind_text(stmt, 0, key.UTF8String, -1, NULL);
    sqlite3_bind_int (stmt, 1, (int)value.length);
    sqlite3_bind_blob(stmt, 2, value.bytes, (int)value.length, 0);
    sqlite3_bind_int (stmt, 3, timestamp);
    sqlite3_bind_int (stmt, 4, timestamp);
    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
    }
    
    sqlite3_finalize(stmt);
    stmt = NULL;
}

@end
