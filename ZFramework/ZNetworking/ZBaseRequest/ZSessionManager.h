//
//  ZSessionManager.h
//  ZFramework
//
//  Created by ronglei on 16/9/7.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "AFURLSessionManager.h"
#import "ZHTTPRequestSerializer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSessionManager : AFURLSessionManager

+ (instancetype)manager;
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;
/**
 *  添加http header信息;add info to http header
 */
- (void)setValue:(id)value forHTTPHeaderField:(NSString *)key;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
                       success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POSTForm:(NSString *)URLString
                                 parameters:(nullable id)parameters
                  constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end

NS_ASSUME_NONNULL_END