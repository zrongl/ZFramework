//
//  CNYoutubeVideoPlayerView.m
//  CMInstanews
//
//  Created by 唱宏博 on 16/5/16.
//  Copyright © 2016年 cm. All rights reserved.
//

#import "CNYoutubeVideoPlayerView.h"
#import "YTPlayerView.h"

@interface CNYoutubeVideoPlayerView() <YTPlayerViewDelegate> {
    YTPlayerView *ytplayerView;
    
    BOOL stoped;
    
    NSTimeInterval _current;
}

@end

@implementation CNYoutubeVideoPlayerView
@synthesize current = _current;

#pragma mark -
#pragma mark Lifecycle methods

- (void)hidenYTBPlayer:(BOOL)isToHide{
    
    if(isToHide)[self pauseVideo];
    [self setHidden:isToHide];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    stoped = NO;
    self.backgroundColor = [UIColor blackColor];
    
    ytplayerView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    ytplayerView.backgroundColor = [UIColor blackColor];
    ytplayerView.delegate = self;
    [self addSubview:ytplayerView];
    ytplayerView.userInteractionEnabled = NO;
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    ytplayerView.frame = self.bounds;
}

- (void)layoutSubviews {
    ytplayerView.frame = self.bounds;
}

- (void)dealloc {
    [ytplayerView stopVideo];
    NSLog(@"%s",__func__);
}
#pragma mark -
#pragma mark Player methods
- (void)loadWithYoutubeId:(NSString *)videoid {
    if (!videoid || videoid.length == 0) {
        //视频信息无效
        return;
    }
    
    stoped = NO;
    
    NSDictionary *playerVars = @{
//                                 @"autoplay" : @"1",
                                 @"controls" : @"0",
                                 @"playsinline" : @"1",
//                                 @"autohide" : @"1",
                                 @"showinfo" : @"0",
                                 @"modestbranding" : @"0",
                                 };
    
    [ytplayerView loadWithVideoId:videoid playerVars:playerVars];
}

- (void)playVideo {
    [ytplayerView playVideo];
}

- (void)stopVideo {
    stoped = YES;
    [ytplayerView stopVideo];
}

- (void)pauseVideo {
    [ytplayerView pauseVideo];
}

- (void)seekToSeconds:(CGFloat)seconds {
    [ytplayerView seekToSeconds:seconds allowSeekAhead:YES];
    [ytplayerView playVideo];
}

#pragma mark - Playback status
- (float)videoLoadedFraction {
    return [ytplayerView videoLoadedFraction];
}

- (CNYTPlayerState)playerState {
    return (CNYTPlayerState)[ytplayerView playerState];
}

- (float)currentTime {
    return [ytplayerView currentTime];
}

- (float)playBackRate{
    
    return [ytplayerView playbackRate];
}

#pragma mark - Retrieving video information
- (NSTimeInterval)duration {
    return [ytplayerView duration];
}

- (NSURL *)videoUrl {
    return [ytplayerView videoUrl];
}

- (NSString *)videoEmbedCode {
    return [ytplayerView videoEmbedCode];
}

#pragma mark -
#pragma mark YTPlayerViewDelegate methods
/**
 * Invoked when the player view is ready to receive API calls.
 *
 * @param playerView The YTPlayerView instance that has become ready.
 */
- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView {
    //    if (stoped) {
    //        CNYTPlayerState cnstate = (CNYTPlayerState)kYTPlayerStateUnstarted;
    //        if (self.youtubeVideoPlayerStateBlock) {
    //            self.youtubeVideoPlayerStateBlock(self,cnstate);
    //        }
    //    }else {
    [playerView playVideo];
    if (self.youtubeVideoPlayerInitBlock) {
        self.youtubeVideoPlayerInitBlock(self);
        //        }
    }
}

/**
 * Callback invoked when player state has changed, e.g. stopped or started playback.
 *
 * @param playerView The YTPlayerView instance where playback state has changed.
 * @param state YTPlayerState designating the new playback state.
 */
- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    
    switch (state) {
        case kYTPlayerStateUnstarted:
//            NSLog(@"kYTPlayerStateUnstarted");
            break;
        case kYTPlayerStateEnded:
//            NSLog(@"kYTPlayerStateEnded");
            break;
        case kYTPlayerStatePlaying:
//            NSLog(@"kYTPlayerStatePlaying");
            break;
        case kYTPlayerStatePaused:
//            NSLog(@"kYTPlayerStatePaused");
            break;
        case kYTPlayerStateBuffering:
//            NSLog(@"kYTPlayerStateBuffering");
            break;
        case kYTPlayerStateQueued:
//            NSLog(@"kYTPlayerStateQueued");
            break;
        case kYTPlayerStateUnknown:
//            NSLog(@"kYTPlayerStateUnknown");
            break;
            
        default:
            break;
    }
    
    CNYTPlayerState cnstate = (CNYTPlayerState)state;
    if (self.youtubeVideoPlayerStateBlock) {
        self.youtubeVideoPlayerStateBlock(self,cnstate);
    }
}

/**
 * Callback invoked when playback quality has changed.
 *
 * @param playerView The YTPlayerView instance where playback quality has changed.
 * @param quality YTPlaybackQuality designating the new playback quality.
 */
- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality {
    
}

/**
 * Callback invoked when an error has occured.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param error YTPlayerError containing the error state.
 */
- (void)playerView:(nonnull YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    
    if (self.youtubeVideoPlayerErrorBlock) {
        self.youtubeVideoPlayerErrorBlock(self, (CNYTPlayerError)error);
    }
    
    switch (error) {
        case kYTPlayerErrorInvalidParam:
//            NSLog(@"kYTPlayerErrorInvalidParam");
            break;
        case kYTPlayerErrorHTML5Error:
//            NSLog(@"kYTPlayerErrorHTML5Error");
            break;
        case kYTPlayerErrorVideoNotFound:
//            NSLog(@"kYTPlayerErrorVideoNotFound");
            break;
        case kYTPlayerErrorNotEmbeddable:
//            NSLog(@"kYTPlayerErrorNotEmbeddable");
            break;
        case kYTPlayerErrorUnknown:
//            NSLog(@"kYTPlayerErrorUnknown");
            break;
            
        default:
            break;
    }
}

/**
 * Callback invoked frequently when playBack is plaing.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param playTime float containing curretn playback time.
 */
- (void)playerView:(nonnull YTPlayerView *)playerView didPlayTime:(float)playTime {
    _current = playTime;
    
    if (self.youtubeVideoPlayerDidPlayTimeBlock) {
        self.youtubeVideoPlayerDidPlayTimeBlock(self);
    }
}

/**
 * Callback invoked when setting up the webview to allow custom colours so it fits in
 * with app color schemes. If a transparent view is required specify clearColor and
 * the code will handle the opacity etc.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @return A color object that represents the background color of the webview.
 */
- (nonnull UIColor *)playerViewPreferredWebViewBackgroundColor:(nonnull YTPlayerView *)playerView {
    return [UIColor blackColor];
}

/**
 * Callback invoked when initially loading the YouTube iframe to the webview to display a custom
 * loading view while the player view is not ready. This loading view will be dismissed just before
 * -playerViewDidBecomeReady: callback is invoked. The loading view will be automatically resized
 * to cover the entire player view.
 *
 * The default implementation does not display any custom loading views so the player will display
 * a blank view with a background color of (-playerViewPreferredWebViewBackgroundColor:).
 *
 * Note that the custom loading view WILL NOT be displayed after iframe is loaded. It will be
 * handled by YouTube iframe API. This callback is just intended to tell users the view is actually
 * doing something while iframe is being loaded, which will take some time if users are in poor networks.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @return A view object that will be displayed while YouTube iframe API is being loaded.
 *         Pass nil to display no custom loading view. Default implementation returns nil.
 */
- (nullable UIView *)playerViewPreferredInitialLoadingView:(nonnull YTPlayerView *)playerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
