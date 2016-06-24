//
//  ZTabBarController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZTabBarController.h"
#import "ZTabBarItem.h"
#import <Availability.h>
#import "ZConstant.h"

#import "ZViewController.h"
#import "ViewController.h"
#import "ViewController5.h"

#define TABBAR_COUNT    3
#define TABBAR_BASE_TAG 238

@implementation ZTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createTabBarControllers];
    [self clearOriginTabBarView];
    [self customTabBarView];
}

/**
 *  初始化tabbarcontroller的viewControllers
 */
- (void)createTabBarControllers
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:TABBAR_COUNT];
    ViewController *vc = [[ViewController alloc] init];
    ZNavigationController *nav = [[ZNavigationController alloc] initWithRootViewController:vc];
    [viewControllers addObject:nav];
    
    ViewController5 *vc1 = [[ViewController5 alloc] init];
    ZNavigationController *nav1 = [[ZNavigationController alloc] initWithRootViewController:vc1];
    [viewControllers addObject:nav1];
    
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    ZNavigationController *nav2 = [[ZNavigationController alloc] initWithRootViewController:vc2];
    [viewControllers addObject:nav2];
    
    self.viewControllers = [NSArray arrayWithArray:viewControllers];
    self.selectedIndex = 0;
}

/**
 *  删除原始的tabbarview上的内容，不删除的话系统会将navigation tile设为tabbar的title
 *  设置自定义tabbarview时必须执行该方法，很重要！！！
 */
- (void)clearOriginTabBarView
{
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  设置自定义tabbarview
 */
- (void)customTabBarView
{
    // 自定义tabbar的标题，正常状态图片及选中状态图片的名称
    NSArray *titles =           [NSArray arrayWithObjects:@"统计",@"清算", @"我的", nil];
    NSArray *images =           [NSArray arrayWithObjects:@"tabbar1", @"tabbar2", @"tabbar3", nil];
    NSArray *selectedImages =   [NSArray arrayWithObjects:@"tabbar1_sel", @"tabbar2_sel", @"tabbar3_sel", nil];
    
    CGFloat itemWidth = kScreenWidth/TABBAR_COUNT;
    for (int i = 0; i < TABBAR_COUNT; i ++) {
        ZTabBarItem *item = [[ZTabBarItem alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, kTabBarHeight)
                                                         title:[titles objectAtIndex:i]
                                                         image:[UIImage imageNamed:[images objectAtIndex:i]]
                                                 selectedImage:[UIImage imageNamed:[selectedImages objectAtIndex:i]]
                                               imageLayoutType:ButtonImageLayoutUp];
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i + TABBAR_BASE_TAG;
        if (i == self.selectedIndex) {
            [item setSelected:YES];
        }
        [self.tabBar addSubview:item];
    }
    UIImage *tabBarImage= [[UIImage imageNamed:@"tabbar_bg.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:1];
    [self.tabBar setBackgroundImage:tabBarImage];
 }

/**
 *  tabbar item 点击事件
 *
 *  @param sender tabbar item
 */
- (void)itemClicked:(ZTabBarItem *)sender
{
    for (int i = 0; i < TABBAR_COUNT; i ++) {
        ZTabBarItem *item = (ZTabBarItem *)[self.tabBar viewWithTag:i + TABBAR_BASE_TAG];
        [item setSelected:NO];
    }
    
    [sender setSelected:YES];
    [self setSelectedIndex:sender.tag - TABBAR_BASE_TAG];
}

/**
 *  不能直接修改tabbar
 *  ERROR:Directly modifying a tab bar managed by a tab bar controller is not allowed.
 */
- (void)setupTabBarView
{
    // 自定义tabbar的标题，正常状态图片及选中状态图片的名称
    NSArray *titles =                    [NSArray arrayWithObjects:@"统计",@"清算", @"我的", nil];
    __unused NSArray *images =           [NSArray arrayWithObjects:@"tabbar1", @"tabbar2", @"tabbar3", nil];
    __unused NSArray *selectedImages =   [NSArray arrayWithObjects:@"tabbar1_sel", @"tabbar2_sel", @"tabbar3_sel", nil];
    
    CGFloat itemCount = titles.count;
    for (int i = 0; i < itemCount; i ++) {
        UITabBarItem *barItem = [self.tabBar.items objectAtIndex:i];
        [barItem setTitle:[titles objectAtIndex:i]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        
#else
        [barItem setFinishedSelectedImage:[UIImage imageNamed:[selectedImages objectAtIndex:i]]
              withFinishedUnselectedImage:[UIImage imageNamed:[images objectAtIndex:i]]];
#endif
    }

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:255/255.0f green:98/255.0f blue:28/255.0f alpha:1.0f];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    self.selectedIndex = 0;
}

@end
