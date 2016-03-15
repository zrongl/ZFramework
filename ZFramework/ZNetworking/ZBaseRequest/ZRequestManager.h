//
//  LSHttpRequestManager.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

typedef NS_ENUM(NSInteger, AFParameterEncoding) {
    AFFormURLParameterEncoding,
    AFJSONParameterEncoding,
    AFPropertyListParameterEncoding,
    AFJSONDesParameterEncoding,
} ;

@class AFHTTPRequestOperation;
@protocol AFMultipartFormData;

@interface ZRequestManager : NSObject

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

/**
 *  不声明为单例的原因:
 *  向实例的operationQueue中添加questOperation执行请求或直接调用questOperation的start方法执行请求 两种方式哪种更优？
 * 
 *  可以调用实例方法setValue:forHTTPHeaderField:设置HTTPHeader
 *  HTTPHeader包括: 
 *  公共的: User-Agent Content-Type Content-Length Accept-Language Accept-Encoding
 *  也可以与服务端协定: 如ThinkID等等
 *
 *  通过 GET/POST 返回的AFHTTPRequestOperation实例，可以调用实例cancel方法取消请求的operation
 *
 *  @return 返回LSHttpRequestManager实例
 */
+ (instancetype)manager;
+ (void)cancelAllRequest;
/**
 *  添加http header信息
 */
- (void)setValue:(id)value forHTTPHeaderField:(NSString *)key;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)UPLOAD:(NSString *)URLString
                        parameters:(id)parameters
                  constructingBody:(void (^) (id <AFMultipartFormData> formData))constructBlock
                     uploadProcess:(void (^) (NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;
- (AFHTTPRequestOperation *)DOWNLOAD:(NSString *)URLString
                          parameters:(id)parameters
                            filePath:(NSString *)filePath
                     downloadProcess:(void (^) (NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 多个请求执行完成后，执行completionBlock中的内容
- (void)batchOfRequestOperations:(NSArray *)operations
                   progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                 completionBlock:(void (^)(NSArray *operations))completionBlock;
@end
