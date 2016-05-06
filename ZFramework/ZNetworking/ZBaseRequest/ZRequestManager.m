//
//  LSHttpRequestManager.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "AFNetworking.h"
#import "ZRequestManager.h"
#import <CommonCrypto/CommonCryptor.h>

#define kEncryptOrDecryptKey  @"z&-ls0n!"

// 将参数转换为get请求的字符串形式
static NSString *GETQueryStringFrom(NSDictionary *parameters, NSStringEncoding stringEncoding)
{
    NSMutableString *queryString = [[NSMutableString alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            [array addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)value;
            [array addObject:[NSString stringWithFormat:@"%@=%@",key,number.stringValue]];
        }
    }
    [queryString appendFormat:@"?%@",[array componentsJoinedByString:@"&"]];
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)queryString, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8));
}

// 将参数转换为post请求的字符串形式
static NSString *POSTQueryStringFrom(NSDictionary *parameters)
{
    NSArray* allKey = parameters.allKeys;
    NSMutableString* queryString = [[NSMutableString alloc]initWithString:@""];
    for (NSString* key in allKey) {
        [queryString appendString:key];
        [queryString appendString:@"="];
        [queryString appendFormat:@"%@",parameters[key]];
        [queryString appendString:@"&"];
    }
    [queryString deleteCharactersInRange:NSMakeRange(queryString.length-1, 1)];
    
    return queryString;
}

// 字节数组转化16进制数
NSString *parseByteArray2HexString(Byte* bytes, NSInteger length)
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes){
        while (i < length){
            
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            i++;
        }
    }
    return [hexStr uppercaseString];
}

// des解码函数
NSData *desDecode(NSData *textData, NSString *key)
{
    NSData *cipherData = nil;
    NSUInteger dataLength = [textData length];
    unsigned int bufferPtrSize = ((int)dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes],dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        NSString* dataString = parseByteArray2HexString(bb, numBytesEncrypted);
        NSLog(@"密文:%@", dataString);
        cipherData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES加密失败");
    }
    return cipherData;
}

// 将16进制数据转化成NSData 数组
NSData *hexToByteArray(NSString *hexString)
{
    /*参考网上例子:http://blog.csdn.net/dwarven/article/details/8350951*/
    
    hexString=[[hexString uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

// DES加密
NSData *desEncode(NSData *data, NSString *key)
{
    NSData *clearData = nil;
    NSString* plainText = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"解密密文:%@", plainText);
    NSData *textData = hexToByteArray(plainText);
    NSUInteger dataLength = [textData length];
    unsigned int bufferPtrSize = ((int)dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes] ,dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess){
        NSLog(@"DES解密成功");
        clearData = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }else{
        NSLog(@"DES解密失败");
    }
    return clearData;
}

@interface ZRequestManager()

@property (strong, nonatomic) NSSet *mehtodEncodingSet;
@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (assign, nonatomic) AFParameterEncoding parameterEncoding;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableDictionary *httpRequestHeaders;

@end

@implementation ZRequestManager

+ (instancetype)manager
{
    static dispatch_once_t oncePredicate;
    static ZRequestManager* manager;
    dispatch_once(&oncePredicate, ^{
        manager = [[ZRequestManager alloc] init];
    });
    return manager;
}

+ (void)cancelAllRequest
{
    [[[ZRequestManager manager] operationQueue] cancelAllOperations];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stringEncoding = NSUTF8StringEncoding;
        self.parameterEncoding = AFFormURLParameterEncoding;
        self.operationQueue= [[NSOperationQueue alloc] init];
        self.httpRequestHeaders = [[NSMutableDictionary alloc] init];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        // 设置 Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
        NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
        [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            float q = 1.0f - (idx * 0.1f);
            [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
            *stop = q <= 0.5f;
        }];
        [self setValue:[acceptLanguagesComponents componentsJoinedByString:@", "] forHTTPHeaderField:@"Accept-Language"];
        
        NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        //设置 User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#pragma clang diagnostic pop
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        }
        
        self.mehtodEncodingSet = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    }
    return self;
}

/**
 *  创建mutableURLRequest
 *
 *  @param method     请求方法
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *
 *  @return 添加了parameterEncoding属性，可以根据类型将对请求参数进行处理如进行json格式转换、对参数进行des加密或直接用&进行拼接，最后添加到http header中
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    // 设置请求方法和超时时间
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = method;
    mutableRequest.timeoutInterval = 30.f;
    
    // 设置URLRequest的httpHeader 如果mutableRequest的某个field已经设置则不去覆盖该设置
    //{"Accept-Language":"en;q=1, fr;q=0.9, de;q=0.8, zh-Hans;q=0.7, zh-Hant;q=0.6, ja;q=0.5",
    //"User-Agent":"AFNetworking iOS Example/1.0.0 (iPhone Simulator; iOS 8.3; Scale/2.00)"}
    [self.httpRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        // 如果是HTTPMethod是GET HEAD DELETE中的一种 则直接在URL中拼接参数
        // 如果是其他类型HTTPMehtod则将参数转换为NSData封装在HTTPBody中
        if ([self.mehtodEncodingSet containsObject:[[mutableRequest HTTPMethod] uppercaseString]]) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingString:GETQueryStringFrom(parameters, self.stringEncoding)]];
        } else {
            // 获取字符编码名称
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            NSError *error = nil;
            
            switch (self.parameterEncoding) {
                case AFFormURLParameterEncoding:
                    [mutableRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    
                    [mutableRequest setHTTPBody:[POSTQueryStringFrom(parameters) dataUsingEncoding:self.stringEncoding]];
                    break;
                case AFJSONParameterEncoding:
                    [mutableRequest setValue:[NSString stringWithFormat:@"application/json;charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:(NSJSONWritingOptions)0 error:&error]];
                    break;
                case AFPropertyListParameterEncoding:
                    [mutableRequest setValue:[NSString stringWithFormat:@"application/x-plist;charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [mutableRequest setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
                case AFJSONDesParameterEncoding:
                    // Http Request Header
                    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [mutableRequest setValue:@"iphone" forHTTPHeaderField:@"User-Agent"];
                    
                    // traceinfo 可以包含服务器需要统计的信息比如：系统信息或设备信息
                    [mutableRequest setValue:@"" forHTTPHeaderField:@"traceinfo"];
                    
                    // paramdic->jsonData->des加密
                    NSData* paramData = [NSJSONSerialization dataWithJSONObject:parameters options: (NSJSONWritingOptions)0 error:&error];
                    NSData* encyptData = desEncode(paramData, kEncryptOrDecryptKey);
                    [mutableRequest setHTTPBody:encyptData];
                    
                    break;
            }
        }
    }
    return mutableRequest;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" URLString:URLString parameters:parameters];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)UPLOAD:(NSString *)URLString
                        parameters:(id)parameters
                  constructingBody:(void (^) (id <AFMultipartFormData> formData))constructBlock
                     uploadProcess:(void (^) (NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                URLString:URLString
                                                                               parameters:parameters
                                                                constructingBodyWithBlock:constructBlock
                                                                                    error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:processBlock];
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)DOWNLOAD:(NSString *)URLString
                          parameters:(id)parameters
                            filePath:(NSString *)filePath
                     downloadProcess:(void (^) (NSUInteger bytes, long long totalBytes, long long totalBytesExpected))processBlock
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *originRequest = [self requestWithMethod:@"POST" URLString:URLString parameters:parameters];

    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMultipartFormRequest:originRequest
                                                               writingStreamContentsToFile:[NSURL URLWithString:filePath]
                                                                         completionHandler:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setDownloadProgressBlock:processBlock];
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (void)batchOfRequestOperations:(NSArray *)operations
                   progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                 completionBlock:(void (^)(NSArray *operations))completionBlock
{
    NSParameterAssert(operations || operations.count < 0);
    
    __block dispatch_group_t group = dispatch_group_create();
    NSBlockOperation *batchedOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(operations);
            }
        });
    }];
    
    for (AFURLConnectionOperation *operation in operations) {
        operation.completionGroup = group;
        void (^originalCompletionBlock)(void) = [operation.completionBlock copy];
        __weak __typeof(operation)weakOperation = operation;
        operation.completionBlock = ^{
            __strong __typeof(weakOperation)strongOperation = weakOperation;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_queue_t queue = strongOperation.completionQueue ?: dispatch_get_main_queue();
#pragma clang diagnostic pop
            dispatch_group_async(group, queue, ^{
                if (originalCompletionBlock) {
                    originalCompletionBlock();
                }
                
                NSUInteger numberOfFinishedOperations = [[operations indexesOfObjectsPassingTest:^BOOL(id op, NSUInteger __unused idx,  BOOL __unused *stop) {
                    return [op isFinished];
                }] count];
                
                if (progressBlock) {
                    progressBlock(numberOfFinishedOperations, [operations count]);
                }
                
                dispatch_group_leave(group);
            });
        };
        
        dispatch_group_enter(group);
        
        [batchedOperation addDependency:operation];
    }
    
    [self.operationQueue addOperations:[operations arrayByAddingObject:batchedOperation] waitUntilFinished:YES];
}

- (void)setValue:(id)value forHTTPHeaderField:(NSString *)key
{
    [self.httpRequestHeaders setValue:value forKey:key];
}

@end
