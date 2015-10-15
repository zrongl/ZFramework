//
//  StoreListRequest.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "StoreListRequest.h"

@implementation StoreListRequest

- (id)initWithItemId:(NSString *)itemId
{
    self = [super init];
    if (self) {
        self.urlAction = @"/Store/storeDetail";
        [self.parameterDic setValue:itemId forKey:@"employee_id"];
    }
    
    return self;
}

- (NSString *)localServerURL
{
    return @"http://localhost/meiye/shop_list.php";
}

@end
