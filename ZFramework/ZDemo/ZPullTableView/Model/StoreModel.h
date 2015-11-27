//
//  StoreModel.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseModel.h"

@interface StoreModel : ZBaseModel

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *overAll;
@property (strong, nonatomic) NSString *orderNum;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *distance;

@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *isGo;
@property (strong, nonatomic) NSString *isActivity;
@property (strong, nonatomic) NSString *startPrice;
@property (strong, nonatomic) NSString *path;

@end
