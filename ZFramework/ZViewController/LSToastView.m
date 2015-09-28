//
//  LSToastView.m
//  Hands-Seller
//
//  Created by Bob on 14-4-21.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import "LSToastView.h"

@interface LSToastView()

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LSToastView

#pragma mark lifecycle method
+ (id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 15;
    _bgView.layer.cornerRadius = 15;
    self.alpha = .5;
}
#pragma mark public method

+(void)showWithMsg:(NSString*)msg
{
    [[LSToastView sharedView]showWithMsg:msg dismissDelay:MAXFLOAT];
}


+(void)showWithMsg:(NSString*)msg dismissDelay:(float)offset
{
    [[LSToastView sharedView]showWithMsg:msg dismissDelay:offset];
}

+(void)showWithMsg:(NSString*)msg center:(CGPoint)point
{
    [[LSToastView sharedView]showWithMsg:msg dismissDelay:MAXFLOAT center:point];
}

+(void)showWithMsg:(NSString*)msg center:(CGPoint)point dismissDelay:(float)offset
{
    [[LSToastView sharedView]showWithMsg:msg dismissDelay:offset center:point];
}
#pragma mark private method
+(LSToastView*)sharedView
{
    static dispatch_once_t onceToken;
    static LSToastView* errorTipView;
    dispatch_once(&onceToken, ^{
        errorTipView = [LSToastView loadFromXib];
    });
    return errorTipView;
}

-(void)showWithMsg:(NSString*)msg dismissDelay:(float)offetset
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [self showWithMsg:msg dismissDelay:offetset center:CGPointMake(window.frame.size.width/2, window.frame.size.height-80)];
}

-(void)showWithMsg:(NSString*)msg dismissDelay:(float)offetset center:(CGPoint)point
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [self resetView:msg];
        self.center = point;
        if (!self.superview) {
            
            [window addSubview:self];
            self.alpha = 0;

            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 1;
            }];
        }
        if (msg) {
            _titleLabel.text = msg;
        }else{
            _titleLabel.text = @"网络异常";
        }
        NSLog(@"~~~~~~~~~%@",_titleLabel);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hide) withObject:nil afterDelay:offetset];
        
    });
}

-(void)resetView:(NSString*)msg
{
    CGSize msgSize = [msg sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(250, 100)];
    self.frame = CGRectMake(0, 0, MAX(150, msgSize.width)+50, msgSize.height+16);
    _titleLabel.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, msgSize.width,msgSize.height);
    _bgView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    _titleLabel.center = self.center;
    _bgView.center = self.center;
}

-(void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
