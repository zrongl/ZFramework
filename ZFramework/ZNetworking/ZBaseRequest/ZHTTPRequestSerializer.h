//
//  ZHTTPRequestSerializer.h
//  ZFramework
//
//  Created by ronglei on 16/9/7.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "AFURLRequestSerialization.h"

typedef NS_ENUM(NSInteger, AFParameterEncoding) {
    AFFormURLParameterEncoding,
    AFJSONParameterEncoding,
    AFPropertyListParameterEncoding,
    AFJSONDesParameterEncoding,
};

@interface ZHTTPRequestSerializer : AFHTTPRequestSerializer

@property (assign, nonatomic) AFParameterEncoding parameterEncoding;

@end
