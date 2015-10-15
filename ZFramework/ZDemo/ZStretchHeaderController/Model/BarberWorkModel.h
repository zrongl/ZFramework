//
//  BarberWorkModel.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseModel.h"

@interface BarberWorkModel : ZBaseModel

@property (strong, nonatomic) NSString *barberId;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSArray *pathsArray;

@end
