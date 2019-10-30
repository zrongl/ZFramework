//
//  ZLocaitonManager.h
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^ LocationFailedBlock)(NSError *error);
typedef void (^ LocationSuccessBlock)(CLLocationCoordinate2D corrrdinate, NSString *info);

@interface ZLocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;

+ (id)shareManager;

/**
 *  通过block返回所在位置的坐标及详细位置信息
 *
 *  @param coordianteBlock 位置经纬度block
 *  @param infoBlock       位置信息block
 *  @param errorBlock      定位失败错误信息block
 */
- (void)locationOnSuccess:(LocationSuccessBlock)successBlock onFailed:(LocationFailedBlock)failedBlock;

@end
