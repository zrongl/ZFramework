//
//  ZSystemVolume.h
//  ZFramework
//
//  Created by ronglei on 2017/5/24.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#define Volume_Change_Notification @"Volume_Change_Notification"

@interface ZSystemVolume : NSObject

@property (nonatomic, assign, readonly) CGFloat volumeValue;

+ (ZSystemVolume *)shareInstance;

- (void)silent;
- (void)unsilent;
- (void)setVolumeChangeEnable:(BOOL)enable;
- (void)setSystemVolumeSliderHidden:(BOOL)hidden;

@end
