//
//  BarberDetailRequest.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberRequest.h"

@implementation BarberRequest

- (id)initWithBarberId:(NSString *)barberId
{
    self = [super init];
    if (self) {
        self.urlAction = @"/Barber/barberDetail";
        [self.parameterDic setValue:barberId forKey:@"employee_id"];
    }
    
    return self;
}

@end

@implementation BarberServeRequest

- (id)initWithBarberId:(NSString *)barberId
{
    self = [super init];
    if (self) {
        self.urlAction = @"/Barber/barberDetail";
        [self.parameterDic setValue:barberId forKey:@"employee_id"];
    }
    
    return self;
}

- (NSString *)localServerURL
{
    return @"http://localhost/meiye/barber_serve_appoint.php";
}

@end


@implementation BarberWorksRequest

- (id)initWithBarberId:(NSString *)barberId
{
    self = [super init];
    if (self) {
        self.urlAction = @"/Composition/compositionList";
        [self.parameterDic setValue:barberId forKey:@"employee_id"];
    }
    
    return self;
}

- (NSString *)localServerURL
{
    return @"http://localhost/meiye/barber_works.php";
}

@end

