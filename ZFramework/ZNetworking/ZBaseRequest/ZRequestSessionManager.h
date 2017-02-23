//
//  ZRequestSessionManager.h
//  ZFramework
//
//  Created by ronglei on 16/9/8.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRequestSessionManager : AFHTTPSessionManager

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

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)DOWNLOAD:(NSString *)URLString
                                   progress:(nullable nullable void (^)(NSProgress * _Nonnull))dowloadProgress
                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    success:(nullable void (^)(NSURLResponse *response, NSString *filePath))success
                                    failure:(nullable void (^)(NSURLResponse *response, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

