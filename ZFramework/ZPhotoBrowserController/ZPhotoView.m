//
//  ZPhotoView.m
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPhotoView.h"
#import "UIImageView+WebCache.h"

@interface ZPhotoView() <UIScrollViewDelegate>
{
    UIImageView     *_imageView;
    BOOL            _isDoubleTap;
}
@end

@implementation ZPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.f;
        self.backgroundColor = [UIColor clearColor];
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    
    return self;
}

- (void)setPhoto:(ZPhoto *)photo
{
    _photo = photo;
    
    if (photo) {
        if (photo.image) {
            _imageView.image = photo.image;
        }else{
            __weak ZPhotoView *weakSelf = self;
            [_imageView sd_setImageWithURL:String2URL(photo.url)
                          placeholderImage:photo.placeholder
                                   options:SDWebImageRetryFailed|SDWebImageLowPriority
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      // 显示进度条
                                  }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [weakSelf didFinishLoadImage:image];
                                 }];
        }
    }else{
        _imageView.image = nil;
    }
}

- (void)didFinishLoadImage:(UIImage *)image
{
    if (image) {
        _photo.image = image;
    }else{
        // 提示图片下载失败
    }
}

- (void)resetStatus
{
    [self setZoomScale:self.minimumZoomScale];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

#pragma mark - SimpleTapHandler
- (void)handleSingleTap:(UITapGestureRecognizer *)tapGesture
{
    _isDoubleTap = NO;
    [self performSelector:@selector(didSimpleTap) withObject:nil afterDelay:0.2];
}

- (void)didSimpleTap
{
    if (_isDoubleTap)  return;
    
    [_tapDelegate photoViewSimpleTap:self];
}

#pragma mark - DoubleTapHandler
- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGesture
{
    _isDoubleTap = YES;
    
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }
}

@end
