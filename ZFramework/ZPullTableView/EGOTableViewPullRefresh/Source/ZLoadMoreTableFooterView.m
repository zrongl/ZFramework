//
//  EGOLoadMoreTableFooterView.m
//  ZFramework
//
//  Created by ronglei on 15/10/8.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZLoadMoreTableFooterView.h"
#import "UIView+ZAddition.h"

@interface ZLoadMoreTableFooterView()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation ZLoadMoreTableFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 184)/2, (frame.size.height - 24.f)/2, 184.f, 24.f)];
        _contentView.backgroundColor = [UIColor clearColor];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 2, 112, 20)];
        _stateLabel.textColor = [UIColor lightGrayColor];
        _stateLabel.font = [UIFont systemFontOfSize:14.f];
        [_contentView addSubview:_stateLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(22, 2, 20, 20);
        [_contentView addSubview:_activityView];
        
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)setState:(ZPullLoadState)state
{
    switch (state) {
        case ZPullLoading:{
            [_activityView startAnimating];
            [_stateLabel setText:@"加载中 ..."];
            [_stateLabel sizeToFit];
            _stateLabel.centerX = _contentView.width/2+20;
            break;
        }
        case ZPullLoadNormal:{
            [_activityView stopAnimating];
            [_stateLabel setText:@"已显示全部"];
            [_stateLabel sizeToFit];
            _stateLabel.centerX = _contentView.width/2;
            break;
        }
        case ZPullLoadNoData:{
            [_activityView stopAnimating];
            [_stateLabel setText:@"暂无数据"];
            [_stateLabel sizeToFit];
            _stateLabel.centerX = _contentView.width/2;
            break;
        }
        default:
            break;
    }
}

@end
