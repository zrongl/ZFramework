//
//  CNVideoControlView.h
//  CMInstanews
//
//  Created by ronglei on 2017/6/23.
//  Copyright © 2017年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNVideoPlayerView.h"

@protocol CNVideoControlViewDelegate <NSObject>

- (void)videoPlayAction;
- (void)videoPauseAction;
- (void)videoReplayAction;
- (void)videoPlayNextAction;
- (void)videoTryReplayAction;
- (void)videoFullScreenAction;
- (void)videoSmallScreenAction;
- (void)videoWillSeek;
- (void)videoSeekingTo:(CGFloat)second;
- (void)videoDidSeekTo:(CGFloat)second;

- (void)didSelectVideoPlayer;
@end

@interface CNVideoControlView : UIView

@property (nonatomic, weak) id <CNVideoControlViewDelegate>deleate;

- (void)setTitle:(NSString *)title;
- (void)setCoverImageUrl:(NSString *)url;
- (void)setBlackMaskViewHidden:(BOOL)hide;
- (void)setBlackMaskViewAlpha:(CGFloat)alpha;

- (void)setBufferingPresent:(CGFloat)buffer;
- (void)setCurrentTime:(CGFloat)current totalTime:(CGFloat)total;

- (void)setFullScreenButtonHidden:(BOOL)hide;
- (void)layoutWithPlayStatus:(CNPlayerStatus)status;

@end

@interface CNVideoLoadingView : UIView

@end

