//
//  ZViewController.h
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNavigationController : UINavigationController

@end

@interface ZViewController : UIViewController

/**
 *  自定义pop按钮
 */
- (void)customBackButton;
- (void)backButtonClicked:(id)sender;

/**
 *  自定义dismiss按钮
 */
- (void)customDismissButton;
- (void)dismissButtonClicked:(id)sender;

/**
 *  自定义navigation bar right button的title
 *
 *  @param title  标题
 *  @param action 按钮事件
 */
- (void)customRightButtonWithTitle:(NSString *)title action:(SEL)action;

/**
 *  自定义navigation bar right button的image
 *
 *  @param nImage normal image
 *  @param hImage highlighted image
 *  @param action 按钮事件
 */
- (void)customRightButtonWithNormalImage:(NSString *)nImage highlightedImage:(NSString *)hImage action:(SEL)action;

/**
 *  设置navigation title的内容，字体及颜色
 *
 *  @param title 标题
 */
- (void)setNavigationTitle:(NSString *)title;

/**
 *  发送请求时加载框的显示与隐藏函数
 *
 *  @param title 加载框标题
 */
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

@end

