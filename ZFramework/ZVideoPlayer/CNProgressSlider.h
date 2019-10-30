//
//  XLSlider.h
//  XLSlider
//
//  Created by Shelin on 16/3/18.
//  Copyright © 2016年 GreatGate. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNProgressSliderDelegate;

@interface CNProgressSlider : UIView

@property (nonatomic, assign) CGFloat value;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue;  /* From 0 to 1 */

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, weak) id<CNProgressSliderDelegate> sliderDelegate;

@end

@protocol CNProgressSliderDelegate <NSObject>

- (void)sliderDragging:(CNProgressSlider *)slider;
- (void)sliderDidEndDragging:(CNProgressSlider *)slider;
- (void)sliderWillBeginDragging:(CNProgressSlider *)slider;

@end
