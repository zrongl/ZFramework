//
//  StoreModel.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel

- (NSDictionary*)fieldMappingTable
{
    return @{@"storeId":@"id",
             @"storeName":@"name",
             @"address":@"address",
             @"distance":@"distance",
             @"overAll":@"overall",
             @"orderNum":@"order_num",
             @"startPrice":@"start_price",
             @"isGo":@"is_go",
             @"isActivity":@"is_activity",
             @"path":@"path"
             };
}

@end
