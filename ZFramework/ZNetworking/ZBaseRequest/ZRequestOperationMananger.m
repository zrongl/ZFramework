//
//  ZRequestOperationMananger.m
//  ZFramework
//
//  Created by ronglei on 16/9/8.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZRequestOperationMananger.h"
#import "ZHTTPRequestSerializer.h"

@interface ZRequestOperationMananger()

@property (strong, nonatomic) ZHTTPRequestSerializer<AFURLRequestSerialization>* z_requestSeralizer;

@end

@implementation ZRequestOperationMananger

+ (instancetype)manager
{
    static dispatch_once_t oncePredicate;
    static ZRequestOperationMananger* manager;
    dispatch_once(&oncePredicate, ^{
        manager = [[ZRequestOperationMananger alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.z_requestSeralizer = [ZHTTPRequestSerializer serializer];
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", nil]];
    }
    
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.z_requestSeralizer requestWithMethod:@"GET"
                                                            URLString:URLString
                                                           parameters:parameters
                                                                error:nil];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:success
                                                                      failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 设置URLRequest的URL,method,httpHeader,httpBody
    NSMutableURLRequest *request = [self.z_requestSeralizer requestWithMethod:@"POST"
                                                            URLString:URLString
                                                                  parameters:parameters
                                                                error:nil];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:success
                                                                      failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POSTFrom:(NSString *)URLString
                          parameters:(id)parameters
           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.z_requestSeralizer multipartFormRequestWithMethod:@"POST"
                                                                         URLString:URLString
                                                                        parameters:parameters
                                                         constructingBodyWithBlock:block
                                                                             error:nil];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:success
                                                                      failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

@end
