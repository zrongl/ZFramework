//
//  CNVolumeSlider.h
//  ZFramework
//
//  Created by ronglei on 2017/6/26.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCNVolumeWidth   5.0f
#define kCNVolumeHeight  (SCREEN_WIDTH/3)

@interface CNVolumeSlider : UIView

- (void)updateVolume:(CGFloat)volume;

@end
