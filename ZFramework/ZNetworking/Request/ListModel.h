//
//  ListModel.h
//  ZFramework
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZBaseModel.h"

@interface ListModel : ZBaseModel

@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSMutableArray *array;

@end
