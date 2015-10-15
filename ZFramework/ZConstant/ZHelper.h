//
//  ZHelper.h
//  ZFramework
//
//  Created by ronglei on 15/9/28.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  返回x以内的带有两位小数的浮点数
 *
 *  @param x x
 *
 *  @return x以内的带有两位小数的浮点数
 */
#define xRandom(x) (arc4random()%x + arc4random()%100/100.f)

@interface ZHelper : NSObject


+ (UIView *)createSeperateCellWithY:(CGFloat)y;
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action target:(id)target;
+ (UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(CGFloat)size color:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

/**
 *  16进制颜色转换为UIColor *
 *
 *  @param hexString 16进制颜色表示
 *
 *  @return 16进制颜色对应的UIColor *
 */
+ (UIColor *)hexStringToColor: (NSString *)hexString;

@end
