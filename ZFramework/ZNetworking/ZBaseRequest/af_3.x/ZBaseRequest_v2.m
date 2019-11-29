//
//  ZBaseRequest_v2.m
//  ZFramework
//
//  Created by ronglei on 2018/3/13.
//  Copyright © 2018年 ronglei. All rights reserved.
//

#import "ZBaseRequest_v2.h"

#import "ZToastView.h"
#import "ZGlobalData.h"
#import "ZAchiverObjectCache.h"

#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

#define kURLHost  @"http://meiye.test.lashou.com/index.php"

#define kIndicatorViewSide  37.f
#define kLoaddingViewWidth  120.f

typedef void (^ ResultSuccessBlock)(NSDictionary *);
typedef void (^ RequestSuccessBlock)(ZBaseRequest_v2 *);
typedef void (^ RequestFailedBlock)(ZBaseRequest_v2*, NSError *);
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

@interface ZBaseRequest_v2()
{
    NSString                *_localUrl;;
    NSURLSessionDataTask    *_task;
}

@property (copy, nonatomic) RequestFailedBlock onRequestFailedBlock;
@property (copy, nonatomic) ResultSuccessBlock onResultSuccessBlock;
@property (copy, nonatomic) RequestSuccessBlock onRequestSuccessBlock;

@end

@implementation ZBaseRequest_v2

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCached   = NO;
        _urlHost    = kURLHost;
        _methodType = HttpMethodGet;
        _resultDic  = [[NSMutableDictionary alloc] init];
        _parameterDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NSDictionary *)localDataFromPath:(NSString *)path;
{
    NSError *error = nil;
    NSMutableDictionary *resultDic = nil;
    
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if(![resultDic isKindOfClass:[NSDictionary class]] || error != nil){
            NSLog(@"\n---------------------json格式错误解析失败--------------------\n");
            resultDic = nil;
        }
    }else{
        NSLog(@"%@", error);
    }
    
    return resultDic;
}

/**
 *  普通GET/POST请求
 *
 *  @param onRequestSuccessBlock 成功block
 *  @param onRequestFailedBlock  失败block
 */
- (void)requestonSuccess:(void(^)(ZBaseRequest_v2 *request))onRequestSuccessBlock
                onFailed:(void(^)(ZBaseRequest_v2 *request, NSError *error))onRequestFailedBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailedBlock = onRequestFailedBlock;
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *urlString = nil;
    _localUrl = [self localServerURL];
    if (_localUrl == nil) {
        urlString = [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
    }else{
        urlString = _localUrl;
    }
    
    // 设置与服务器协商好的全局参数
    // [self appendGlobalParameters];
    
    if (_methodType == HttpMethodGet) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
        
        _task = [manager GET:urlString
              parameters:_parameterDic
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleResultObject:responseObject];
                    [self notifyRequestSuccess];
                }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestFailureWithError:error];
                }];
    }else if (_methodType == HttpMethodPost){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
        
        _task = [manager POST:urlString
                   parameters:_parameterDic
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self handleResultObject:responseObject];
                        [self notifyRequestSuccess];
                    }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [ZToastView toastMessage:@"请求失败"];
            
                    }];
    }
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
            if (_isCached) {
                NSString *urlKey = _localUrl ? _localUrl : [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
                [[ZAchiverObjectCache sharedFileCache] storeObject:resultDic forKey:urlKey];
                NSLog(@"%@", [[ZAchiverObjectCache sharedFileCache] objectFromDiskCacheForKey:urlKey]);
            }
            _resultDic = resultDic;
        }
        [self preprocessResult];
    }
}

- (void)handleRequestFailureWithError:(NSError *)error
{
    if (_isCached) {
        NSString *urlKey = _localUrl ? _localUrl : [NSString stringWithFormat:@"%@%@", _urlHost, _urlAction];
        _resultDic = [[ZAchiverObjectCache sharedFileCache] objectFromDiskCacheForKey:urlKey];
        [self preprocessResult];
        [self notifyRequestSuccess];
    }else{
        [self notifyRequestFailed:error];
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

#pragma mark - virtual function
- (void)preprocessResult
{
    
}

- (NSString *)localServerURL
{
    return nil;
}
@end
