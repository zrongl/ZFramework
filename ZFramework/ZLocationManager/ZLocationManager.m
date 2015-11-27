//
//  ZLocaitonManager.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <Availability.h>
#import "ZLocationManager.h"
#import "CLLocation+YCLocation.h"

@interface ZLocationManager()
{
    CLLocationManager *_manager;
}

@property (copy, nonatomic) LocationSuccessBlock successBlock;
@property (copy, nonatomic) LocationFailedBlock failedBlock;

@end

@implementation ZLocationManager

+ (id)shareManager
{
    static dispatch_once_t pred = 0;
    __strong static ZLocationManager *_shareManager = nil;
    dispatch_once(&pred, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (void)locationOnSuccess:(LocationSuccessBlock)successBlock onFailed:(LocationFailedBlock)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        if (!_manager) {
            _manager=[[CLLocationManager alloc]init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            _manager.distanceFilter=1000;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            /**
             *  iOS8对定位进行了一些修改，其中包括定位授权的方法，CLLocationManager增加了下面的两个方法：
             *  1.始终允许访问位置信息
             *  - (void)requestAlwaysAuthorization;
             *  2.使用应用程序期间允许访问位置数据
             *  - (void)requestWhenInUseAuthorization;
             *  3.在Info.plist文件中添加如下配置
             *  NSLocationAlwaysUsageDescription    YES
             *  NSLocationWhenInUseUsageDescription YES
             */
            [_manager requestAlwaysAuthorization];
        }
        [_manager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction
                   completionHandler:^(NSArray *placemarks,NSError *error){
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locationInfo = [NSString stringWithFormat:@"%@%@%@", placemark.locality, placemark.subLocality, placemark.thoroughfare];
             if (_successBlock) {
                 _successBlock(coordinate, locationInfo);
             }
         }
     }];
    [_manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_failedBlock) {
        _failedBlock(error);
    }
    [_manager stopUpdatingHeading];
}

@end
