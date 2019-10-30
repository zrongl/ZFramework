//
//  CNVolumeSlider.m
//  ZFramework
//
//  Created by ronglei on 2017/6/26.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import "CNVolumeSlider.h"

@interface CNVolumeSliderDelegate : NSObject<CALayerDelegate>
@property (nonatomic, assign)CGFloat volume;
@property (nonatomic, assign)CGFloat centerX;
@end

@implementation CNVolumeSliderDelegate
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    
    CGFloat volumeMaxDistance  = kCNVolumeHeight;
    CGFloat volumeMinDistance  = 0.0f;
    CGFloat volumeBallDistance = (1 - self.volume) * volumeMaxDistance;
    
    CGMutablePathRef maxPath = CGPathCreateMutable();
    CGPathMoveToPoint(maxPath, NULL, self.centerX, volumeMaxDistance);
    CGPathAddLineToPoint(maxPath, nil, self.centerX, volumeBallDistance);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:0.99].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextAddPath(ctx, maxPath);
    CGPathCloseSubpath(maxPath);
    CGContextStrokePath(ctx);
    CGPathRelease(maxPath);
    
    CGMutablePathRef minPath = CGPathCreateMutable();
    CGPathMoveToPoint(minPath, NULL, self.centerX, volumeBallDistance);
    CGPathAddLineToPoint(minPath, nil, self.centerX, volumeMinDistance);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:0.2].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextAddPath(ctx, minPath);
    CGPathCloseSubpath(minPath);
    CGContextStrokePath(ctx);
    CGPathRelease(minPath);
}
@end

@interface CNVolumeSlider()
{
    CALayer *_lineLayer;
    CNVolumeSliderDelegate *_delegate;
}

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, strong) UILabel *upIconLabel;
@property (nonatomic, strong) UILabel *dwonIconLabel;


@end

@implementation CNVolumeSlider
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _volume = 0.0;
        _delegate = [[CNVolumeSliderDelegate alloc] init];
        _delegate.volume = _volume;
        
        _lineLayer = [CALayer layer];
        _lineLayer.delegate = _delegate;
        [self.layer addSublayer:_lineLayer];
        [_lineLayer setNeedsDisplay];
        
        _upIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8, -32, 24, 18)];
        _upIconLabel.font = [UIFont systemFontOfSize:24];
//        _upIconLabel.font = [UIFont fontWithName:[CNTxtIconsUtil getTxtIconFontFamily] size:24];
        [_dwonIconLabel setText:@"+"];
//        [_upIconLabel setText:[CNTxtIconsUtil getTxtIconWithType:CNTxtIconVolumeUp]];
        [_upIconLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_upIconLabel];
        
        _dwonIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8, kCNVolumeHeight+12, 24, 18)];
        _dwonIconLabel.font = [UIFont systemFontOfSize:24];
//        _dwonIconLabel.font = [UIFont fontWithName:[CNTxtIconsUtil getTxtIconFontFamily] size:24];
        [_dwonIconLabel setText:@"-"];
//        [_dwonIconLabel setText:[CNTxtIconsUtil getTxtIconWithType:CNTxtIconVolumeDown]];
        [_dwonIconLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_dwonIconLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _delegate.centerX = self.frame.size.width / 2.0f;
    _lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_lineLayer setNeedsDisplay];
}


- (void)updateVolume:(CGFloat)volume{
    
    _volume = volume;
    _delegate.volume = _volume;
    [_lineLayer setNeedsDisplay];
}
@end
