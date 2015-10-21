//
//  ZPhotoBrowserController.m
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPhoto.h"
#import "ZPhotoView.h"
#import "ZPhotoInfoBar.h"
#import "ZPhotoBrowserController.h"

@interface ZPhotoBrowserController() <UIScrollViewDelegate, ZPhotoViewDelegate>

{
    ZPhotoInfoBar           *_photoInfoBar;
    UIScrollView            *_scrollView;
    UIView                  *_navigationView;
    
    ZPhotoView              *_leftImageView;
    ZPhotoView              *_middleImageView;
    ZPhotoView              *_rightImageView;
    
    BOOL                    _isInfoShow;
    BOOL                    _statusBarHidden;
}

@end

@implementation ZPhotoBrowserController

// 系统navigation bar隐藏及显示操作
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// 状态栏的隐藏与显示控制
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}
- (BOOL)prefersStatusBarHidden
{
    return _statusBarHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDatas];
    [self setupViews];
    
    [self initPhotoView];
}

- (void)setupDatas
{
    _isInfoShow = YES;
    _statusBarHidden = NO;
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor blackColor];
    // 如果不设置此项，状态栏隐藏时，视图会向上便宜20像素
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 初始化scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentOffset = CGPointMake((_currentPhotoIndex-1) * _scrollView.width, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _photosArray.count, 0);
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    // 自定义navigatinBar
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 64)];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 27, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:backButton];
    [self.view addSubview:_navigationView];
    
    // 底部信息栏
    _photoInfoBar = [[ZPhotoInfoBar alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight-140, kMainBoundsWidth, 140)];
    [_photoInfoBar setPhotos:_photosArray];
    [self.view addSubview:_photoInfoBar];
    
    // 节省内存三个ZPhotoView轮询前/后置
    _leftImageView = [[ZPhotoView alloc] initWithFrame:_scrollView.bounds];
    _leftImageView.tapDelegate = self;
    [_scrollView addSubview:_leftImageView];
    
    _middleImageView = [[ZPhotoView alloc] initWithFrame:_scrollView.bounds];
    _middleImageView.tapDelegate = self;
    [_scrollView addSubview:_middleImageView];
    
    _rightImageView = [[ZPhotoView alloc] initWithFrame:_scrollView.bounds];
    _rightImageView.tapDelegate = self;
    [_scrollView addSubview:_rightImageView];
}

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initPhotoView
{
    _photoInfoBar.currentPhotoIndex = _currentPhotoIndex;
    
    CGRect frame = self.view.bounds;
    frame.origin.x = (_currentPhotoIndex - 1)*_scrollView.width;
    _middleImageView.frame = frame;
    _middleImageView.photo = _photosArray[_currentPhotoIndex-1];
    
    if ((_currentPhotoIndex-1) > 0) {
        _leftImageView.photo = _photosArray[_currentPhotoIndex-2];
        CGRect frame = _middleImageView.frame;
        frame.origin.x -= _scrollView.width;
        _leftImageView.frame = frame;
    }
    if (_currentPhotoIndex < _photosArray.count) {
        _rightImageView.photo = _photosArray[_currentPhotoIndex];
        CGRect frame = _middleImageView.frame;
        frame.origin.x += _scrollView.width;
        _rightImageView.frame = frame;
    }
}

- (void)setCurrentPhotoIndex:(NSInteger)currentPhotoIndex
{
    if ([self isViewLoaded]) {
        if (_currentPhotoIndex < currentPhotoIndex) {
            // 向右翻页
            id x = _leftImageView;
            _leftImageView = _middleImageView;
            _middleImageView = _rightImageView;
            _rightImageView = x;
            if (currentPhotoIndex < _photosArray.count) {
                _rightImageView.photo = _photosArray[currentPhotoIndex];
            }else{
                _rightImageView.photo = nil;
            }
            // l-m-r -> r-l-m
            CGRect frame = self.view.frame;
            frame.origin.x = currentPhotoIndex*_scrollView.width;
            _rightImageView.frame = frame;
            
            [_leftImageView resetStatus];
        }else{
            // 向左翻页
            id x = _rightImageView;
            _rightImageView = _middleImageView;
            _middleImageView = _leftImageView;
            _leftImageView = x;
            if (currentPhotoIndex > 1) {
                _leftImageView.photo = _photosArray[currentPhotoIndex-2];
            }else{
                _leftImageView.photo = nil;
            }
            // l-m-r -> m-r-l
            CGRect frame = self.view.frame;
            frame.origin.x = (currentPhotoIndex-2)*_scrollView.width;
            _leftImageView.frame = frame;
            
            [_rightImageView resetStatus];
        }
    }

    _currentPhotoIndex = currentPhotoIndex;
    _photoInfoBar.currentPhotoIndex = currentPhotoIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 每次滚动回调进行一次浮点运算，相较其它封装已经极大的降低了性能的消耗
    int index = (scrollView.contentOffset.x + _scrollView.width/2)/_scrollView.width + 1;
    if (index != _currentPhotoIndex) {
        self.currentPhotoIndex = index;
    }
}

#pragma mark - ZPhotoViewDelegate
- (void)photoViewSimpleTap:(ZPhotoView *)photoView
{
    if (_isInfoShow) {
        [UIView animateWithDuration:0.5 animations:^{
            _statusBarHidden = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            _navigationView.alpha = 0;
            _photoInfoBar.alpha = 0;
        }];
        _isInfoShow = NO;

    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _statusBarHidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            _navigationView.alpha = 1;
            _photoInfoBar.alpha = 1;
        }];
        _isInfoShow = YES;
    }
}

@end
