//
//  LoginRequest.m
//  LaShouSeller
//
//  Created by ronglei on 15/8/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlAction = @"/login/login";
    }
    
    return self;
}

- (NSString *)localServerURL
{
    return @"http://localhost/t_.php";
}

@end
