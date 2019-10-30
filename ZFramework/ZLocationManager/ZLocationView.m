//
//  ZLocationView.m
//  ZFramework
//
//  Created by ronglei on 15/9/30.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZLocationView.h"
#import "ZLocationManager.h"

@interface ZLocationView()

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIButton *locationButton;

@end

@implementation ZLocationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width - 48, frame.size.height)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.font = [UIFont systemFontOfSize:13.f];
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.text = @"当前：";
        [self addSubview:_addressLabel];
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = CGRectMake(frame.size.width - 48.f, 0, 48.f, frame.size.height);
        [_locationButton setImage:[UIImage imageNamed:@"location_btn"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationButton];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5f, frame.size.width, 0.5f)];
        bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomLineView];
    }
    
    return self;
}

- (void)locationClicked:(UIButton *)sender
{
    [self startRotation];
    _addressLabel.text = @"当前：";
    [[ZLocationManager shareManager] locationOnSuccess:^(CLLocationCoordinate2D orrrdinate, NSString *info) {
        _addressLabel.text = [NSString stringWithFormat:@"当前:%@", info];
        [self stopRotation];
    }
                                              onFailed:^(NSError *error) {
                                                  _addressLabel.text = @"定位失败";
                                                  [self stopRotation];
                                              }];
}

- (void)startRotation
{
    [self rotationAnimationInView:_locationButton];
}

- (void)stopRotation
{
    [_locationButton.layer removeAllAnimations];
}

- (void)rotationAnimationInView:(UIView *)view
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 3.f;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"transform"];
}

@end
