//
//  BarberDetailRequest.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseRequest.h"

@interface BarberRequest : ZBaseRequest

- (id)initWithBarberId:(NSString *)barberId;

@end

@interface BarberServeRequest : ZBaseRequest

- (id)initWithBarberId:(NSString *)barberId;

@end

@interface BarberWorksRequest : ZBaseRequest

- (id)initWithBarberId:(NSString *)barberId;

@end
