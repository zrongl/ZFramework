//
//  LSBaseRequest.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/11.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ZToastView.h"
#import "ZGlobalData.h"
#import "ZBaseRequest.h"
#import <CommonCrypto/CommonDigest.h>

#import "ZRequestSessionManager.h"

#define kURLHost  @"http://127.0.0.1/"

#define kIndicatorViewSide  37.f
#define kLoaddingViewWidth  120.f

typedef void (^ RequestSuccessBlock)(ZBaseRequest *);
typedef void (^ RequestFailureBlock)(ZBaseRequest*, NSError *);
typedef void (^ RequestUploadProgressBlock)(long long bytes, long long totalBytes);

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

{
    NSString                *_URL;
    ZObjectCache            *_objectCache;
}

@property (copy, nonatomic) RequestSuccessBlock onRequestSuccessBlock;
@property (copy, nonatomic) RequestFailureBlock onRequestFailureBlock;

@end

@implementation ZBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCached   = NO;
        _URLHost    = kURLHost;
        _methodType = HttpMethodGet;
        _resultDic  = [[NSMutableDictionary alloc] init];
        _parameterDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)httpRequestSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                   failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailureBlock = onRequestFailureBlock;
    
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *URLString = [NSString stringWithFormat:@"%@%@", _URLHost, _URLAction];
    
    // 设置与服务器协商好的全局参数
    // [self appendStaticParameters];
    
    if (_methodType == HttpMethodGet) {
        ZRequestSessionManager *manager = [ZRequestSessionManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager setValue:@"MB-UZHSH-0001" forHTTPHeaderField:@"appId"];
        
        
        [manager GET:URLString
          parameters:_parameterDic
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 [self handleResponse:task.response];
                 [self handleResultObject:responseObject];
                 [self notifyRequestSuccess];
             }
             failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                 [self handleRequestFailure:error];
                 [ZToastView toastWithMessage:@"请求失败"];
             }];
        
    }else if (_methodType == HttpMethodPost){
        ZRequestSessionManager *manager = [ZRequestSessionManager manager];
        
        // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
        // [manager setValue:(id) forHTTPHeaderField:(NSString *)];
        
        [manager POST:URLString
           parameters:_parameterDic
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [self handleResponse:task.response];
                  [self handleResultObject:responseObject];
                  [self notifyRequestSuccess];
              }
              failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                  [self handleRequestFailure:error];
                  [ZToastView toastWithMessage:@"请求失败"];
              }];
    }
}

- (void)uploadRequestWithImage:(UIImage *)image
                     imageName:(NSString *)imageName
                uploadProgress:(void(^)(long long bytes, long long totalBytes))progressBlock
                       success:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                       failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock
{
    [self uploadRequestConstructingBody:^(id<AFMultipartFormData> formData) {
        // 图片压缩率
        float kCompressionQuality = 0.8f;
        NSData *data = UIImageJPEGRepresentation(image, kCompressionQuality);
//        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//        // 要解决此问题，
//        // 可以在上传时使用当前的系统事件作为文件名
//        //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        
        // 此方法参数
        // 1. 要上传的[二进制数据]
        // 2. 对应网站上[upload.php中]处理文件的[字段"file"]
        // 3. 要保存在服务器上的[文件名]
        // 4. 上传文件的[mimeType]
        
        [formData appendPartWithFileData:data name:@"img_file" fileName:imageName mimeType:@"image/jpeg"];
    }
                         uploadProgress:progressBlock
                                success:onRequestSuccessBlock
                                failure:onRequestFailureBlock];
}

- (void)uploadRequestConstructingBody:(void(^)(id <AFMultipartFormData> formData))onConstrctBlock
                       uploadProgress:(void(^)(long long bytes, long long totalBytes))progressBlock
                              success:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                              failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock
{
    _onRequestSuccessBlock = onRequestSuccessBlock;
    _onRequestFailureBlock = onRequestFailureBlock;
    
    // 如果设置了本地请求路径 则不请求远程服务器
    NSString *URLString = [NSString stringWithFormat:@"%@%@", _URLHost, _URLAction];
    
    // 设置与服务器协商好的全局参数
    // [self appendStaticParameters];
    
    
    ZRequestSessionManager *manager = [ZRequestSessionManager manager];
    
    // 此处可以调用setValue:forHTTPHeaderField:方法向httpheader添加额外信息
    // [manager setValue:@"MB-UZHSH-0001" forHTTPHeaderField:@"appId"];
    
    [manager POST:URLString
       parameters:_parameterDic constructingBodyWithBlock:onConstrctBlock
         progress:^(NSProgress * _Nonnull uploadProgress) {
             if (progressBlock) {
                 progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
             }
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
              [self handleResponse:task.response];
              [self handleResultObject:responseObject];
              [self notifyRequestSuccess];
          }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              [self handleRequestFailure:error];
          }];
}

- (void)downloadRequestWithUrl:(NSString *)url
                    saveToPath:(NSString *)saveToPath
              downloadProgress:(void(^)(long long bytes, long long totalBytes))progressBlock
                       success:(void(^)(NSURLResponse *response, NSString *filePath))onRequestSuccessBlock
                       failure:(void(^)(NSURLResponse *response, NSError * error))onRequestFailureBlock
{
    ZRequestSessionManager *manager = [ZRequestSessionManager manager];
    [manager DOWNLOAD:url
             progress:^(NSProgress * _Nonnull dowloadProgress) {
                 if (progressBlock) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         progressBlock(dowloadProgress.completedUnitCount, dowloadProgress.totalUnitCount);
                     });
                 }
             }
          destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
              if (!saveToPath) {
                  NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
                  return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
                  
              }else{
                  return [NSURL fileURLWithPath:saveToPath];
              }
          }
              success:onRequestSuccessBlock
              failure:onRequestFailureBlock];
}


#pragma mark - global parameter
/**
 * 全局参数设置 将与服务器协定的全局参数添加到请求参数中
 * name: username
 * timestamp:时间戳
 * sign: username+md5(password)+md5(timestamp+"test")
 */
- (void)appendStaticParameters
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
- (void)handleResponse:(id)response
{
    NSHTTPURLResponse *URLResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", URLResponse.allHeaderFields);
}

- (void)handleResultObject:(id)responceObject
{
    if(![responceObject isKindOfClass:[NSDictionary class]]){
        NSLog(@"\n---------------------json格式错误解析失败--------------------\n");
        responceObject = nil;
    }else{
        if (_isCached) {
            NSString *urlKey = [NSString stringWithFormat:@"%@%@", _URLHost, _URLAction];
            [[ZObjectCache sharedFileCache] storeObject:responceObject forKey:urlKey];
            NSLog(@"%@", [[ZObjectCache sharedFileCache] objectFromDiskCacheForKey:urlKey]);
        }
        _resultDic = responceObject;
    }
    [self preprocessResult];
}

- (void)handleRequestFailure:(NSError *)error
{
    if (_isCached) {
        NSString *urlKey = [NSString stringWithFormat:@"%@%@", _URLHost, _URLAction];
        _resultDic = [[ZObjectCache sharedFileCache] objectFromDiskCacheForKey:urlKey];
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
    if (_onRequestFailureBlock) {
        _onRequestFailureBlock(self, error);
    }
}

#pragma mark - virtual function
- (void)preprocessResult
{
    
}

@end
