//
//  ZViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZViewController.h"
#import <Availability.h>
#import "ZRequestManager.h"
#import <libkern/OSAtomic.h>

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
    
    // navigation background
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.f],
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // navigation title
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                                                                                                       NSForegroundColorAttributeName : [UIColor whiteColor]}
                                                                                            forState:UIControlStateNormal];
    
    // navigation back button
    UIImage *backBarBtnImage = [[UIImage imageNamed:@"nav_back"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBarBtnImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
}

@end

@interface ZViewController ()
{
    UIView      *_loadingView;
}

@property (atomic, assign) int32_t loadingShowCount;

@end

@implementation ZViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取消全部请求
    [ZRequestManager cancelAllRequest];
#if 0
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kViewControllerHideLoadingViewNotify];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadingShowCount = 0;
#if 0 // 隐藏loadingView
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideLoadingView)
                                                     name:kViewControllerHideLoadingViewNotify object:nil];
#endif
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
    OSAtomicIncrement32(&_loadingShowCount);
    if (!_loadingView) {
        _loadingView = [self createLoadingViewWith:title];
        [self.view addSubview:_loadingView];
    }
    _loadingView.hidden = NO;
}

- (void)showLoadingView
{
    OSAtomicIncrement32(&_loadingShowCount);
    if (!_loadingView) {
        _loadingView = [self createLoadingViewWith:@"正在加载..."];
        [self.view addSubview:_loadingView];
    }
    _loadingView.hidden = NO;
}

- (void)hideLoadingView
{
    OSAtomicDecrement32(&_loadingShowCount);
    if (_loadingShowCount == 0) {
        _loadingView.hidden = YES;
    }
}

- (UIView *)createLoadingViewWith:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.alpha = 1.f;
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-kLoaddingViewWidth)/2.f, (kScreenHeight - kNavgationBarHeight  - 100)/2, kLoaddingViewWidth, 100)];
    loadingView.backgroundColor = [UIColor darkGrayColor];
    loadingView.layer.cornerRadius = 10.f;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    
    if (title) {
        CGFloat titleWidth = [title widthWithFont:[UIFont boldSystemFontOfSize:17.f] height:21.f];
        loadingView.width = MIN(MAX((titleWidth + 16.f), kLoaddingViewWidth), kScreenWidth - 16);
        loadingView.left = (view.width - loadingView.width)/2.f;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 62, loadingView.width - 16, 21.f)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [loadingView addSubview:titleLabel];
        indicatorView.frame = CGRectMake((loadingView.width - kIndicatorViewSide)/2, 14, kIndicatorViewSide, kIndicatorViewSide);
    }else{
        indicatorView.frame = CGRectMake((loadingView.width - kIndicatorViewSide)/2, (loadingView.height - kIndicatorViewSide)/2, kIndicatorViewSide, kIndicatorViewSide);
    }
    [loadingView addSubview:indicatorView];
    [view addSubview:loadingView];
    
    return view;
}

@end
