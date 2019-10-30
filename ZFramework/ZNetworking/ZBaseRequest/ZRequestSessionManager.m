//
//  ZRequestSessionManager.m
//  ZFramework
//
//  Created by ronglei on 16/9/8.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZRequestSessionManager.h"
#import "ZHTTPRequestSerializer.h"

@interface ZRequestSessionManager()

@property (strong, nonatomic) ZHTTPRequestSerializer<AFURLRequestSerialization>* z_requestSeralizer;

@end

@implementation ZRequestSessionManager

+ (instancetype)manager
{
    return [[self alloc] initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        self.z_requestSeralizer = [ZHTTPRequestSerializer serializer];
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", nil]];
    }
    
    return self;
}

- (void)setValue:(id)value forHTTPHeaderField:(NSString *)key
{
    [self.z_requestSeralizer setValue:value forHTTPHeaderField:key];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.z_requestSeralizer requestWithMethod:@"GET"
                                                                   URLString:URLString
                                                                  parameters:parameters
                                                                        error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                                    uploadProgress:nil
                                                  downloadProgress:nil
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
    NSMutableURLRequest *request = [self.z_requestSeralizer requestWithMethod:@"POST"
                                                                   URLString:URLString
                                                                  parameters:parameters
                                                                       error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                                    uploadProgress:nil
                                                  downloadProgress:nil
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
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.z_requestSeralizer multipartFormRequestWithMethod:@"POST"
                                                                                 URLString:URLString
                                                                                parameters:parameters
                                                                 constructingBodyWithBlock:block
                                                                                     error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request
                                                                    progress:uploadProgress
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

- (nullable NSURLSessionDownloadTask *)DOWNLOAD:(NSString *)URLString
                                       progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                        success:(nullable void (^)(NSURLResponse *response, NSString *filePath))success
                                        failure:(nullable void (^)(NSURLResponse *response, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    __block NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request
                                                                  progress:downloadProgress
                                                               destination:destination
                                                         completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                             if (error) {
                                                                 if (failure) {
                                                                     failure(response, error);
                                                                 }
                                                             } else {
                                                                 if (success) {
                                                                     success(response, filePath.absoluteString);
                                                                 }
                                                             }
                                                         }];
    
    [task resume];
    
    return task;
}
@end
