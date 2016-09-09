//
//  ZRequestDemo.m
//  ZFramework
//
//  Created by ronglei on 16/9/8.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZRequestDemo.h"

@implementation ZRequestDemo

- (instancetype)initWithId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.URLHost = @"http://127.0.0.1/";
        self.URLAction = @"request/store.php";
        self.methodType = HttpMethodPost;
        [self.parameterDic setValue:userId forKey:@"userId"];
    }
    
    return self;
}

- (void)preprocessResult
{
    NSLog(@"%@", self.resultDic);
}

@end
