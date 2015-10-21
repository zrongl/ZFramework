//
//  ZProgressView.h
//  ZFramework
//
//  Created by ronglei on 15/10/16.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color.
 * Defaults to translucent white (alpha 0.1)
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end
