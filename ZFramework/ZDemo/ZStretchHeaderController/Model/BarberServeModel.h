//
//  BarberServeModel.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/14.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseModel.h"

@interface BarberServeModel : ZBaseModel

@property (strong, nonatomic) NSString *serveId;
@property (strong, nonatomic) NSString *serveName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *isActivity;
@property (strong, nonatomic) NSString *isBasePrice;

@end
