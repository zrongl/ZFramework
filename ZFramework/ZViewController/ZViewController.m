//
//  ZViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZViewController.h"
#import <Availability.h>

#define kLoaddingViewWidth  120.f
#define kIndicatorViewSide  37.f

@implementation ZNavigationController
// push之后底部导航栏消失
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

+ (void)customizeAppearanceForiOS7
{
    // status bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // Navigation
    // [[UINavigationBar appearance] setBarTintColor:];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //  Navigation background
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.f],
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UITextAttributeTextColor,[UIColor whiteColor], nil] forState:UIControlStateNormal];
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                               NSForegroundColorAttributeName : [UIColor whiteColor]}
     forState:UIControlStateNormal];
    // backButton
    // UIImage *backBarBtnImage = [[UIImage imageNamed:@"back_button_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    
    // [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    UIImage *backBarBtnImage = [[UIImage imageNamed:@"nav_back"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
    
    
    // Tabbar
    // [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tab_bg"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x999999), UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kJiaYuanColor, UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    
    // 定制tableView的分割线的颜色 (236, 236, 236)
    // [[UITableView appearance] setSeparatorColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]];
}

@end

@interface ZViewController ()
{
    UIView      *_loadingView;
    NSInteger   *_loadingShowCount;
}

@end

@implementation ZViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadingShowCount = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self navigationBarBottomLine:self.navigationController.navigationBar].hidden = YES;
}

/**
 *  通过遍历获取navigation bar bottom line
 *
 *  @param view navigation bar
 *
 *  @return navigation bar bottom line
 */
- (UIImageView *)navigationBarBottomLine:(UIView *)view
{
    // 判断条件为line的高度 <=1.0
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        return [self navigationBarBottomLine:subview];
    }
    return nil;
}

- (void)customDismissButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 禁止事件向同一视图内的其它子视图传递
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 50, 40);
    button.backgroundColor = [UIColor clearColor];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setImage:[UIImage imageNamed:@"nav_dismiss"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)dismissButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonItemWithTitle:(NSString *)title action:(SEL)action
{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:action];
    
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)rightButtonItemWithImage:(NSString *)image action:(SEL)action
{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:action];
    
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)showLoadingViewWithTitle:(NSString *)title
{
    _loadingShowCount ++;
    if (!_loadingView) {
        _loadingView = [self createLoadingViewWith:title];
        [self.view addSubview:_loadingView];
    }
    _loadingView.hidden = NO;
}

- (void)hideLoadingView
{
    _loadingShowCount --;
    if (_loadingShowCount == 0) {
        _loadingView.hidden = YES;
    }
}

- (UIView *)createLoadingViewWith:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - kNavgationBarHeight)];
    view.alpha = 1.f;
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLoaddingViewWidth, 100)];
    loadingView.backgroundColor = [UIColor darkGrayColor];
    loadingView.layer.cornerRadius = 10.f;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    
    if (title) {
        CGFloat titleWidth = [title widthWithFont:[UIFont boldSystemFontOfSize:17.f] height:21.f];
        loadingView.width = MIN(MAX((titleWidth + 16.f), kLoaddingViewWidth), kMainBoundsWidth - 16);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 62, loadingView.width - 16, 21.f)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [loadingView addSubview:titleLabel];
        indicatorView.frame = CGRectMake(loadingView.center.x - kIndicatorViewSide/2, 14, kIndicatorViewSide, kIndicatorViewSide);
    }else{
        indicatorView.frame = CGRectMake(loadingView.center.x - kIndicatorViewSide/2, loadingView.center.y - kIndicatorViewSide/2, kIndicatorViewSide, kIndicatorViewSide);
    }
    
    [loadingView addSubview:indicatorView];
    [view addSubview:loadingView];
    [view setFrame:CGRectMake((kMainBoundsWidth-loadingView.width)/2.f, ((kMainBoundsHeight - kNavgationBarHeight) - loadingView.height)/2 - kNavgationBarHeight/2, kMainBoundsWidth, kMainBoundsHeight - kNavgationBarHeight)];
    
    return view;
}


@end
