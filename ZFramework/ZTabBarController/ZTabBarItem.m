//
//  ZTabBarItem.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "Macro.h"
#import "ZTabBarItem.h"
#import "NSString+ZAddition.h"

@implementation ZTabBarItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:kThemeColor forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateSelected];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
    
    return self;
}

/**
 *  屏蔽UIButton的高亮属性
 *
 *  @param highlighted
 */
- (void)setHighlighted:(BOOL)highlighted{}

/**
 *  自定义title位置 放在图片下方
 *
 *  @param contentRect
 *
 *  @return title在button中显示的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, kTabBarIconSide, self.frame.size.width, 21.f);
}

/**
 *  自定义image位置 在标题上方
 *
 *  @param contentRect
 *
 *  @return image在button中显示的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((self.frame.size.width - kTabBarIconSide)/2, 0, kTabBarIconSide, kTabBarIconSide);
}

@end
