//
//  ZConstant.h
//  ZFramework
//
//  Created by ronglei on 15/10/12.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#ifndef ZConstant_h
#define ZConstant_h

// 状态栏高度
#define kStatusBarHeight        20.f

// 自定义TabBar属性
#define kTabBarHeight           49.f
#define kTabBarIconSide         25.f

// 自定义NavigationBar属性
#define kNavgationBarHeight     (44.f + (SYSTEM_VERSION > 7.0 ? 20 : 0))
#define kNavigationTitleColor   [UIColor blackColor]
#define kNavigationTitleFont    [UIFont boldSystemFontOfSize:20.f]

#define kMainBoundsWidth        [UIScreen mainScreen].bounds.size.width
#define kMainBoundsHeight       [UIScreen mainScreen].bounds.size.height

#define SYSTEM_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]
#define RGBA(r,g,b,a)           [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r, g, b)            RGBA(r, g, b, 1)

#define kMainColor              RGBA(30, 171, 254, 1.f)
#define kSeperateLineColor      [UIColor grayColor]
#define kBackgroundColor        [UIColor whiteColor]

#endif /* ZConstant_h */
