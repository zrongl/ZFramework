//
//  ZStarGradeView.m
//  ZFramework
//
//  Created by ronglei on 15/9/28.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZStarGradeView.h"

#define kStarNumber     5   // 星星数量

@interface ZStarGradeView()
{
    CGFloat _spacing;
    UIView *_frontView;
    CGFloat _sideLength;
}
@end

@implementation ZStarGradeView

- (id)initWithFrame:(CGRect)frame grayImage:(UIImage *)grayImage lightImage:(UIImage *)lightImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _sideLength = frame.size.height;
        _spacing = (frame.size.width - _sideLength*kStarNumber)/kStarNumber;
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _frontView.clipsToBounds = YES;
        for (int i = 0; i < kStarNumber; i ++) {
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(_sideLength+_spacing), 0, _sideLength, _sideLength)];
            backImageView.image = grayImage;
            UIImageView *frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(_sideLength+_spacing), 0, _sideLength, _sideLength)];
            frontImageView.image = lightImage;
            
            [backView addSubview:backImageView];
            [_frontView addSubview:frontImageView];
        }
        [self addSubview:backView];
        [self addSubview:_frontView];
    }
    
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x > 0) {
        CGRect frame = _frontView.frame;
        frame.size.width = point.x;
        _frontView.frame = frame;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect frame = _frontView.frame;
    if (point.x > 0) {
        CGFloat rate = ceil(point.x/(_spacing + _sideLength));
        frame.size.width = rate * (_spacing + _sideLength);
        _grade = rate;
    }else{
        frame.size.width = 0;
        _grade = 0;
    }
    [UIView animateWithDuration:0.2f animations:^{
        _frontView.frame = frame;
    }];
}

- (void)setGradeWithScore:(CGFloat)score scoreSystem:(NSInteger)scoreSystem animation:(BOOL)animation
{
    _grade = score/(scoreSystem/kStarNumber);
    
    double fractpart, intpart;
    fractpart = modf(_grade, &intpart);// 拆分浮点数的整数部分和小数部分
    
    CGRect frame = _frontView.frame;
    frame.size.width = intpart*(_spacing + _sideLength) + fractpart*_sideLength;
    if (animation) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [_frontView setFrame:frame];
                         }];
    }else{
        [_frontView setFrame:frame];
    }
}

@end
