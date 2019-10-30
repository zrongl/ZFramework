//
//  ZAsyncLayer.h
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ZAsyncLayerDisplayTask;

@interface ZAsyncLayer : CALayer
@property BOOL displaysAsynchronously;
@end

@protocol ZAsyncLayerDelegate <NSObject>

@required

- ( ZAsyncLayerDisplayTask * _Nullable )newAsyncDisplayTask;

@end

@interface ZAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer * _Nullable layer);
@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer * _Nullable layer, BOOL finished);
@property (nullable, nonatomic, copy) void (^display)(CGContextRef _Nullable context, CGSize size, BOOL(^ _Nullable isCancelled)(void));

@end