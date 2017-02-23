//
//  CNLoopProgressView.m
//  CMInstanews
//
//  Created by ronglei on 2016/12/2.
//  Copyright © 2016年 cm. All rights reserved.
//

#import "CNLoopProgressView.h"

#define ProgressBorderWidth     4

@interface CNLoopProgressView()
{
    UIImage *_gifImage;
    
}
@end

@implementation CNLoopProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _gifImage = [UIImage imageNamed:@"ic_gif"];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress <= 1.0 ? progress : 1.0;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = self.width * 0.5;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, ProgressBorderWidth);
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5;
    
    CGContextSetStrokeColorWithColor(ctx, RGBA(228, 228, 228, 1).CGColor);
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, M_PI*1.5, 0);
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, RGBA(214, 9, 18, 1).CGColor);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    
    CGFloat strX = xCenter - 12;
    CGFloat strY = yCenter - 9;
    
    [_gifImage drawAtPoint:CGPointMake(strX, strY)];
}

@end
