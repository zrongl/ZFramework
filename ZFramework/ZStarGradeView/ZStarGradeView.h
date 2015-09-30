//
//  ZStarGradeView.h
//  ZFramework
//
//  Created by ronglei on 15/9/28.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZStarGradeView : UIView

/**
 *  设置frame时需要注意：
 *  1. 默认为5颗星星
 *  1. frame.size.height 默认为星星的边长sideWidth 星星默认为正方形
 *  2. frame.size.width 应该设置为 (spacing + sideWidth) x kStarNumber 星星之间的spacing自己把握
 *
 *  @param frame      视图大小
 *  @param grayImage  灰色星星
 *  @param lightImage 高亮星星
 *
 *  @return 星星评分视图
 */
- (id)initWithFrame:(CGRect)frame grayImage:(UIImage *)grayImage lightImage:(UIImage *)lightImage;

/**
 *  根据分数及分制设置星星评分
 *  一般用户显示评分界面，可以进行分数及分制的设置
 *  分制理解：
 *  如果分制是10分，则评分的范围为0~10以内的数，可以是小数；
 *  如果分制为100分，则评分的范围为0~100以内的数，可以是小数；以此类推
 *
 *  @param score       评分
 *  @param scoreSystem 分制
 *  @param animation   是否使用动画更新评分
 */
- (void)setGradeWithScore:(CGFloat)score scoreSystem:(NSInteger)scoreSystem animation:(BOOL)animation;

/**
 *  获取当前用户所设置的评分
 *  一般用于用户进行评分的界面，可对分数进行编辑
 */
- (CGFloat)getScore;

/**
 *  默认分制为5分，进行星星评分设置
 *
 *  @param score     分数0~5
 *  @param animation 是否使用动画更新评分
 */
- (void)setScore:(CGFloat)score animation:(BOOL)animation;

@end
