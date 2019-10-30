//
//  CNVideoPlayerView.h
//  CMInstanews
//
//  Created by ronglei on 2017/6/23.
//  Copyright © 2017年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define PlayNextVideoNotification @"PlayNextVideoNotification"

typedef NS_ENUM(NSInteger, CNPlayStatus){
    CNPlayStatusNone        = (0),
    CNPlayStatusPlaying     = (1),
    CNPlayStatusPause       = (2),
    CNPlayStatusError       = (4),
    CNPlayStatusDone        = (3),
};

typedef NS_ENUM (NSInteger, CNDisplayType){
    CNDisplayTypeFullScreen,
    CNDisplayTypeSmallScreen,
};

typedef NS_ENUM(NSInteger, CNPlayNextType) {
    CNPlayNextTypeDelay,    // 延迟播放下一个
    CNPlayNextTypeDisable,  // 不播放下一个 显示重播按钮
    CNPlayNextTypeDirectly  // 立即播放下一个
};

typedef NS_ENUM(NSInteger, CNSoundType) {
    CNSoundTypeNone,
    CNSoundTypeControl
};

typedef struct {
    BOOL buffering;
    CNSoundType sound;
    CNPlayStatus status;
    CNDisplayType display;
    CNPlayNextType playNext;
} CNPlayerStatus;

@protocol CNVideoPlayerViewDelegate <NSObject>

- (void)didSelectedVideoPlayView;

@end

@interface CNVideoPlayerView : UIView

@property (nonatomic, assign) UIView *superView;
@property (nonatomic, assign, readonly) CNPlayerStatus status;

@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, weak) id <CNVideoPlayerViewDelegate>delegate;

// 全屏切换需要通过initWithFrame给出确定的frame，同时指定superView
- (void)disableFullScreen;
- (void)setSoundType:(CNSoundType)type;
- (void)setPlayNextType:(CNPlayNextType)type;

- (void)play;
- (void)pause;
- (void)reset;

- (void)setCoverImageUrl:(NSString *)url;
- (void)prepareWithMP4Url:(NSString *)url;
- (void)prepareWithYoutubeUrl:(NSString *)url;

- (void)setMaskViewHidden:(BOOL)hide;
- (void)setMaskViewAlpha:(CGFloat)alpha;
@end
