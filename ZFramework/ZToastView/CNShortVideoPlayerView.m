//
//  CNGifPlayerView.m
//  CMInstanews
//
//  Created by ronglei on 2016/12/2.
//  Copyright © 2016年 cm. All rights reserved.
//

#import "CNShortVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface CNShortVideoPlayerView()

{
    AVPlayer        *_avplayer;
    AVURLAsset      *_avasset;
    AVPlayerItem    *_avitem;
    id              _playerObserver;
    
    CMTime          _bufferTime;
    BOOL            _didEnterBackground;
}

@end

@implementation CNShortVideoPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeAVPlayerObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)play
{
    //开始播放
    _avasset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:_pathString]];
    _avitem = [AVPlayerItem playerItemWithAsset:_avasset];
    _avplayer = [AVPlayer playerWithPlayerItem:_avitem];
    [self addAVPlayerObserver];
    
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.player = _avplayer;
}

- (void)playWithUrlString:(NSString *)urlString
{
    _pathString = urlString;
    [self play];
}

- (void)reset
{
    [_avplayer pause];
    [_avplayer seekToTime:CMTimeMake(0, 1)];
    [self removeAVPlayerObserver];
    _avplayer = nil;
    _avitem = nil;
    _avasset = nil;
}

- (void)rollback
{
    [_avplayer pause];
    [_avplayer seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - AVPlayer状态监听 -
- (void)addAVPlayerObserver
{
    if (_avitem) {
        [_avitem addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
        
        [_avitem  addObserver:self
                   forKeyPath:@"playbackBufferEmpty"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        
        [_avitem  addObserver:self
                   forKeyPath:@"playbackLikelyToKeepUp"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        
        [_avitem addObserver:self
                  forKeyPath:@"loadedTimeRanges"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidPlayToEndTimeNotification:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_avitem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemFailToPlayEndTimeNotification:)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:_avitem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemNewErrorLogEntryNotification:)
                                                     name:AVPlayerItemNewErrorLogEntryNotification
                                                   object:_avitem];
    }
    
    if (_avplayer) {
        dispatch_queue_t queue = dispatch_queue_create("", 0);
        __weak typeof(self) weakSelf = self;
        _playerObserver = [_avplayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                      queue:queue
                                                                 usingBlock:^(CMTime time) {
                                                                     // 播放进度
                                                                     __strong typeof(weakSelf) strongSelf = (weakSelf);
                                                                     if (strongSelf->_avitem.status == AVPlayerItemStatusReadyToPlay) {
                                                                         CMTime current = [strongSelf->_avitem currentTime];
                                                                         if (CMTIME_IS_VALID(current)) {
                                                                             NSLog(@"%lld", current.value);
                                                                         }
                                                                     }
                                                                 }];
    }
}

#pragma mark notification method
- (void)playerItemDidPlayToEndTimeNotification:(NSNotification *)notification
{
    // 播放完成 自动重播
    if ([notification.object isEqual:_avitem]) {
        // avplayer end
        CMTime cmtime = [_avitem currentTime];
        cmtime.value = 0;
        [_avplayer pause];
        [_avitem seekToTime:cmtime];
        [_avplayer play];
    }
}

- (void)playerItemFailToPlayEndTimeNotification:(NSNotification *)notification
{
    // avplayer error failed to play to end time
}

- (void)playerItemNewErrorLogEntryNotification:(NSNotification *)notification
{
    // avplayer error new error log
}

#pragma mark kvo method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isEqual:_avitem] && [keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            // 准备播放
            [_avplayer play];
        }else{
            // 播放错误
        }
    } else if ([object isEqual:_avitem]  && [keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (_avitem.playbackBufferEmpty) {
            // 正在缓冲
        }
    } else if ([object isEqual:_avitem] && [keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (_avitem.playbackLikelyToKeepUp && !_avitem.playbackBufferEmpty && !_avitem.playbackBufferFull) {
            if (!_didEnterBackground) {
                [_avplayer play];
            }
        }
    } else if ([object isEqual:_avitem] && [keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 缓冲进度
        CMTimeRange timeRange = [[_avitem.loadedTimeRanges firstObject] CMTimeRangeValue];
        _bufferTime = CMTimeAdd(timeRange.start, timeRange.duration);
        if (!_avitem.playbackBufferEmpty || _avitem.playbackBufferFull) {
            if (!_didEnterBackground) {
                [_avplayer play];
            }
        }
    }
}

- (void)removeAVPlayerObserver
{
    if (_avitem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:_avitem];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                      object:_avitem];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemNewErrorLogEntryNotification
                                                      object:_avitem];
        
        @try {
            [_avitem removeObserver:self
                         forKeyPath:@"status"];
        } @catch (NSException *exception) {
            
        }
        @try {
            [_avitem  removeObserver:self
                          forKeyPath:@"playbackBufferEmpty"];
        } @catch (NSException *exception) {
            
        }
        
        @try {
            [_avitem  removeObserver:self
                          forKeyPath:@"playbackLikelyToKeepUp"];
        } @catch (NSException *exception) {
            
        }
        
        @try {
            [_avitem removeObserver:self
                         forKeyPath:@"loadedTimeRanges"];
        } @catch (NSException *exception) {
            
        }
    }
    
    if (_avplayer) {
        [_avplayer pause];
        [_avplayer removeTimeObserver:_playerObserver];
    }
}

#pragma mark - UIApplicationNotification -
- (void)appDidBecomeActive
{
    _didEnterBackground = NO;
}

- (void)appDidEnterBackground
{
    _didEnterBackground = YES;
}

@end
