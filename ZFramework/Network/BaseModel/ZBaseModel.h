//
//  LSBaseModel.h
//  LaShouSeller
//
//  Created by ronglei on 15/8/17.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBaseModel : NSObject

/**
 *  将服务端的字典转换为model
 *
 *  @param dic 服务端数据转换成的字典
 *
 *  @return 填充数据的model
 */
- (id)initWithDictionary:(NSDictionary*)dic;

/**
 *  返回model自定义字符名称与服务端字段名称之间的映射字典
 *  {"userName":"user_name"
 *   ...
 *  }
 */
- (NSDictionary*)attributeMapDictionary;

@end
