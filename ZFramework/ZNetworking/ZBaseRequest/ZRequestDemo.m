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
        self.URLHost = @"http://203.187.186.135:6220/";
        self.URLAction = @"ufm/v1/protected/familyService/571029556312000000/familyMembers";
        self.methodType = HttpMethodGet;
        [self.parameterDic setValue:userId forKey:@"userId"];
    }
    
    return self;
}

- (void)preprocessResult
{
    NSLog(@"%@", self.resultDic);
}

@end
