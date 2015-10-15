//
//  BarberModel.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberModel.h"

@implementation BarberModel

- (NSDictionary*)fieldMappingTable
{
    return @{@"barberId":@"id",
             @"nickName":@"nickname",
             @"name":@"real_name",
             @"gender":@"gender",
             @"orderNum":@"order_num",
             @"fansNum":@"fans_num",
             @"motto":@"signature",
             @"profile":@"profile",
             @"imgPath":@"avatar_path",
             @"creditNum":@"",
             @"award":@""
             };
}

@end
