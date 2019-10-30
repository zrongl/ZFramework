//
//  CNYoutubeVideoPlayerView.h
//  CMInstanews
//
//  Created by 唱宏博 on 16/5/16.
//  Copyright © 2016年 cm. All rights reserved.
//
//  用于对接Youtube视频
//

#import <UIKit/UIKit.h>

/** These enums represent the state of the current video in the player. */
typedef NS_ENUM(NSInteger, CNYTPlayerState) {
    kCNYTPlayerStateUnstarted,
    kCNYTPlayerStateEnded,
    kCNYTPlayerStatePlaying,
    kCNYTPlayerStatePaused,
    kCNYTPlayerStateBuffering,
    kCNYTPlayerStateQueued,
    kCNYTPlayerStateUnknown
};

typedef NS_ENUM(NSInteger, CNYTPlayerError) {
    kCNYTPlayerErrorInvalidParam,
    kCNYTPlayerErrorHTML5Error,
    kCNYTPlayerErrorVideoNotFound,
    kCNYTPlayerErrorNotEmbeddable,
    kCNYTPlayerErrorUnknown
};

@interface CNYoutubeVideoPlayerView : UIView

@property (nonatomic , readonly) NSTimeInterval current;

//初始化回调block
@property (nonatomic, copy) void (^youtubeVideoPlayerInitBlock)(CNYoutubeVideoPlayerView *playerView);
//播放回调block
@property (nonatomic, copy) void (^youtubeVideoPlayerStateBlock)(CNYoutubeVideoPlayerView *playerView, CNYTPlayerState state);
//时长回调block
@property (nonatomic, copy) void (^youtubeVideoPlayerDidPlayTimeBlock)(CNYoutubeVideoPlayerView *playerView);
//错误回调block
@property (nonatomic, copy) void (^youtubeVideoPlayerErrorBlock)(CNYoutubeVideoPlayerView *playerView, CNYTPlayerError errorType);

#pragma mark - Player methods
- (void)loadWithYoutubeId:(NSString *)videoid;
- (void)playVideo;
- (void)stopVideo;
- (void)pauseVideo;
- (void)seekToSeconds:(CGFloat)seconds;
- (void)hidenYTBPlayer:(BOOL)isToHide;
#pragma mark - Playback status
- (float)videoLoadedFraction;
- (CNYTPlayerState)playerState;
- (float)currentTime;
- (float)playBackRate;
#pragma mark - Retrieving video information
- (NSTimeInterval)duration;
- (NSURL *)videoUrl;
- (NSString *)videoEmbedCode;
@end
