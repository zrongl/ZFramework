//
//  LSBaseRequest.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/11.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAchiverObjectCache.h"

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
- (void)requestSuccess:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
               failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock;

/**
 *  上传请求
 *
 *  @param onConstrctBlock       创建form data block
 *  @param processBlock          上传进度block
 *  @param onRequestSuccessBlock 成功block
 *  @param onRequestFailedBlock  失败block
 *
 */

/** 示例constructing body代码
 // 在此位置生成一个要上传的数据体
 // form对应的是html文件中的表单
 
 // 图片压缩率
 float kCompressionQuality = 0.8f;
 NSData *data = UIImageJPEGRepresentation(self.imageView.image, kCompressionQuality);
 // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
 // 要解决此问题，
 // 可以在上传时使用当前的系统事件作为文件名
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 // 设置时间格式
 formatter.dateFormat = @"yyyyMMddHHmmss";
 NSString *str = [formatter stringFromDate:[NSDate date]];
 NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
 
 
 // 此方法参数
 // 1. 要上传的[二进制数据]
 // 2. 对应网站上[upload.php中]处理文件的[字段"file"]
 // 3. 要保存在服务器上的[文件名]
 // 4. 上传文件的[mimeType]
 
 [formData appendPartWithFileData:data name:@"img_file" fileName:fileName mimeType:@"image/jpeg"];
*/

- (void)uploadRequestConstructingBody:(void(^)(id <AFMultipartFormData> formData))onConstrctBlock
                        uploadProcess:(void(^)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                              success:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                              failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock;

/**
 *  下载请求
 *
 *  @param filePath              下载文件写入路径
 *  @param processBlock          下载进度block
 *  @param onRequestSuccessBlock 成功block
 *  @param onRequestFailedBlock  失败block
 */
- (void)downloadRequestWithFilePath:(NSString *)filePath
                  downloadProcess:(void(^)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                          success:(void(^)(ZBaseRequest *request))onRequestSuccessBlock
                          failure:(void(^)(ZBaseRequest *request, NSError *error))onRequestFailureBlock;

/**
 *  预先处理返回的字典数据，可以提前在此进行数据解析，将_resultDic字典中数据modle化，减少viewcontrller中解析的逻辑复杂度
 */
- (void)preprocessResult;

@end