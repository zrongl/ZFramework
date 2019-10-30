//
//  InsetNoTouchTableView.m
//  ZFramework
//
//  Created by ronglei on 16/9/26.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "InsetNoTouchTableView.h"

@implementation InsetNoTouchTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return point.y > 0;
}

@end
