//
//  UIApplication+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/30.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIShareApplication  [UIApplication sharedApplication]

@interface UIApplication (ZAddition)

+ (NSURL *)cachesURL;
+ (NSString *)cachesPath;

+ (NSURL *)libraryURL;
+ (NSString *)libraryPath;

+ (NSURL *)documentsURL;
+ (NSString *)documentsPath;

+ (NSString *)appVersion;
+ (NSString *)appBundleID;
+ (NSString *)appBundleName;
+ (NSString *)appBuildVersion;

+ (float)cpuUsage;
+ (int64_t)memoryUsage;

+ (BOOL)isAppExtension;
+ (UIApplication *)sharedExtensionApplication;

@end
