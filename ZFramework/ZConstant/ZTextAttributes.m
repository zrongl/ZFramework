//
//  ZTextAttributes.m
//  DeepIntoProgramThinking
//
//  Created by ronglei on 16/5/9.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZTextAttributes.h"

@implementation ZTextAttributes

+ (ZTextAttributes *(^) (NSString *))string
{
    return ^ZTextAttributes * (NSString *string){
        return [[ZTextAttributes alloc] initWithString:string];
    };
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _string = string;
        
        _paragraphStryle = [[NSMutableParagraphStyle alloc] init];
        _attributeDictionary = [[NSMutableDictionary alloc] init];
        _subStringDictionary = [[NSMutableDictionary alloc] init];
        _wholeAttributeDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSAttributedString *(^)(CGFloat))attributeString
{
    return ^NSAttributedString *(CGFloat width){
        
        UIFont *font = _wholeAttributeDictionary[NSFontAttributeName];
        CGFloat height = [_string heightWithFont:font width:width];
        if (height < font.pointSize*2) {
            // 如果一行将行间距置为0
            [_paragraphStryle setLineSpacing:0];
            _wholeAttributeDictionary[NSParagraphStyleAttributeName] = _paragraphStryle;
        }
        
        _attributeString = [[NSMutableAttributedString alloc] initWithString:_string
                                                                  attributes:_wholeAttributeDictionary];
        
        for (NSString *attributeName in _subStringDictionary.allKeys) {
            NSRange range = [_string rangeOfString:_subStringDictionary[attributeName]];
            [_attributeString addAttribute:attributeName
                                     value:_attributeDictionary[attributeName]
                                     range:range];
        }
        
        return _attributeString;
    };
}

- (CGFloat (^)(CGFloat))attributeStringHeight
{
    return ^CGFloat (CGFloat width){
        UIFont *font = _wholeAttributeDictionary[NSFontAttributeName];
        CGFloat height = [_string heightWithFont:font width:width];
        if (height < font.pointSize*2) {
            // 如果一行将行间距置为0
            [_paragraphStryle setLineSpacing:0];
            _wholeAttributeDictionary[NSParagraphStyleAttributeName] = _paragraphStryle;
            
            if (!_attributeString) {
                _attributeString = [[NSMutableAttributedString alloc] initWithString:_string
                                                                          attributes:_wholeAttributeDictionary];
                
                for (NSString *attributeName in _subStringDictionary.allKeys) {
                    NSRange range = [_string rangeOfString:_subStringDictionary[attributeName]];
                    [_attributeString addAttribute:attributeName
                                             value:_attributeDictionary[attributeName]
                                             range:range];
                }
            }
            
            CGRect rect = [_attributeString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
            
            return rect.size.height;
        }
        return height;
    };
}

- (ZTextAttributes *(^) (UIFont *))font
{
    return ^ZTextAttributes *(UIFont *font){
        _wholeAttributeDictionary[NSFontAttributeName] = font;
        
        return self;
    };
}

- (ZTextAttributes *(^) (UIFont *, NSString *subString))subfont
{
    return ^ZTextAttributes *(UIFont *font, NSString *subString){
        if (subString != nil) {
            _attributeDictionary[NSFontAttributeName] = font;
            _subStringDictionary[NSFontAttributeName] = subString;
        }
        
        return self;
    };
}

- (ZTextAttributes *(^) (UIColor *))color
{
    return ^ZTextAttributes *(UIColor *color){
        _wholeAttributeDictionary[NSForegroundColorAttributeName] = color;

        return self;
    };
}

- (ZTextAttributes *(^) (UIColor *, NSString *subString))subcolor
{
    return ^ZTextAttributes *(UIColor *color, NSString *subString){
        if (subString != nil) {
            _attributeDictionary[NSForegroundColorAttributeName] = color;
            _subStringDictionary[NSForegroundColorAttributeName] = subString;
        }
        
        return self;
    };
}

- (ZTextAttributes *(^) (CGFloat lineSpace))lineSpace
{
    return ^ZTextAttributes *(CGFloat lineSpace){
        [_paragraphStryle setLineSpacing:lineSpace];
        _wholeAttributeDictionary[NSParagraphStyleAttributeName] = _paragraphStryle;
        
        return self;
    };
}

@end
