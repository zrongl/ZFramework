//
//  ZLocaitonManager.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZLocaitonManager.h"
#import "CLLocation+YCLocation.h"
#import <Availability.h>
@interface ZLocaitonManager()
{
    CLLocationManager *_manager;
}

@property (copy, nonatomic) LocationInfoBlock infoBlock;
@property (copy, nonatomic) LocationErrorBlock errorBlock;
@property (copy, nonatomic) LocationCoordinateBlock coordinateBlock;

@end

@implementation ZLocaitonManager

+ (id)shareManager
{
    static dispatch_once_t pred = 0;
    __strong static ZLocaitonManager *_shareManager = nil;
    dispatch_once(&pred, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (void)getLocationCoordinate:(LocationCoordinateBlock)coordianteBlock locationInfo:(LocationInfoBlock)infoBlock locationError:(LocationErrorBlock)errorBlock
{
    self.infoBlock = infoBlock;
    self.errorBlock = errorBlock;
    self.coordinateBlock = coordianteBlock;
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        if (!_manager) {
            _manager=[[CLLocationManager alloc]init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            _manager.distanceFilter=100;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [_manager requestAlwaysAuthorization];
        }
        [_manager startUpdatingLocation];
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [alertView addAction:action];
#else
        UIAlertView *alvertView=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil];
        [alvertView show];
#endif
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_coordinateBlock) {
        _coordinateBlock(coordinate);
    }
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction
                   completionHandler:^(NSArray *placemarks,NSError *error){
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             if (_infoBlock) {
                 _infoBlock(placemark.name);
             }
         }
     }];
    [_manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_errorBlock) {
        _errorBlock(error);
    }
    [_manager stopUpdatingHeading];
}

@end
