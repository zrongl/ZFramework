//
//  LSNoNetworkView.m
//  LashouBI
//
//  Created by ronglei on 15/1/14.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "LSNoNetworkView.h"

@implementation LSNoNetworkView

+ (LSNoNetworkView *)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}

- (void)showInView:(UIView *)suprView
{
    
}

- (void)hide
{
    
}

- (IBAction)onButtonClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(noNetworkRetryGetData)]) {
        [_delegate noNetworkRetryGetData];
    }
}

@end
