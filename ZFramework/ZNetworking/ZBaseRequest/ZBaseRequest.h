//
//  LSBaseRequest.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/11.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZObjectCache.h"

typedef NS_ENUM(NSInteger, HttpMethodType){
    HttpMethodGet,
    HttpMethodPost
};

@protocol AFMultipartFormData;

@interface ZBaseRequest : NSObject

@property (assign, nonatomic) BOOL isCached;

@property (strong, nonatomic) NSString *URLHost;                // 请求基地址
@property (strong, nonatomic) NSString *URLAction;              // 请求行为
@property (assign, nonatomic) HttpMethodType methodType;        // 请求方式 POST或GET
@property (strong, nonatomic) NSMutableDictionary *resultDic;   // 请求返回json转换为dictionary
@property (strong, nonatomic) NSMutableDictionary *parameterDic;// 请求参数

/**
 *  普通GET/POST请求
 *
 *  @param onRequestSuccessBlock 成功block
 *  @param onRequestFailedBlock  失败block
 */
- (void)httpRequestSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                   failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock;

- (void)uploadRequestWithImage:(UIImage *)image
                     imageName:(NSString *)imageName
                uploadProgress:(void(^)(long long bytes, long long totalBytes))progressBlock
                       success:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                       failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock;

- (void)downloadRequestWithUrl:(NSString *)url
                    saveToPath:(NSString *)saveToPath
              downloadProgress:(void(^)(long long bytes, long long totalBytes))progressBlock
                       success:(void(^)(NSURLResponse *response, NSString *filePath))onRequestSuccessBlock
                       failure:(void(^)(NSURLResponse *response, NSError *error))onRequestFailureBlock;

/**
 *  预先处理返回的字典数据，可以提前在此进行数据解析，将_resultDic字典中数据modle化，减少viewcontrller中解析的逻辑复杂度
 */
- (void)preprocessResult;

@end
