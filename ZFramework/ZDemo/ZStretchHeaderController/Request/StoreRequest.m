//
//  StoreRequest.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "StoreRequest.h"

@implementation StoreRequest

- (id)initWithItemId:(NSString *)itemId targetId:(NSString *)target barberId:(NSString *)barberId
{
    self = [super init];
    if (self) {
        self.urlAction = @"/Store/storeDetail";
        [self.parameterDic setValue:barberId forKey:@"employee_id"];
    }
    
    return self;
}

- (NSString *)localServerURL
{
    return @"http://localhost/meiye/shop_detail.php";
}

@end
