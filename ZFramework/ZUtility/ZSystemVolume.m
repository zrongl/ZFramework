//
//  ZSystemVolume.m
//  ZFramework
//
//  Created by ronglei on 2017/5/24.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import "ZSystemVolume.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define MIN_VALUE 1e-8  //根据需要调整这个值
#define IS_CGFloat_ZERO(d) (fabs(d) < MIN_VALUE)
#define MAX_VALUE 1e-1
#define IS_CGFloat_Sound(d) (fabs(d) > MAX_VALUE)

@interface ZSystemVolume()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) MPVolumeView *mpVolumeView;

@property (nonatomic, assign) BOOL volumeChangeEnable;
@property (nonatomic, assign) CGFloat originalVolume;

@end


@implementation ZSystemVolume
@synthesize volumeValue = _volumeValue;
#pragma mark public methods
+ (ZSystemVolume *)shareInstance
{
    static ZSystemVolume *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once (&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _volumeChangeEnable = YES;
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider *volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        _volumeValue = volumeViewSlider.value;
        [self registerVolumeChangeEvent];
    }
    
    return self;
}

- (void)unsilent
{
    if (_mpVolumeView && _slider) {
        [_slider setValue:_originalVolume animated:NO];
    }else{
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider *volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        [volumeViewSlider setValue:_originalVolume animated:NO];
    }
    
    _volumeValue = _originalVolume;
}

- (void)silent
{
    if (_mpVolumeView && _slider) {
        [_slider setValue:0.0 animated:NO];
    }else{
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider *volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        [volumeViewSlider setValue:0.0 animated:NO];
    }
    _originalVolume = _volumeValue;
    _volumeValue = 0.0;
}

- (void)setVolumeChangeEnable:(BOOL)enable
{
    _volumeChangeEnable = enable;
}

- (void)setSystemVolumeSliderHidden:(BOOL)hidden
{
    if (hidden) {
        if (!_mpVolumeView) {
            _mpVolumeView = [[MPVolumeView alloc] init];
            _mpVolumeView.hidden = NO;
            [_mpVolumeView setFrame:CGRectMake(-1000, 0, 10, 10)];
            [[[UIApplication sharedApplication].delegate window] addSubview:_mpVolumeView];
            for (UIView *view in [_mpVolumeView subviews]){
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                    self.slider = (UISlider*)view;
                    break;
                }
            }
        }
    }else{
        if (_mpVolumeView) {
            [_mpVolumeView removeFromSuperview];
            _slider = nil;
            _mpVolumeView = nil;
        }
    }
}

- (void)registerVolumeChangeEvent
{
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangedNotification:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)unregisterVolumeChangeEvent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

#pragma mark getters
- (CGFloat)volumeValue
{
    return _volumeValue;
}

#pragma mark notification
- (void)volumeChangedNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    float value = [[userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (_volumeChangeEnable) {
        _volumeValue = value;
    }else{
        if (!IS_CGFloat_ZERO(value)) {
            if (_mpVolumeView && _slider) {
                [_slider setValue:0.0 animated:NO];
            }else{
                MPVolumeView *volumeView = [[MPVolumeView alloc] init];
                UISlider *volumeViewSlider = nil;
                for (UIView *view in [volumeView subviews]){
                    if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                        volumeViewSlider = (UISlider*)view;
                        break;
                    }
                }
                [volumeViewSlider setValue:0.0 animated:NO];
            }
            _volumeValue = 0.0;
        }
    }
}

@end
