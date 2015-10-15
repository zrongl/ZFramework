//
//  BarberWorkModel.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberWorkModel.h"

@implementation BarberWorkModel

- (NSDictionary *)fieldMappingTable
{
    return @{@"barberId":@"id",
             @"pathsArray":@"path"
             };
}

@end
