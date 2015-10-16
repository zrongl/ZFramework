//
//  ZPhotoInfoBar.h
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPhotoInfoBar : UIView

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@end
