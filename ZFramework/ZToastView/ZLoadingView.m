//
//  ZLoadingView.m
//  ZFramework
//
//  Created by ronglei on 15/10/19.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZLoadingView.h"

static const CGFloat loadingViewWidth = 120.f;
static const CGFloat indicatorViewSide = 37.f;
static NSString *title = @"正在加载...";


@interface ZLoadingView()
{
    NSInteger   _loadingShowCount;
}
@end

@implementation ZLoadingView

+ (ZLoadingView*)sharedLoadingView
{
    static dispatch_once_t oncePredicate;
    static ZLoadingView* shareLoadingView;
    dispatch_once(&oncePredicate, ^{
        shareLoadingView = [[ZLoadingView alloc] init];
    });
    return shareLoadingView;
}

+ (void)show
{
    [[ZLoadingView sharedLoadingView] show];
}

+ (void)hide
{
    [[ZLoadingView sharedLoadingView] hide];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _loadingShowCount = 0;
        
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loadingViewWidth, 100)];
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.layer.cornerRadius = 10.f;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        
        CGFloat titleWidth = [title widthWithFont:[UIFont boldSystemFontOfSize:17.f] height:21.f];
        loadingView.width = MIN(MAX((titleWidth + 16.f), loadingViewWidth), kScreenWidth - 16);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 62, loadingView.width - 16, 21.f)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [loadingView addSubview:titleLabel];
        indicatorView.frame = CGRectMake(loadingView.center.x - indicatorViewSide/2, 14, indicatorViewSide, indicatorViewSide);
        
        [loadingView addSubview:indicatorView];
        [self addSubview:loadingView];
        [self setFrame:CGRectMake((kScreenWidth-loadingView.width)/2.f, ((kScreenHeight - kNavgationBarHeight) - loadingView.height)/2 - kNavgationBarHeight/2, kScreenWidth, kScreenHeight - kNavgationBarHeight)];
    }
    
    return self;
}

- (void)show
{
    _loadingShowCount ++;
    if (_loadingShowCount == 1) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
}

- (void)hide
{
    _loadingShowCount --;
    if (_loadingShowCount == 0) {
        [self removeFromSuperview];
    }
}

@end
