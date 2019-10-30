//
//  ZTabBarItem.h
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonImageLayout){
    ButtonImageLayoutLeft,
    ButtonImageLayoutRight,
    ButtonImageLayoutUp,
    ButtonImageLayoutDown
};


@interface ZTabBarItem : UIButton

/**
 *  自定义tabBarItem
 *
 *  @param frame         frame
 *  @param title         title
 *  @param image         正常时的图片
 *  @param selectedImage 选中时的图片
 *
 *  @return 自定义的tabBarItem
 */
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              image:(UIImage *)image
      selectedImage:(UIImage *)selectedImage
    imageLayoutType:(ButtonImageLayout)layoutType;

@end
