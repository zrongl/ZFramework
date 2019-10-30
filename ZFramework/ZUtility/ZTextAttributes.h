//
//  ZTextAttributes.h
//  DeepIntoProgramThinking
//
//  Created by ronglei on 16/5/9.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZTextAttributes : NSObject

+ (ZTextAttributes *(^) (NSString *))string;

- (instancetype)initWithString:(NSString *)string;

- (NSAttributedString *(^)(CGFloat))attributeString;
- (CGFloat (^)(CGFloat))attributeStringHeight;

- (ZTextAttributes *(^) (UIFont *))font;
- (ZTextAttributes *(^) (UIFont *, NSString *subString))subfont;
- (ZTextAttributes *(^) (UIColor *))color;
- (ZTextAttributes *(^) (UIColor *, NSString *subString))subcolor;

- (ZTextAttributes *(^) (CGFloat lineSpace))lineSpace;

@end

@interface ZTextAttributes()

{
    NSString *_string;
    NSMutableAttributedString *_attributeString;
    
    NSMutableDictionary *_attributeDictionary;
    NSMutableDictionary *_subStringDictionary;
    NSMutableParagraphStyle *_paragraphStryle;
    NSMutableDictionary *_wholeAttributeDictionary;
}

@end
