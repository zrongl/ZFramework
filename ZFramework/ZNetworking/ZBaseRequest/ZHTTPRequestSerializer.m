//
//  ZHTTPRequestSerializer.m
//  ZFramework
//
//  Created by ronglei on 16/9/7.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZHTTPRequestSerializer.h"
#import <CommonCrypto/CommonCryptor.h>

#define kEncryptOrDecryptKey @"z&-ls0n!"

// 将参数转换为get请求的字符串形式
NSString *GETQueryStringFrom(NSDictionary *parameters, NSStringEncoding stringEncoding)
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
NSString *POSTQueryStringFrom(NSDictionary *parameters)
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

@implementation ZHTTPRequestSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    // 设置请求地址，请求方法此处为POST请求
    NSMutableURLRequest *mutableRequest = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    mutableRequest.timeoutInterval = 30.f;
    
    // 设置httpHeader和httpBody
    mutableRequest = [[self requestBySerializingRequest:mutableRequest withParameters:parameters error:error] mutableCopy];
    
    return mutableRequest;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError * __autoreleasing *)error
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    if (parameters) {
        // 如果是HTTPMethod是GET HEAD DELETE中的一种 则直接在URL中拼接参数
        // 如果是其他类型HTTPMehtod则将参数转换为NSData封装在HTTPBody中
        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[mutableRequest HTTPMethod] uppercaseString]]) {
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

@end
