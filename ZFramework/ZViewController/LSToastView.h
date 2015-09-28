//
//  LSToastView.h
//  Hands-Seller
//
//  Created by Bob on 14-4-21.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSToastView : UIView

+ (id)loadFromXib;

/**
*  显示消息提示
*
*  @param msg   消息内容
*/
+(void)showWithMsg:(NSString*)msg;
/**
 *  显示消息提示
 *
 *  @param msg 消息内容
 *  @param offset 消失延时时间
 */
+(void)showWithMsg:(NSString*)msg dismissDelay:(float)offset;
/**
 *  显示消息提示
 *
 *  @param msg 消息内容
 *  @param point 提示框的中心坐标
 */
+(void)showWithMsg:(NSString*)msg center:(CGPoint)point;
/**
 *  显示消息提示
 *  @param msg 消息内容
 *  @param point 提示框的中心坐标
 *  @param offset 消失延时时间
 */
+(void)showWithMsg:(NSString*)msg center:(CGPoint)point dismissDelay:(float)offset;

@end
