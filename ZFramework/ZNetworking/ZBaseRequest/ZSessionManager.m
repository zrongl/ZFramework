//
//  ZSessionManager.m
//  ZFramework
//
//  Created by ronglei on 16/9/7.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZSessionManager.h"
#import "ZRequestUtil.h"

@interface ZSessionManager()

@property (strong, nonatomic) ZHTTPRequestSerializer<AFURLRequestSerialization>* requestSerializer;

@end

@implementation ZSessionManager

+ (instancetype)manager
{
    return [[self alloc] initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [ZHTTPRequestSerializer serializer];
    }
    
    return self;
}

- (void)setValue:(id)value forHTTPHeaderField:(NSString *)key
{
    [self.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET"
                                                                   URLString:URLString
                                                                  parameters:parameters
                                                                       error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                                 completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                     if (error) {
                                                         if (failure) {
                                                             failure(task, error);
                                                         }
                                                     } else {
                                                         if (success) {
                                                             success(task, responseObject);
                                                         }
                                                     }
                                                 }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST"
                                                                   URLString:URLString
                                                                  parameters:parameters
                                                                       error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                                 completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                     if (error) {
                                                         if (failure) {
                                                             failure(task, error);
                                                         }
                                                     } else {
                                                         if (success) {
                                                             success(task, responseObject);
                                                         }
                                                     }
                                                 }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POSTForm:(NSString *)URLString
                        parameters:(id)parameters
         constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                URLString:URLString
                                                                               parameters:parameters
                                                                constructingBodyWithBlock:block
                                                                                    error:nil];
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request
                                                                    progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                                        if (error) {
                                                                            if (failure) {
                                                                                failure(task, error);
                                                                            }
                                                                        } else {
                                                                            if (success) {
                                                                                success(task, responseObject);
                                                                            }
                                                                        }
                                                                    }];
    
    [task resume];
    
    return task;
}

@end
