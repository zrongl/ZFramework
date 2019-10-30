//
//  UIDevice+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/30.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ZAddition)

+ (double)systemVersion;

@property (nonatomic, readonly) BOOL isSimulator;
@property (nonatomic, readonly) BOOL isJailbroken;

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonnull, nonatomic, readonly) NSString *machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonnull, nonatomic, readonly) NSString *machineModelName;

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space (-1 when error occurs)
///=============================================================================
@property (nonatomic, readonly) int64_t diskSpace;
@property (nonatomic, readonly) int64_t diskSpaceFree;
@property (nonatomic, readonly) int64_t diskSpaceUsed;

#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information (-1 when error occurs)
///=============================================================================
@property (nonatomic, readonly) int64_t memoryTotal;
@property (nonatomic, readonly) int64_t memoryUsed;
@property (nonatomic, readonly) int64_t memoryFree;
@property (nonatomic, readonly) int64_t memoryActive;
@property (nonatomic, readonly) int64_t memoryInactive;
@property (nonatomic, readonly) int64_t memoryWired;
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

@property (nonatomic, readonly) float cpuUsage;
@property (nonatomic, readonly) NSUInteger cpuCount;
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

@end

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif