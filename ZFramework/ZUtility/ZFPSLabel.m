//
//  ZFPSLabel.m
//  ZFramework
//
//  Created by ronglei on 16/6/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZFPSLabel.h"
#import "ZTextAttributes.h"

@implementation ZFPSLabel
{
    NSUInteger      _count;
    CADisplayLink   *_link;
    NSTimeInterval  _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake(55, 20);
        frame.origin.y = kNavgationBarHeight;
    }
    self = [super initWithFrame:frame];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.userInteractionEnabled = NO;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont fontWithName:@"Menlo" size:14];
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    @weakify(self)
    _link = [CADisplayLink displayLinkWithTarget:weak_self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}

- (void)dealloc
{
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(55, 20);
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSString *string = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    NSString *substring = @"FPS";
    
    self.attributedText = ZTextAttributes
                          .string(string)
                          .subcolor(color, substring)
                          .attributeString(0);
}

@end
