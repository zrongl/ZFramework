//
//  CNVideoControlView.m
//  CMInstanews
//
//  Created by ronglei on 2017/6/23.
//  Copyright © 2017年 cm. All rights reserved.
//

#import "CNVideoControlView.h"
#import "CNVolumeSlider.h"
#import "CNProgressSlider.h"
#import "UIImageView+WebCache.h"

#import "Masonry.h"

@interface CNVideoControlView()<CNProgressSliderDelegate>

@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, strong) UIButton *noSoundButton;
@property (nonatomic, strong) NSString *coverImageUrl;
@property (nonatomic, strong) UIControl *playErrorView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) CNVolumeSlider *volumeSlider;
@property (nonatomic, strong) CNVideoLoadingView *loadingView;

@property (nonatomic, strong) UIControl *containerView;
@property (nonatomic, strong) UIControl *controlView;//播放按钮 时间轴 全屏按钮 （全屏时：返回按钮 标题）
@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *playButton;
@property (nonatomic, strong) UILabel   *totalTimeLabel;
@property (nonatomic, strong) UILabel   *currentTimeLabel;
@property (nonatomic, strong) UIButton  *fullScreenButton;
@property (nonatomic, strong) CNProgressSlider  *playProgressSlider;

@property (nonatomic, strong) UIControl *playDoneView;
@property (nonatomic, strong) UIButton  *replayButton;
@property (nonatomic, strong) UIButton  *playNextButton;
@property (nonatomic, strong) UILabel   *playTipLable;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, assign) CGFloat   duration;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) NSTimer   *playNextTimer;

@end

@implementation CNVideoControlView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImageView];
        
        _volumeSlider = [[CNVolumeSlider alloc] init];
        _volumeSlider.layer.opacity = 0.0;
        [self addSubview:_volumeSlider];
        [_volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.size.mas_equalTo(CGSizeMake(kCNVolumeWidth, kCNVolumeHeight));
            make.top.mas_equalTo((SCREEN_WIDTH - kCNVolumeHeight)/2);
        }];
        
        [self setupControlView];
        
        _noSoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noSoundButton.hidden = YES;
        _noSoundButton.frame = CGRectMake(self.frame.size.width - 39.0, self.frame.size.height - 39.0, 26.0, 26.0);
        _noSoundButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _noSoundButton.layer.cornerRadius = 13;
        _noSoundButton.layer.borderWidth = 0.5;
        _noSoundButton.layer.borderColor = RGBA(255, 255, 255, 0.32).CGColor;
        _noSoundButton.backgroundColor = RGBA(0, 0, 0, 0.24);
        [_noSoundButton setTitle:@"N" forState:UIControlStateNormal];
        [_noSoundButton addTarget:self action:@selector(noSoundButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noSoundButton];
        
        [self setupPlayDoneView];
        
        _loadingView = [[CNVideoLoadingView alloc] initWithFrame:self.bounds];
        _loadingView.hidden = YES;
        [self addSubview:_loadingView];
        
        [self setupPlayErrorView];
        
        NSString *volumeNotify = @"AVSystemController_SystemVolumeDidChangeNotification";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeDidChange:)
                                                     name:volumeNotify
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupControlView
{
    _containerView = [[UIControl alloc] initWithFrame:self.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    [_containerView addTarget:self
                       action:@selector(controlViewTouchAction)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_containerView];
    
    _controlView = [[UIControl alloc] init];
    [_controlView addTarget:self
                    action:@selector(hideControlView)
           forControlEvents:UIControlEventTouchUpInside];
    _controlView.backgroundColor = [UIColor clearColor];
    _controlView.alpha = 0;
    [_containerView addSubview:_controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_containerView);
    }];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_pause"]
                           forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_pause_pressed"]
                           forState:UIControlStateHighlighted];
    [_playButton addTarget:self
                    action:@selector(playButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_controlView);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    _currentTimeLabel = [[UILabel alloc] init];
    [_currentTimeLabel setText:@"00:00"];
    _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    _currentTimeLabel.font = [UIFont systemFontOfSize:12];
//    _currentTimeLabel.font = [[CNAppContext sharedContext] regularFontWithSize:12];
    [_currentTimeLabel setTextColor:[UIColor whiteColor]];
    [_controlView addSubview:_currentTimeLabel];
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_controlView).offset(2);
        make.bottom.mas_equalTo(_controlView).with.mas_offset(-11.0);
        make.width.mas_equalTo(45.0);
        make.height.mas_equalTo(14.0);
    }];
    
    _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_fullscreen"]
                                 forState:UIControlStateNormal];
    [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_fullscreen_pressed"]
                                 forState:UIControlStateHighlighted];
    [_fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:_fullScreenButton];
    [_fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_controlView).with.offset(-2);
        make.centerY.equalTo(_currentTimeLabel);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    _totalTimeLabel = [[UILabel alloc] init];
    _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
    [_totalTimeLabel setText:@"00:00"];
    _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
    _totalTimeLabel.font = [UIFont systemFontOfSize:12];
//    _totalTimeLabel.font = [[CNAppContext sharedContext] regularFontWithSize:12];
    [_totalTimeLabel setTextColor:[UIColor whiteColor]];
    [_controlView addSubview:_totalTimeLabel];
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_fullScreenButton.mas_left);
        make.centerY.mas_equalTo(_currentTimeLabel);
        make.size.mas_equalTo(CGSizeMake(39.0, 14.0));
    }];
    
    _playProgressSlider = [[CNProgressSlider alloc] init];
    _playProgressSlider.sliderDelegate = self;
    [_controlView addSubview:_playProgressSlider];
    [_playProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentTimeLabel.mas_right).with.offset(14.0);
        make.right.equalTo(_totalTimeLabel.mas_left).with.offset(-14.0);
        make.centerY.equalTo(_currentTimeLabel);
        make.height.mas_equalTo(20.0);
    }];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.hidden = YES;
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_video_back"]
                           forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_video_back_pressed"]
                           forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_controlView).offset(8.0);
        make.top.equalTo(_controlView).offset(11.0);
        make.width.height.mas_equalTo(35.0);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.hidden = YES;
//    [_titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [_titleLabel setFont:[[CNAppContext sharedContext] regularFontWithSize:16]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_controlView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backButton.mas_right).with.offset(3.0);
        make.centerY.equalTo(_backButton);
        make.right.equalTo(_controlView).with.offset(-24.0);
    }];
}

- (void)setupPlayDoneView
{
    _playDoneView = [[UIControl alloc] initWithFrame:self.bounds];
    _playDoneView.hidden = YES;
    _playDoneView.backgroundColor = [UIColor clearColor];
    [_playDoneView addTarget:self action:@selector(playDoneViewTouchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playDoneView];
    
    _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replayButton setImage:[UIImage imageNamed:@"btn_fullscreen_replay"]
                   forState:UIControlStateNormal];
    [_replayButton setImage:[UIImage imageNamed:@"btn_fullscreen_replay_pressed"]
                   forState:UIControlStateHighlighted];
    [_replayButton addTarget:self
                      action:@selector(replayButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [_playDoneView addSubview:_replayButton];
    [_replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playDoneView).offset(-84);
        make.centerY.equalTo(_playDoneView);
    }];
    
    _playNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playNextButton setImage:[UIImage imageNamed:@"btn_video_next"]
                     forState:UIControlStateNormal];
    [_playNextButton setImage:[UIImage imageNamed:@"btn_video_next_pressed"]
                     forState:UIControlStateHighlighted];
    [_playNextButton addTarget:self action:@selector(playNextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playDoneView addSubview:_playNextButton];
    [_playNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playDoneView).offset(84);
        make.centerY.equalTo(_playDoneView);
    }];
    
    
    _playTipLable = [[UILabel alloc] init];
    _playTipLable.textColor = [UIColor whiteColor];
    [_playTipLable setTextAlignment:NSTextAlignmentCenter];
    [_playTipLable setFont:[UIFont systemFontOfSize:16]];
//    [_playTipLable setFont:[[CNAppContext sharedContext] regularFontWithSize:16]];
    [_playDoneView addSubview:_playTipLable];
    [_playTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_replayButton.mas_bottom).offset(20);
        make.left.equalTo(_playDoneView).with.offset(12);
        make.right.equalTo(_playDoneView).with.offset(-12);
    }];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.width/2 + 52.0, self.height/2 - 36.0, 72.0, 72.0)];
    _circleLayer.path = path.CGPath;
    _circleLayer.strokeEnd = 0.0f;
    _circleLayer.strokeStart = 0.0f;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.lineWidth = 2.0f;
    _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    [_playDoneView.layer addSublayer:_circleLayer];
}

- (void)setupPlayErrorView
{
    _playErrorView = [[UIControl alloc] initWithFrame:self.bounds];
    _playErrorView.hidden = YES;
    _playErrorView.backgroundColor = [UIColor blackColor];
    [_playErrorView addTarget:self
                       action:@selector(tryReplayAction)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playErrorView];
    
    UIView *errorContainerView = [[UIView alloc] init];
    [errorContainerView setBackgroundColor:[UIColor blackColor]];
    errorContainerView.userInteractionEnabled = NO;
    [_playErrorView addSubview:errorContainerView];
    [errorContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_playErrorView);
        make.width.mas_equalTo(300.0);
        make.height.mas_equalTo(120.0);
    }];
    UIImageView *errorImageView = [[UIImageView alloc] init];
    [errorImageView setImage:[UIImage imageNamed:@"illustration_video_erro_white"]];
    [errorContainerView addSubview:errorImageView];
    [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorContainerView);
        make.centerX.equalTo(errorContainerView);
        make.size.mas_equalTo(CGSizeMake(90, 60));
    }];
    
    UILabel *errorLabel = [[UILabel alloc] init];
    [errorContainerView addSubview:errorLabel];
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [errorLabel setAdjustsFontSizeToFitWidth:YES];
    [errorLabel setTextColor:[UIColor whiteColor]];
    [errorLabel setFont:[UIFont systemFontOfSize:12]];
//    [errorLabel setFont:[[CNAppContext sharedContext] regularFontWithSize:12]];
    [errorLabel setText:@"Play failed，tap to retry"];
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorImageView.mas_bottom).with.offset(16);
        make.left.and.right.equalTo(errorContainerView);
        make.bottom.equalTo(errorContainerView);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _circleLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.width/2 + 48.0, self.height/2 - 36.0, 72.0, 72.0)];
    _circleLayer.path = path.CGPath;
    _loadingView.frame = self.bounds;
    _playDoneView.frame = self.bounds;
    _blackMaskView.frame = self.bounds;
    _playErrorView.frame = self.bounds;
    _containerView.frame = self.bounds;
    _coverImageView.frame = self.bounds;
    _noSoundButton.frame = CGRectMake(self.frame.size.width - 39.0, self.frame.size.height - 39.0, 26.0, 26.0);
}

#pragma mark - public method

- (NSString *)getVideoTime:(CGFloat)second {
    
    NSString *time = @"00:00";
    int seconds = (int)second % 60;
    int minutes = ((int)second / 60) % 60;
    int hours = (int)second / 3600;
    if(hours > 0){
        time = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }else{
        time = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    return time;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setCoverImageUrl:(NSString *)url
{
    _coverImageUrl = url;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setBufferingPresent:(CGFloat)buffer
{
    _playProgressSlider.middleValue = buffer;
}

- (void)setCurrentTime:(CGFloat)current totalTime:(CGFloat)total
{
    if (_duration != total) {
        _duration = total;
        _totalTimeLabel.text = [self getVideoTime:total];
    }
    
    _currentTimeLabel.text = [self getVideoTime:current];
    
    CGFloat currentPresent = 0;
    if (total > 0 && current < total) {
        currentPresent = current/total;
    }
    _playProgressSlider.value = currentPresent;
}

- (void)setBlackMaskViewHidden:(BOOL)hide
{
    _blackMaskView.hidden = hide;
}
- (void)setBlackMaskViewAlpha:(CGFloat)alpha
{
    _blackMaskView.alpha = alpha;
}

- (void)setFullScreenButtonHidden:(BOOL)hide
{
    if (hide) {
        _fullScreenButton.alpha = 0;
        [_fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5);
        }];
    }else{
        _fullScreenButton.alpha = 1;
        [_fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(35);
        }];
    }
    
}

- (void)layoutWithPlayStatus:(CNPlayerStatus)status
{
    _loadingView.hidden = YES;
    _volumeSlider.hidden = YES;
    _playDoneView.hidden = YES;
    _noSoundButton.hidden = YES;
    _playErrorView.hidden = YES;
    _coverImageView.hidden = YES;
    
    switch (status.status) {
        case CNPlayStatusNone:
            _loadingView.hidden = NO;
            if (_coverImageUrl) {
                _coverImageView.hidden = NO;
            }
            
            _controlView.alpha = 0;
            break;
        case CNPlayStatusPlaying:
            
            [self setPlayButtonSelected:NO];
            if (status.sound == CNSoundTypeControl) {
                _noSoundButton.hidden = NO;
            }
//            _loadingView.hidden = !status.buffering;
            break;
        case CNPlayStatusPause:
            [self setPlayButtonSelected:YES];
//            _loadingView.hidden = !status.buffering;
            break;
        case CNPlayStatusError:
            _playErrorView.hidden = NO;
            break;
        case CNPlayStatusDone:
            _playDoneView.hidden = NO;
            if (_coverImageUrl) {
                _coverImageView.hidden = NO;
            }
            
            _controlView.alpha = 0;
            [self setPlayButtonSelected:YES];
            
            if (status.playNext == CNPlayNextTypeDisable) {
                [_replayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_playDoneView);
                }];
                [_replayButton setImage:[UIImage imageNamed:@"btn_list_replay"]
                               forState:UIControlStateNormal];
                [_replayButton setImage:[UIImage imageNamed:@"btn_list_replay"]
                               forState:UIControlStateHighlighted];
                _circleLayer.hidden = YES;
                _playTipLable.hidden = YES;
                _playNextButton.hidden = YES;
            }else if (status.playNext == CNPlayNextTypeDelay){
                [_replayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_playDoneView).offset(-84);
                }];
                [_replayButton setImage:[UIImage imageNamed:@"btn_fullscreen_replay"]
                               forState:UIControlStateNormal];
                [_replayButton setImage:[UIImage imageNamed:@"btn_fullscreen_replay_pressed"]
                               forState:UIControlStateHighlighted];
                _circleLayer.hidden = NO;
                _playTipLable.hidden = NO;
                _playNextButton.hidden = NO;
                
                [self drawCircle];
                [self setupPlayNextTimer];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:PlayNextVideoNotification object:nil];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - private method
- (void)drawCircle
{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 5.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = YES;
    [_circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

- (void)setPlayButtonSelected:(BOOL)selected
{
    _playButton.selected = selected;
    if (selected) {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_play"]
                               forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_play_pressed"]
                               forState:UIControlStateHighlighted];
    }else{
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_pause"]
                               forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_pause_pressed"]
                               forState:UIControlStateHighlighted];
    }
}

- (void)setFullScreenButtonSelected:(BOOL)selected
{
    _fullScreenButton.selected = selected;
    if (selected) {
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_halfscreen"]
                                     forState:UIControlStateNormal];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_halfscreen_pressed"]
                                     forState:UIControlStateHighlighted];
    }else{
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_fullscreen"]
                                     forState:UIControlStateNormal];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_video_fullscreen_pressed"]
                                     forState:UIControlStateHighlighted];
    }
}

- (void)setNoSoundButtonSelected:(BOOL)selected
{
    _noSoundButton.selected = selected;
    if (selected) {
        [_noSoundButton setTitle:@"M"
                        forState:UIControlStateNormal];
    }else{
        [_noSoundButton setTitle:@"S"
                        forState:UIControlStateNormal];
    }
}

#pragma mark - button action
- (void)playDoneViewTouchAction
{
    if (_deleate && [_deleate respondsToSelector:@selector(didSelectVideoPlayer)]) {
        [_deleate didSelectVideoPlayer];
    }
}

- (void)controlViewTouchAction
{
    if (_noSoundButton.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            _controlView.alpha = 1;
        }];
        [self delayHideControlView];
    }else{
        if (_deleate && [_deleate respondsToSelector:@selector(didSelectVideoPlayer)]) {
            [_deleate didSelectVideoPlayer];
        }
    }
}

- (void)hideControlView
{
    [UIView animateWithDuration:0.3 animations:^{
        _controlView.alpha = 0;
    }];
}

- (void)delayHideControlView
{
    [self.class cancelPreviousPerformRequestsWithTarget:self
                                               selector:@selector(hideControlView)
                                                 object:nil];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:3];
}

- (void)noSoundButtonAction:(UIButton *)button
{
    if (button.selected) {
        [self setNoSoundButtonSelected:NO];
    }else{
        [self setNoSoundButtonSelected:YES];
    }
}

- (void)playButtonAction:(UIButton *)button
{
    if (button.selected) {
        if (_deleate && [_deleate respondsToSelector:@selector(videoPlayAction)]) {
            [_deleate videoPlayAction];
        }
    }else{
        if (_deleate && [_deleate respondsToSelector:@selector(videoPauseAction)]) {
            [_deleate videoPauseAction];
        }
    }
    [self delayHideControlView];
}

- (void)fullScreenButtonAction:(UIButton *)button
{
    if (button.selected) {
        [self backButtonAction:nil];
    }else{
        [self setFullScreenButtonSelected:YES];
        _backButton.hidden = NO;
        _titleLabel.hidden = NO;
        _volumeSlider.hidden = NO;
        if (_deleate && [_deleate respondsToSelector:@selector(videoFullScreenAction)]) {
            [_deleate videoFullScreenAction];
        }
    }
    [self delayHideControlView];
}

- (void)backButtonAction:(UIButton *)button
{
    _backButton.hidden = YES;
    _titleLabel.hidden = YES;
    _volumeSlider.hidden = YES;
    [self setFullScreenButtonSelected:NO];
    if (_deleate && [_deleate respondsToSelector:@selector(videoSmallScreenAction)]) {
        [_deleate videoSmallScreenAction];
    }
    [self delayHideControlView];
}

- (void)replayButtonAction:(UIButton *)button
{
    if (_deleate && [_deleate respondsToSelector:@selector(videoReplayAction)]) {
        [_deleate videoReplayAction];
    }
}

- (void)tryReplayAction
{
    if (_deleate && [_deleate respondsToSelector:@selector(videoTryReplayAction)]) {
        [_deleate videoTryReplayAction];
    }
}

- (void)playNextButtonAction:(UIButton *)button
{
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayNextVideoNotification object:nil];
}

- (void)volumeDidChange:(NSNotification *)volumeNotification{
    
    NSString * style = [volumeNotification.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    CGFloat value = [[volumeNotification.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if ([style isEqualToString:@"Audio/Video"]){
        [_volumeSlider updateVolume:value];
        [UIView animateWithDuration:0.3 animations:^{
            _volumeSlider.alpha = 1;
        }];
        [self.class cancelPreviousPerformRequestsWithTarget:self
                                                   selector:@selector(hideVolumeSlider)
                                                     object:nil];
        [self performSelector:@selector(hideControlView) withObject:nil afterDelay:3];
    }
}

- (void)hideVolumeSlider
{
    [UIView animateWithDuration:0.3 animations:^{
        _volumeSlider.alpha = 0;
    }];
}

#pragma mark -
#pragma mark playNextTimer
- (void)setupPlayNextTimer{
    [self invalidateTimer];
    self.timeCount = 6;
    self.playNextTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(timerAction)
                                                        userInfo:nil
                                                         repeats:YES];
    [self.playNextTimer fire];
}

- (void)timerAction{
    self.timeCount--;
//    self.playTipLable.text = [NSString stringWithFormat:[CNLocalStringUtil localizedText:@"Autoplay the next video in %1d seconds"], self.timeCount];
    self.playTipLable.text = [NSString stringWithFormat:@"Autoplay the next video in %ld seconds", (long)_timeCount];
    if(self.timeCount == 0){
        [self invalidateTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayNextVideoNotification object:nil];
    }
}

- (void)invalidateTimer
{
    if(self.playNextTimer){
        [self.playNextTimer invalidate];
        self.playNextTimer = nil;
        self.timeCount = 0;
    }
}

#pragma mark - CNProgressSliderDelegate
- (void)sliderDragging:(CNProgressSlider *)slider{
    if (_deleate && [_deleate respondsToSelector:@selector(videoSeekingTo:)]) {
        [_deleate videoSeekingTo:slider.value*_duration];
    }
}
- (void)sliderDidEndDragging:(CNProgressSlider *)slider{
    if (_deleate && [_deleate respondsToSelector:@selector(videoDidSeekTo:)]) {
        [_deleate videoDidSeekTo:slider.value*_duration];
    }
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:3];
}
- (void)sliderWillBeginDragging:(CNProgressSlider *)slider{
    [self.class cancelPreviousPerformRequestsWithTarget:self
                                               selector:@selector(hideControlView)
                                                 object:nil];
    if (_deleate && [_deleate respondsToSelector:@selector(videoWillSeek)]) {
        [_deleate videoWillSeek];
    }
}

@end

@interface CNVideoLoadingView()
{
    UIImageView *_iconImageView;
}
@end

@implementation CNVideoLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setImage:[UIImage imageNamed:@"icon_loading"]];
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.removedOnCompletion = YES;
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2];
        [_iconImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)startAnimation{
    if(_iconImageView.animating){
        [self stopAnimation];
    }
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = YES;
    //旋转角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2];
    //每次旋转的时间（单位秒）
    rotationAnimation.duration = 1.0f;
    //    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = MAXFLOAT;
    [_iconImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation{
    
    if(_iconImageView.animating) {
        [_iconImageView stopAnimating];
    }
}

- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    if(!hidden){
        [self startAnimation];
        self.alpha = 0.0;
        [UIView animateWithDuration:0.6f
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:nil];
    }else{
        [self stopAnimation];
        self.alpha = 1;
        [UIView animateWithDuration:0.6f
                         animations:^{
                             self.alpha = 0.0;
                         }
                         completion:nil];
    }
}

@end
