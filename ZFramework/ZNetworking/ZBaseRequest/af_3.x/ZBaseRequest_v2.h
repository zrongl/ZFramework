//
//  ZBaseRequest_v2.h
//  ZFramework
//
//  Created by ronglei on 2018/3/13.
//  Copyright © 2018年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpMethodType){
    HttpMethodGet,
    HttpMethodPost
};

@interface ZBaseRequest_v2 : NSObject

@property (assign, nonatomic) BOOL isCached;

@property (strong, nonatomic) NSString *urlHost;                // 请求基地址
@property (strong, nonatomic) NSString *urlAction;              // 请求行为
@property (assign, nonatomic) HttpMethodType methodType;        // 请求方式 POST或GET
@property (strong, nonatomic) NSMutableDictionary *resultDic;   // 请求返回json转换为dictionary
@property (strong, nonatomic) NSMutableDictionary *parameterDic;// 请求参数

/**
 *  读取本地json文件返回解析之后的字典
 *
 *  @param path 文件路径 需要作为资源文件添加到项目中
 *
 *  @return json转化后的dictionary
 */
+ (NSDictionary *)localDataFromPath:(NSString *)path;


/**
 *  普通GET/POST请求
 *
 *  @param onRequestSuccessBlock 成功block
 *  @param onRequestFailedBlock  失败block
 */
- (void)requestonSuccess:(void(^)(ZBaseRequest_v2 *request))onRequestSuccessBlock
                onFailed:(void(^)(ZBaseRequest_v2 *request, NSError *error))onRequestFailedBlock;

/**
 *  预先处理返回的字典数据，可以提前在此进行数据解析，将_resultDic字典中数据modle化，减少viewcontrller中解析的逻辑复杂度
 */
- (void)preprocessResult;

/**
 *  设置本地数据请求地址，只适用于普通请求
 *
 *  @return 返回本地请求URL
 */
- (NSString *)localServerURL;

@end
