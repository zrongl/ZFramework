//
//  TBaseViewController.m
//  TGod
//
//  Created by Joven on 14/12/18.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "LSNoDataView.h"
#import "LSNoNetworkView.h"
#import "Macro.h"

#define ARRAW_SIDE 9.f
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface BaseViewController () <LSNoDataViewDelegate, LSNoNetworkViewDelegate>

@property (strong, nonatomic) UIImageView *arrawImgView;
@property (strong, nonatomic) LSNoDataView *noDataView;
@property (strong, nonatomic) LSNoNetworkView *noNetworkView;
@property (strong, nonatomic) MBProgressHUD *progressView;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupNavigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _progressView = [[MBProgressHUD alloc] initWithView:self.view];
    _progressView.dimBackground = NO;
    [self.view addSubview:_progressView];
    
    UIImageView *hairLine = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    hairLine.hidden = YES;
}

- (void)setupNavigationBar
{
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
//        // tabbar隐藏时 底部不会出现空白
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
//    self.navigationController.navigationBar.clipsToBounds = YES;
//    UIImage *image = [UIImage imageNamed:@"tab_bg_line.png"];
//    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//        UIImage * image = [UIImage imageWithColor:RGB(255, 255, 255) size:CGSizeMake(kMainBoundsWidth, 64)];
//        [[UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        self.navigationController.navigationBar.clipsToBounds = YES;
//        UIImage *image = IMAGE_AT_APPDIR(@"tab_bg_line.png");
//        [[UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }
}

- (void)setNavTitle:(NSString *)title
{
    //注意必须先定义 leftBarButtonItem和rightBarButtonItem的位置
    //注意，此处不使用self.navigationItem.rightBarButtonItems这样形式的用法
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    //标题宽度
    CGSize maximumLabelSize = CGSizeMake(kMainBoundsWidth,44);
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont systemFontOfSize:17]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = expectedLabelSize.width;
    CGFloat maxWidth = 120;
    if(width <= kMainBoundsWidth-2*maxWidth){
        titleLabel.frame = CGRectMake(0, 0, kMainBoundsWidth-maxWidth*2, 44);
        titleView.frame = CGRectMake(maxWidth, 0, kMainBoundsWidth-maxWidth*2, 44);
    } else{
        CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
        CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
        CGRect frame;
        CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
        maxWidth += 15;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
        frame = titleLabel.frame;
        frame.size.width = kMainBoundsWidth - maxWidth * 2;
        titleLabel.frame = frame;
        
        frame = titleView.frame;
        frame.size.width = kMainBoundsWidth - maxWidth * 2;
        titleView.frame = frame;
    }
    titleLabel.text = title;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}

- (void)setNavPullDownTitle:(NSString *)title
{
    UILabel *tLabel = (UILabel *)[self.navigationItem.titleView viewWithTag:1082];
    if (tLabel && [tLabel isKindOfClass:[UILabel class]]) {
        tLabel.text = title;
    }else{
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
        titleView.autoresizesSubviews = YES;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
        titleLabel.tag = 1082;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.autoresizingMask = titleView.autoresizingMask;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGSize maximumLabelSize = CGSizeMake(kMainBoundsWidth,44);
        CGSize expectedLabelSize = [title sizeWithFont:[UIFont systemFontOfSize:17]
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat width = expectedLabelSize.width;
        titleLabel.frame = CGRectMake(0, 0, width, 44.f);
        titleView.frame = CGRectMake((kMainBoundsWidth - (width + ARRAW_SIDE))/2, 0, (width + ARRAW_SIDE), 44.f);
        titleLabel.text = title;
        [titleView addSubview:titleLabel];
        
        _arrawImgView = [[UIImageView alloc] initWithFrame:CGRectMake(titleView.frame.size.width - ARRAW_SIDE, (44.f - ARRAW_SIDE)/2, ARRAW_SIDE, ARRAW_SIDE)];
        _arrawImgView.image = [UIImage imageNamed:@"btn_down_arrow.png"];
        [titleView addSubview:_arrawImgView];
        
        UIButton *overButton = [UIButton buttonWithType:UIButtonTypeCustom];
        overButton.backgroundColor = [UIColor clearColor];
        overButton.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
        [overButton addTarget:self action:@selector(navPullDownAction) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:overButton];
        
        self.navigationItem.titleView = titleView;
    }
}

- (void)animationRotate:(int)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2f];
    _arrawImgView.layer.anchorPoint = CGPointMake(0.5,0.5);
    _arrawImgView.transform = CGAffineTransformMakeRotation(degreesToRadian(angle));
    [UIView commitAnimations];
}

- (void)setNavBackArrow
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 40);
    if (SYSTEM_VERSION > 7.0) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    }else{
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    }
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setNavRightButtonWithImage:(NSString *)name action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [self getButtonItemWithImg:name selImg:nil title:nil action:action];
}

- (void)setNavRightButtonWithTitle:(NSString *)title action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [self getButtonItemWithImg:nil selImg:nil title:title action:(SEL)action];
}

- (void)setNavLeftButtonWithTitle:(NSString *)title action:(SEL)action {
    self.navigationItem.leftBarButtonItem = [self getButtonItemWithImg:nil selImg:nil title:title action:(SEL)action];
}

- (UIBarButtonItem *)getButtonItemWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action
{
    CGSize navbarSize = self.navigationController.navigationBar.bounds.size;
    CGRect frame = CGRectMake(0, 0, navbarSize .height, navbarSize.height - 3);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    if (norImg)
        [button setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    if (selImg)
        [button setImage:[UIImage imageNamed:selImg] forState:UIControlStateHighlighted];
    if (title) {
        CGSize strSize = CGSizeZero;
        if (SYSTEM_VERSION > 7.0) {
            strSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
        } else {
            strSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:14]];
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBA(198, 198, 198, 1) forState:UIControlStateHighlighted];
        frame.size.width = MAX(frame.size.width, strSize.width + 20);
    }
    button.frame = frame;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* tmpBarBtnItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    return tmpBarBtnItem;
}

#pragma mark - NavButton Clicked
- (void)navBackButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 请求加载框
- (void)showProgressViewWithTitle:(NSString *)title
{
    [self.view bringSubviewToFront:_progressView];
    if (title){
        _progressView.labelText = title;
    }
    [_progressView show:YES];
}

- (void)hideProgressView
{
    [_progressView hide:YES];
}

#pragma mark - 无数据展示界面
- (void)showNoDataView
{
    if (!_noDataView) {
        _noDataView = [LSNoDataView viewFromNib];
        _noDataView.delegate = self;
        [_noDataView showInView:self.view];
    }
}

- (void)hideNoDataView
{
    [_noDataView hide];
}

- (void)showNoNetworkView
{
    if (_noNetworkView) {
        _noNetworkView = [LSNoNetworkView viewFromNib];
        _noNetworkView.delegate = self;
        [_noNetworkView showInView:self.view];
    }
}

- (void)hideNoNetworkView
{
    [_noNetworkView hide];
}
#pragma mark - LSNoDataViewDelegate
- (void)noDataRetryGetData
{
    
}

#pragma mark - LSNoNetworkDelegate
- (void)noNetworkRetryGetData
{
    
}

@end
