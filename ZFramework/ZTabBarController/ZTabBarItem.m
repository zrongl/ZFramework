//
//  ZTabBarItem.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZConstant.h"
#import "ZTabBarItem.h"
#import "NSString+ZAddition.h"

@interface ZTabBarItem()

{
    ButtonImageLayout _imageLayout;
}

@end

@implementation ZTabBarItem

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              image:(UIImage *)image
      selectedImage:(UIImage *)selectedImage
    imageLayoutType:(ButtonImageLayout)layoutType
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageLayout = layoutType;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:kMainColor forState:UIControlStateSelected];
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
    CGRect rect;
    switch (_imageLayout) {
        case ButtonImageLayoutLeft:
            rect = [super titleRectForContentRect:contentRect];
            break;
        case ButtonImageLayoutRight:{
            CGFloat titleWidth = [[self titleForState:UIControlStateNormal] widthWithFont:[UIFont systemFontOfSize:13] height:21];
            CGFloat left = (CGRectGetWidth(contentRect) - titleWidth - kTabBarIconSide)/2;
            CGFloat top = (CGRectGetHeight(contentRect) - 21)/2;
            rect = CGRectMake(left, top, titleWidth, 21);
            
            break;
        }
        case ButtonImageLayoutUp:
            rect = CGRectMake(0, kTabBarIconSide, CGRectGetWidth(contentRect), 21.f);
            break;
        case ButtonImageLayoutDown:{
            rect = CGRectMake(0, 0, CGRectGetWidth(contentRect), 21.f);
            break;
        }
        default:
            break;
    }
    return rect;
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
    CGRect rect;
    switch (_imageLayout) {
        case ButtonImageLayoutLeft:
            rect = [super imageRectForContentRect:contentRect];
            break;
        case ButtonImageLayoutRight:{
            CGFloat titleWidth = [[self titleForState:UIControlStateNormal] widthWithFont:[UIFont systemFontOfSize:13] height:21];
            CGFloat left = (CGRectGetWidth(contentRect) - titleWidth - kTabBarIconSide)/2 + titleWidth;
            CGFloat top = (CGRectGetHeight(contentRect) - kTabBarIconSide)/2;
            rect = CGRectMake(left, top, kTabBarIconSide, kTabBarIconSide);
            break;
        }
        case ButtonImageLayoutUp:
            rect = CGRectMake((CGRectGetWidth(contentRect) - kTabBarIconSide)/2, 0, kTabBarIconSide, kTabBarIconSide);
            break;
        case ButtonImageLayoutDown:
            rect = CGRectMake((CGRectGetWidth(contentRect) - kTabBarIconSide)/2, 21, kTabBarIconSide, kTabBarIconSide);
            break;
        default:
            break;
    }
    return rect;
}

@end
