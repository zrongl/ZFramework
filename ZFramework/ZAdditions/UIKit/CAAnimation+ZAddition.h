//
//  CAAnimation+ZAnimation.h
//  ZFramework
//
//  Created by ronglei on 16/5/23.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (ZAddition)

+ (CABasicAnimation *)rotation;
+ (CAKeyframeAnimation *)shake;

@end
