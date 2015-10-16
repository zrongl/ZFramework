//
//  ZPhotoView.h
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPhoto.h"

@protocol ZPhotoViewDelegate;

@interface ZPhotoView : UIScrollView

@property (strong, nonatomic) ZPhoto *photo;
@property (assign, nonatomic) id<ZPhotoViewDelegate>tapDelegate;

- (void)resetStatus;

@end

@protocol ZPhotoViewDelegate <NSObject>

- (void)photoViewSimpleTap:(ZPhotoView *)photoView;

@end