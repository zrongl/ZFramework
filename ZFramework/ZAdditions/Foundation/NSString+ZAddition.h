//
//  NSString+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZAddition)

/**
 *  获取字符对应的label宽度
 *
 *  @param font   label字体
 *  @param height label固定高度
 *
 *  @return label宽度 官方文档提示：如果该宽度用于创建label，建议通过ceil函数处理进行处理
 */
- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)height;
- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;

+ (BOOL)controlContent:(NSString *)content
   shouldChangeInRange:(NSRange)range
     replacementString:(NSString *)string;

+ (NSString *)stringWithUUID;

@end
