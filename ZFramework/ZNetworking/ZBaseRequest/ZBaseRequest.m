//
//  LSBaseRequest.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/11.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZGlobalData.h"
#import "ZBaseRequest.h"
#import "ZRequestManager.h"
#import "AFHTTPRequestOperation.h"
#import <CommonCrypto/CommonDigest.h>

#define kURLHost  @"http://sp.api.lashou.com/Api/Ios"

typedef void (^ RequestSuccessBlock)(ZBaseRequest *);
typedef void (^ RequestFailedBlock)(ZBaseRequest*, NSError *);
typedef void (^ RequestProgressBlock)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);

static NSString *md5(NSString *stirng)
{
    // Code adapted from
    // http://amcmillan.livejournal.com/155200.html
    const char *cStr = [stirng UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@interface ZBaseRequest()

@property (strong, nonatomic) NSString *localUrl;
@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;

@property (copy, nonatomic) RequestFailedBlock onRequestFailedBlock;
@property (copy, nonatomic) RequestSuccessBlock onRequestSuccessBlock;

@end

@implementation ZBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlHost = kURLHost;
        _methodType = HttpMethodGet;
        _resultDic = [[NSMutableDictionary alloc] init];
        _parameterDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)requestonSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                onFailed:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailedBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailedBlock = onRequestFailedBlock;
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *URLString = nil;
    _localUrl = [self localServerURL];
    if (_localUrl == nil) {
        URLString = [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
    }else{
        URLString = _localUrl;
    }
    
    // 设置与服务器协商好的全局参数
    // [self appendGlobalParameters];
    
    if (_methodType == HttpMethodGet) {
        ZRequestManager *manager = [ZRequestManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager setValue:(id) forHTTPHeaderField:(NSString *)];
        
        _requestOperation = [manager GET:URLString
                              parameters:_parameterDic
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [self handleHttpHeaderField:operation.response.allHeaderFields];
                                     [self handleResultObject:responseObject];
                                     [self notifyRequestSuccess];
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [self notifyRequestFailed:error];
                                 }];
    }else if (_methodType == HttpMethodPost){
        ZRequestManager *manager = [ZRequestManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager setValue:(id) forKey:(NSString *)];
        
        _requestOperation = [manager POST:URLString
                               parameters:_parameterDic
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self handleHttpHeaderField:operation.response.allHeaderFields];
                                      [self handleResultObject:responseObject];
                                      [self notifyRequestSuccess];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self notifyRequestFailed:error];
                                  }];
    }
}

- (void)uploadRequestOnConstructingBody:(void(^)(id <AFMultipartFormData> formData))onConstrctBlock
                        onUploadProcess:(void(^)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                              onSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                               onFailed:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailedBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailedBlock = onRequestFailedBlock;
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *URLString = nil;
    _localUrl = [self localServerURL];
    if (_localUrl == nil) {
        URLString = [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
    }else{
        URLString = _localUrl;
    }
    
    // 设置与服务器协商好的全局参数
    // [self appendGlobalParameters];
    
    ZRequestManager *manager = [ZRequestManager manager];
    _requestOperation = [manager UPLOAD:URLString
                             parameters:_parameterDic
                       constructingBody:^(id<AFMultipartFormData> formData) {
                           onConstrctBlock(formData);
                       }
                          uploadProcess:^(NSUInteger bytes, long long totalBytes, long long totalBytesExpected) {
                              processBlock(bytes, totalBytes,totalBytesExpected);
                          }
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [self handleHttpHeaderField:operation.response.allHeaderFields];
                                    [self handleResultObject:responseObject];
                                    [self notifyRequestSuccess];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [self notifyRequestFailed:error];
                                }];
}

- (void)downloadRequestWithFilePath:(NSString *)filePath
                  onDownloadProcess:(void(^)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                          onSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                           onFailed:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailedBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailedBlock = onRequestFailedBlock;
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *URLString = nil;
    _localUrl = [self localServerURL];
    if (_localUrl == nil) {
        URLString = [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
    }else{
        URLString = _localUrl;
    }
    
    // 设置与服务器协商好的全局参数
    // [self appendGlobalParameters];
    
    ZRequestManager *manager = [ZRequestManager manager];
    _requestOperation = [manager DOWNLOAD:URLString
                               parameters:_parameterDic
                                 filePath:filePath
                          downloadProcess:^(NSUInteger bytes, long long totalBytes, long long totalBytesExpected) {
                              processBlock(bytes, totalBytes, totalBytesExpected);
                          }
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self handleHttpHeaderField:operation.response.allHeaderFields];
                                      [self handleResultObject:responseObject];
                                      [self notifyRequestSuccess];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self notifyRequestFailed:error];
                                  }];
}

#pragma mark - global parameter
/**
 * 全局参数设置 将与服务器协定的全局参数添加到请求参数中
 * name: username
 * timestamp:时间戳
 * sign: username+md5(password)+md5(timestamp+"test")
 */
- (void)appendGlobalParameters
{
    [_parameterDic setValue:[self generateSign] forKey:@"sign"];
    [_parameterDic setValue:[ZGlobalData sharedGlobal].userName forKey:@"name"];
    [_parameterDic setValue:[self generateTimeStamp] forKey:@"timestamp"];
}

- (NSString *)generateSign
{
    NSString *pwd_md5 = md5([ZGlobalData sharedGlobal].password);
    NSString *time_key_md5 = md5([NSString stringWithFormat:@"%@%@",[self generateTimeStamp],@"test"]);
    NSString *sign = md5([NSString stringWithFormat:@"%@%@%@",[ZGlobalData sharedGlobal].userName, pwd_md5,time_key_md5]);
    [ZGlobalData sharedGlobal].sign = sign;
    
    return sign;
}

- (NSString *)generateTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    [ZGlobalData sharedGlobal].timeStamp = timeString;
    
    return timeString;
}

#pragma mark - request back handle
/**
 *  请求返回 将json转换为dictionary 存储到resultDic
 */
- (void)handleHttpHeaderField:(NSDictionary *)headerField
{

}

- (void)handleResultObject:(id)responceObject
{
    NSData *jsonData = responceObject;
    NSMutableDictionary* resultDic = nil;
    if (jsonData) {
        NSError *error = nil;
        if (responceObject && [responceObject isKindOfClass:[NSData class]]){
            resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        }
        if(![resultDic isKindOfClass:[NSDictionary class]] || error != nil){
            NSLog(@"\n---------------------json格式错误解析失败--------------------\n");
            resultDic = nil;
        }else{
            _resultDic = resultDic;
        }
        [self preprocessResult];
    }
}

- (void)notifyRequestSuccess
{
    if (_onRequestSuccessBlock) {
        _onRequestSuccessBlock(self);
    }
}

- (void)notifyRequestFailed:(NSError *)error
{
    if (_onRequestFailedBlock) {
        _onRequestFailedBlock(self, error);
    }
}

- (void)cancelRequest
{
    [_requestOperation cancel];
}

#pragma mark - virtual function
- (void)preprocessResult
{
    
}

- (NSString *)localServerURL
{
    return nil;
}
@end
