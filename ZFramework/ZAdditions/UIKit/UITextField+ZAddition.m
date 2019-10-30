//
//  UITextField+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/5/30.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "UITextField+ZAddition.h"

@implementation UITextField (ZAddition)

- (void)selectAllText
{
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

@end
