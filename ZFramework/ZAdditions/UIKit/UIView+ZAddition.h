//
//  UIView+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 15/9/27.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZAddition)

/**
 *  UIView坐标相关
 *  分类中写@property, 只会生成方法的声明, 不会生成方法的实现和成员变量
 */
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGSize  size;
@property (nonatomic,assign) CGPoint origin;

@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;

@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

+ (id)loadFromNib;
- (void)removeAllSubviews;
- (UIViewController*)viewController;
+ (instancetype)cellForTableView:(UITableView *)tableView;


- (UIImage *)snapshotImage;
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
@end
