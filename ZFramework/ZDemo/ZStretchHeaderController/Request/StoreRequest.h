//
//  StoreRequest.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseRequest.h"

@interface StoreRequest : ZBaseRequest

- (id)initWithItemId:(NSString *)itemId targetId:(NSString *)target barberId:(NSString *)barberId;

@end
