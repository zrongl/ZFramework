//
//  BarberServeModel.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/14.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberServeModel.h"

@implementation BarberServeModel

- (NSDictionary *)fieldMappingTable
{
    return @{@"serveId":@"id",
             @"serveName":@"product_name",
             @"price":@"price",
             @"isActivity":@"is_activity",
             @"isBasePrice":@"is_base"
             };
}

@end
