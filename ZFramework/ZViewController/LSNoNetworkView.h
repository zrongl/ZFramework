//
//  LSNoNetworkView.h
//  LashouBI
//
//  Created by ronglei on 15/1/14.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSNoNetworkViewDelegate;

@interface LSNoNetworkView : UIView

@property (assign, nonatomic) id<LSNoNetworkViewDelegate>delegate;

+ (LSNoNetworkView *)viewFromNib;
- (void)showInView:(UIView *)suprView;
- (void)hide;

@end

@protocol LSNoNetworkViewDelegate <NSObject>
@optional

- (void)noNetworkRetryGetData;

@end