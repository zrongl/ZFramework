//
//  CAAnimation+ZAnimation.m
//  ZFramework
//
//  Created by ronglei on 16/5/23.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "CAAnimation+ZAddition.h"

@implementation CAAnimation (ZAddition)

+ (CAKeyframeAnimation *)shake
{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.values = @[@(10),@(-8),@(6),@(-4),@(2),@(-1),@(0)];//x值
    shakeAnimation.duration = 0.6f;//设置时间
    shakeAnimation.repeatCount = 0;//是否重复
    shakeAnimation.autoreverses = NO;//是否反转
    shakeAnimation.removedOnCompletion = YES;//完成移除
    return shakeAnimation;
}

+ (CABasicAnimation *)rotation
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 3.f;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}

@end
