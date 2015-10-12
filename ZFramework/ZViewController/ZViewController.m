//
//  ZViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZViewController.h"
#import "UIView+ZAddition.h"
#import "NSString+ZAddition.h"
#import <Availability.h>
#import "ZConstant.h"

@implementation ZNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

@interface ZViewController ()
{
    ZLoadingView *_loadingView;
    NSInteger *_loadingShowCount;
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

- (void)setNavigationTitle:(NSString *)title
{
    self.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : kNavigationTitleFont,
                                                                    NSForegroundColorAttributeName : kNavigationTitleColor};
}

- (void)customBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 禁止事件向同一视图内的其它子视图传递
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 50, 40);
    button.backgroundColor = [UIColor clearColor];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

/**
 *  在一些特殊情况需要捕捉navigation back button事件
 *  如：timer的释放需要提前于view controller的dealloc方法，此时可以在该方法中提前释放timer，防止循环引用引起的内存不释放
 *
 *  @param sender back button
 */
- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)customRightButtonWithTitle:(NSString *)title action:(SEL)action
{
    CGSize navbarSize = self.navigationController.navigationBar.bounds.size;
    CGRect frame = CGRectMake(0, 0, navbarSize .height, navbarSize.height - 3);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    CGFloat titleWidth = [title widthWithFont:[UIFont boldSystemFontOfSize:16.f] height:21.f];
    frame.size.width = MAX(titleWidth, titleWidth + 20);
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:RGBA(100, 100, 100, 1) forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)customRightButtonWithNormalImage:(NSString *)nImage highlightedImage:(NSString *)hImage action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    CGSize navbarSize = self.navigationController.navigationBar.bounds.size;
    [button setFrame:CGRectMake(0, 0, navbarSize .height, navbarSize.height - 3)];
    [button setImage:[UIImage imageNamed:nImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)showLoadingViewWithTitle:(NSString *)title
{
    _loadingShowCount ++;
    if (!_loadingView) {
        _loadingView = [ZLoadingView loadingViewWith:title];
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

@end

#define kLoaddingViewWidth  120.f
#define kIndicatorViewSide  37.f

@implementation ZLoadingView

+ (ZLoadingView *)loadingViewWith:(NSString *)title
{
    ZLoadingView *view = [[ZLoadingView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - kNavgationBarHeight)];
    view.alpha = 1.f;
    UIView *loadingView = [[ZLoadingView alloc] initWithFrame:CGRectMake(0, 0, kLoaddingViewWidth, 100)];
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
