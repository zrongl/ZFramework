//
//  CNVideoPlayerView.m
//  CMInstanews
//
//  Created by ronglei on 2017/6/23.
//  Copyright © 2017年 cm. All rights reserved.
//

#import "CNVideoPlayerView.h"
#import "CNVideoControlView.h"
#import "CNYoutubeVideoPlayerView.h"

#import "Masonry.h"

typedef NS_ENUM(NSInteger, CNVideoType)
{
    CNVideoTypeMP4            = (0),  //mp4视频
    CNVideoTypeYoutube        = (1),  //Youtube视频
};

@interface CNVideoPlayerView()<CNVideoControlViewDelegate>

@property (nonatomic, assign) CGFloat current;                     //当前播放时长
@property (nonatomic, assign) CGFloat duration;                    //总时长
@property (nonatomic, assign) CGFloat buffering;                    //缓冲时长
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *youtubeId;
@property (nonatomic, assign) CGRect initialFrame;

@property (nonatomic, assign) CNVideoType videoType;
@property (nonatomic, assign) CNPlayerStatus status;

@property (nonatomic, strong) id avTimeObserver;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVURLAsset *avasset;
@property (nonatomic, strong) AVPlayerItem *avitem;

@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, strong) CNVideoControlView *controlView;
@property (nonatomic, strong) CNYoutubeVideoPlayerView *ytplayer;

@end

@implementation CNVideoPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _initialFrame = frame;
        
        _duration = 0;
        _status.buffering = NO;
        _status.sound = CNSoundTypeNone;
        _status.status = CNPlayStatusNone;
        _status.display = CNDisplayTypeSmallScreen;
        _status.playNext = CNPlayNextTypeDisable;
        
        //创建youtube视窗
        _ytplayer = [[CNYoutubeVideoPlayerView alloc] initWithFrame:self.bounds];
        _ytplayer.hidden = YES;
        [self setupYTPlayerObserver];
        [self addSubview:_ytplayer];
        [_ytplayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _controlView = [[CNVideoControlView alloc] initWithFrame:self.bounds];
        _controlView.deleate = self;
        [self addSubview:_controlView];
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _blackMaskView = [[UIView alloc] initWithFrame:self.bounds];
        _blackMaskView.alpha = 0;
        _blackMaskView.hidden = YES;
        _blackMaskView.userInteractionEnabled = NO;
        _blackMaskView.backgroundColor = [UIColor blackColor];
        [self addSubview:_blackMaskView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self reset];
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - YoutubePlayer状态监听 -
- (void)setupYTPlayerObserver
{
    __weak typeof(self) weakSelf = self;
    [_ytplayer setYoutubeVideoPlayerInitBlock:^(CNYoutubeVideoPlayerView *playerView) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat total = [playerView duration];
        strongSelf.duration = total;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.controlView setCurrentTime:0 totalTime:total];
        });
        //NSLog(@"YoutubeVideoPlayerInitBlock");
    }];
    
    [_ytplayer setYoutubeVideoPlayerStateBlock:^(CNYoutubeVideoPlayerView *playerView, CNYTPlayerState state) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        switch (state) {
            case kCNYTPlayerStateUnstarted:{
                //NSLog(@"kCNYTPlayerStateUnstarted");
                break;
            }
            case kCNYTPlayerStateEnded:{
                strongSelf->_status.status = CNPlayStatusDone;
                //NSLog(@"kCNYTPlayerStatePaused");
                break;
            }
            case kCNYTPlayerStatePlaying:{
                strongSelf->_status.status = CNPlayStatusPlaying;
                //printf("\n❤️❤️❤️❤️kCNYTPlayerStatePlaying❤️❤️❤️❤️");
                break;
            }
            case kCNYTPlayerStatePaused:{
                strongSelf->_status.status = CNPlayStatusPause;
                //NSLog(@"kCNYTPlayerStatePaused");
                break;
            }
            case kCNYTPlayerStateBuffering:{
                //NSLog(@"kCNYTPlayerStateBuffering");
                
                break;
            }
            case kCNYTPlayerStateQueued:
            case kCNYTPlayerStateUnknown:{
                //NSLog(@"kCNYTPlayerStateUnknown");
                break;
            }
            default:{
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
        });
    }];
    
    [_ytplayer setYoutubeVideoPlayerDidPlayTimeBlock:^(CNYoutubeVideoPlayerView *playerView) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        float total = [playerView duration];
        float current = [playerView currentTime];
        float buffering = [playerView videoLoadedFraction];
        strongSelf.duration = total;
        strongSelf.current = current;
        strongSelf->_status.status = CNPlayStatusPlaying;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.controlView setBufferingPresent:buffering];
            [strongSelf.controlView setCurrentTime:current totalTime:total];
            [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
        });
    }];
    
    [_ytplayer setYoutubeVideoPlayerErrorBlock:^(CNYoutubeVideoPlayerView *playerView, CNYTPlayerError errorType) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"\n!!!!youtube play error:%@!!!!", strongSelf.urlString);
        strongSelf->_status.status = CNPlayStatusError;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
        });
    }];
}

#pragma mark - AVPlayer状态监听 -
- (void)addAVPlayerObserver
{
    if (_avitem) {
        //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        [_avitem addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
        //监听播放的区域缓存是否为空
        [_avitem  addObserver:self
                   forKeyPath:@"playbackBufferEmpty"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        //缓存可以播放的时候调用
        [_avitem  addObserver:self
                   forKeyPath:@"playbackLikelyToKeepUp"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        //监控缓冲加载时长
        [_avitem addObserver:self
                  forKeyPath:@"loadedTimeRanges"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidPlayToEndTimeNotification:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_avitem];
    }
    
    if (_avplayer) {
        [_avplayer addObserver:self
                    forKeyPath:@"rate"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __weak typeof(self) weakSelf = self;
        // 监听播放器的进度
        _avTimeObserver =
        [_avplayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                queue:queue
           usingBlock:^(CMTime time) {
               __strong typeof(weakSelf) strongSelf = (weakSelf);
               if (strongSelf.avitem.status == AVPlayerItemStatusReadyToPlay) {
                   CMTime currentTime = [strongSelf.avitem currentTime];
                   if (CMTIME_IS_VALID(currentTime)) {
                       CGFloat currentSecond = CMTimeGetSeconds(currentTime);
                       strongSelf.current = currentSecond;
                       CGFloat duration = CMTimeGetSeconds(strongSelf.avitem.duration);
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [strongSelf.controlView setCurrentTime:currentSecond
                                                          totalTime:duration];
//                           if (strongSelf.current < strongSelf.buffering) {
//                               if (strongSelf.avplayer.rate == 0) {
//                                   strongSelf->_status.buffering = NO;
//                                   strongSelf->_status.status = CNPlayStatusPause;
//                                   [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
//                               }else{
//                                   strongSelf->_status.buffering = NO;
//                                   strongSelf->_status.status = CNPlayStatusPlaying;
//                                   [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
//                               }
//                           }else{
//                               if (strongSelf.avplayer.rate == 0) {
//                                   strongSelf->_status.buffering = NO;
//                                   strongSelf->_status.status = CNPlayStatusPause;
//                                   [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
//                               }else{
//                                   strongSelf->_status.buffering = YES;
//                                   strongSelf->_status.status = CNPlayStatusPlaying;
//                                   [strongSelf.controlView layoutWithPlayStatus:strongSelf->_status];
//                               }
//                           }
                       });
                       //NSLog(@"PeriodicTimeObserverForInterval %f", currentSecond);
                   }
               }
           }];
    }
}

- (void)removeAVPlayerObserver
{
    if (_avplayer) {
        [_avplayer pause];
        [_avplayer removeTimeObserver:_avTimeObserver];
        [_avplayer removeObserver:self forKeyPath:@"rate"];
    }
    
    if (_avitem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:_avitem];
        
        [_avitem removeObserver:self
                     forKeyPath:@"status"];
        [_avitem  removeObserver:self
                      forKeyPath:@"playbackBufferEmpty"];
        [_avitem  removeObserver:self
                      forKeyPath:@"playbackLikelyToKeepUp"];
        [_avitem removeObserver:self
                     forKeyPath:@"loadedTimeRanges"];
    }
}

#pragma mark notification method
- (void)playerItemDidPlayToEndTimeNotification:(NSNotification *)notification
{
    if ([notification.object isEqual:_avitem]) {
        CMTime cmtime = [_avitem currentTime];
        cmtime.value = 0;
        [_avitem seekToTime:cmtime];
        
        _status.status = CNPlayStatusDone;
        [_controlView layoutWithPlayStatus:_status];
    }
}

- (void)applicationDidEnterBackground
{
}

- (void)applicationDidBecomeActive
{
    
}

#pragma mark kvo method
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([object isEqual:_avitem] && [keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        switch (playerItem.status) {
            case AVPlayerItemStatusReadyToPlay:{
                [_avplayer play];
                _duration = CMTimeGetSeconds(playerItem.duration);
                [_controlView setCurrentTime:0 totalTime:CMTimeGetSeconds(playerItem.duration)];
                
                //NSLog(@"AVPlayerItemStatusReadyToPlay");
                break;
            }
            case AVPlayerItemStatusUnknown:{
                //NSLog(@"AVPlayerItemStatusUnknown");
                break;
            }
            case AVPlayerItemStatusFailed:{
                NSLog(@"\n!!!!mp4 play error:%@!!!\n", _urlString);
                if (_avplayer && _avitem && _avasset) {
                    [self removeAVPlayerObserver];
                    _avitem = nil;
                    _avasset = nil;
                    _avplayer = nil;
                }
                _status.status = CNPlayStatusError;
                [_controlView layoutWithPlayStatus:_status];
                break;
            }
            default:
                break;
        }
    } else if ([object isEqual:_avitem]  && [keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //NSLog(@"playbackBufferEmpty");
    } else if ([object isEqual:_avitem] && [keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //NSLog(@"playbackLikelyToKeepUp");
    } else if ([object isEqual:_avitem] && [keyPath isEqualToString:@"loadedTimeRanges"]) {
        CMTimeRange timeRange = [[_avitem.loadedTimeRanges firstObject] CMTimeRangeValue];
        CMTime buffer = CMTimeAdd(timeRange.start, timeRange.duration);
        _buffering = CMTimeGetSeconds(buffer);
        CGFloat bufferPresent = _buffering/_duration;
        [_controlView setBufferingPresent:bufferPresent];
        //NSLog(@"loadedTimeRanges %f", _buffering);
        
//        if (_current/_duration < bufferPresent && _current != 0) {
//            _status.buffering = NO;
//            [_controlView layoutWithPlayStatus:_status];
//        }else{
//            _status.buffering = YES;
//            [_controlView layoutWithPlayStatus:_status];
//        }
    }else if ([object isEqual:_avplayer] && [keyPath isEqualToString:@"rate"]){
        CGFloat rate = [[change objectForKey:@"new"] floatValue];
        if(rate == 0.0){
            _status.status = CNPlayStatusPause;
            [_controlView layoutWithPlayStatus:_status];
            //NSLog(@"rate == 0");
        }else{
            _status.status = CNPlayStatusPlaying;
            [_controlView layoutWithPlayStatus:_status];
            //NSLog(@"rate != 0");
        }
    }
}

- (void)disableFullScreen
{
    [_controlView setFullScreenButtonHidden:YES];
}

- (void)setPlayNextType:(CNPlayNextType)type
{
    _status.playNext = type;
}

- (void)setSoundType:(CNSoundType)type
{
    _status.sound = type;
}

- (void)setCoverImageUrl:(NSString *)url
{
    [_controlView setCoverImageUrl:url];
}

- (void)prepareWithMP4Url:(NSString *)url
{
    [self reset];
    
    if (url == nil || [url isEqualToString:@""]) {
        return;
    }
    
    _urlString = url;
    _ytplayer.hidden = YES;
    _videoType = CNVideoTypeMP4;
}

- (void)prepareWithYoutubeUrl:(NSString *)url
{
    [self reset];
    
    if (url == nil || [url isEqualToString:@""]) {
        // 解析失败
        return;
    }
    
    //action 0x80,解析服务端再发的视频URL
    if ([url containsString:@"youtube.com"]) {
        //解析来自Youtube的视频，并适用Youtube helper播放（H5）
        NSURL *youtubeVideoURL = [NSURL URLWithString:url];
        NSString *queryString = youtubeVideoURL.query;
        if (!queryString || queryString.length == 0) {
            // 解析失败
            return;
        }
        
        NSString *youtubeId = @"";
        NSArray *componentsQuery = [queryString componentsSeparatedByString:@"="];
        NSString *flag = @"";
        for (int i = 0; i < componentsQuery.count; i++) {
            NSString *yid = [componentsQuery objectAtIndex:i];
            if ([flag isEqualToString:@"v"]) {
                youtubeId = yid;
                break;
            }
            flag = yid;
        }
        
        if (youtubeId.length == 0) {
            // 解析失败
            return;
        }
        
        _urlString = url;
        _youtubeId = youtubeId;
    
        _ytplayer.hidden = NO;
        _videoType = CNVideoTypeYoutube;
    }
}

- (void)setMaskViewHidden:(BOOL)hide
{
    _blackMaskView.hidden = hide;
}
- (void)setMaskViewAlpha:(CGFloat)alpha
{
    _blackMaskView.alpha = alpha;
}

#pragma mark - Public Method -
- (void)play
{
    if (_urlString == nil || [_urlString isEqualToString:@""]) {
        return;
    }
    if (_status.status == CNPlayStatusPlaying) {
        return;
    }
    if (_videoType == CNVideoTypeYoutube) {
        if (_status.status == CNPlayStatusPause
            || _status.status == CNPlayStatusDone) {
            [_ytplayer playVideo];
        }else{
            [_ytplayer loadWithYoutubeId:_youtubeId];
            
            _status.status = CNPlayStatusNone;
            [_controlView layoutWithPlayStatus:_status];
        }
    }else if (_videoType == CNVideoTypeMP4){
        if (_avitem
            && _avasset
            && _avplayer
            && (_status.status == CNPlayStatusPause
                || _status.status == CNPlayStatusDone)
            ) {
            // 继续播放或重播
            [_avplayer play];
        } else {
            //开始播放
            _avasset = [AVURLAsset assetWithURL:[NSURL URLWithString:_urlString]];
            _avitem = [AVPlayerItem playerItemWithAsset:_avasset];
            _avplayer = [AVPlayer playerWithPlayerItem:_avitem];
            [self addAVPlayerObserver];
            
            AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            playerLayer.player = _avplayer;
            
            _status.status = CNPlayStatusNone;
            [_controlView layoutWithPlayStatus:_status];
        }
        _avplayer.volume = 0;
    }
}

- (void)pause
{
    if (_status.status == CNPlayStatusPause) {
        return;
    }
    
    if (_videoType == CNVideoTypeYoutube) {
        [_ytplayer pauseVideo];
    }
    
    if (_avplayer
        && _avitem
        && _avasset) {
        [_avplayer pause];
    }
}

- (void)seekToTime:(CMTime)time
{
    if (_ytplayer && _videoType == CNVideoTypeYoutube) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        [_ytplayer seekToSeconds:currentTime];
    }
    
    if (_avitem) {
        __weak typeof(self) weakSelf = self;
        [_avitem seekToTime:time
          completionHandler:^(BOOL finished) {
              __strong __typeof(weakSelf)strongSelf = weakSelf;
              if (finished) {
                  [strongSelf play];
              }
          }];
    }
}

#pragma mark - Private Method -
- (void)reset
{
    // 重置之前的播放状态
    _urlString = @"";
    if (_videoType == CNVideoTypeYoutube && _ytplayer) {
        [_ytplayer stopVideo];
        _youtubeId = @"";
    }
    
    if (_avplayer && _avitem && _avasset) {
        [_avplayer pause];
        [_avplayer seekToTime:CMTimeMake(0, 1)];
        [self removeAVPlayerObserver];
        _avitem = nil;
        _avasset = nil;
        _avplayer = nil;
    }
    _blackMaskView.alpha = 0;
    _blackMaskView.hidden = YES;
    _status.status = CNPlayStatusNone;
    [_controlView layoutWithPlayStatus:_status];
}

#pragma mark - CNVideoControlViewDelegate
- (void)videoPlayAction
{
    [self play];
}
- (void)videoPauseAction
{
    [self pause];
}
- (void)videoReplayAction
{
    [self play];
}

- (void)videoTryReplayAction
{
    [self play];
}
- (void)videoPlayNextAction
{
    
}
- (void)videoFullScreenAction
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect rectInWindow = [_superView convertRect:self.frame
                                               toView:window];
    [window addSubview:self];
    self.frame = rectInWindow;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    _controlView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.frame = window.bounds;
    }completion:^(BOOL finished) {
        if (finished) {
            [self layoutIfNeeded];
            _controlView.hidden = NO;
            _status.display = CNDisplayTypeFullScreen;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }];
}
- (void)videoSmallScreenAction
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect rectInSuperView = [window convertRect:self.frame
                                       toView:_superView];
    [_superView addSubview:self];
    self.frame = rectInSuperView;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    _controlView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = _initialFrame;
    }completion:^(BOOL finished) {
        if (finished) {
            [self layoutIfNeeded];
            _controlView.hidden = NO;
            _status.display = CNDisplayTypeSmallScreen;
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _ytplayer.frame = self.bounds;
    _controlView.frame = self.bounds;
}

- (void)videoWillSeek{
    [self pause];
}
- (void)videoDidSeekTo:(CGFloat)second{
    [self seekToTime:CMTimeMake(second, 1)];
}
- (void)videoSeekingTo:(CGFloat)second{
}

- (void)didSelectVideoPlayer
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedVideoPlayView)]) {
        [_delegate didSelectedVideoPlayView];
    }
}
@end
