//
//  UIBarButtonItem+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/5/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZAddition)

@property (nullable, nonatomic, copy) void (^actionBlock)(_Nonnull id);

@end
