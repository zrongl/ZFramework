//
//  ZPhoto.h
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPhoto : NSObject

@property (strong, nonatomic) NSString      *url;
@property (strong, nonatomic) NSString      *info;
@property (strong, nonatomic) UIImage       *image;
@property (strong, nonatomic) UIImage       *placeholder;

@property (assign, nonatomic) NSUInteger    index;

@end
