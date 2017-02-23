//
//  CNGifPlayerView.h
//  CMInstanews
//
//  Created by ronglei on 2016/12/2.
//  Copyright © 2016年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNShortVideoPlayerView : UIView

@property (nonatomic, strong) NSString *pathString;

- (void)play;// 需要先设置pathString 再播放
- (void)reset;// 停止播放 清空数据
- (void)rollback;// 停止播放seek到开始位置 不清空数据

@end
